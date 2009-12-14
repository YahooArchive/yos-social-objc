//
//  YOSSession.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSSession.h"
#import "YOSAuthRequest.h"

@implementation YOSSession

@synthesize consumer;
@synthesize accessToken;
@synthesize requestToken;
@synthesize applicationId;
@synthesize tokenStore;
@synthesize verifier;

#pragma mark init

+ (YOSSession *)sessionWithConsumerKey:(NSString *)aConsumerKey 
					 andConsumerSecret:(NSString *)aConsumerSecret 
					  andApplicationId:(NSString *)anApplicationId
{
	YOAuthConsumer *sessionConsumer = [YOAuthConsumer consumerWithKey:aConsumerKey andSecret:aConsumerSecret];
	YOSSession *session = [[YOSSession alloc] initWithConsumer:sessionConsumer andApplicationId:anApplicationId];
	
	return [session autorelease];
}

- (id)initWithConsumer:(YOAuthConsumer *)aConsumer andApplicationId:(NSString *)anApplicationId
{
	if(self = [self init])
	{
		[self setConsumer:aConsumer];
		[self setApplicationId:anApplicationId];
		
		YOSTokenStore *sessionTokenStore = [[[YOSTokenStore alloc] initWithConsumer:aConsumer] autorelease];
		[self setTokenStore:sessionTokenStore];
	}
	return self;
}

#pragma mark -
#pragma mark Public

- (void)clearSession
{
	[self setAccessToken:nil];
	[self setRequestToken:nil];
	
	if(self.tokenStore) {
		[tokenStore removeAccessToken];
		[tokenStore removeRequestToken];
	}
}

- (void)saveSession
{
	if(self.tokenStore) 
	{
		if(self.accessToken) {
			[tokenStore setAccessToken:self.accessToken];
		} else {
			[tokenStore removeAccessToken];
		}
		
		if(self.requestToken) {
			[tokenStore setRequestToken:self.requestToken];
		} else {
			[tokenStore removeRequestToken];
		}	
	}
}

- (BOOL)resumeSession
{	
	YOSAuthRequest *tokenAuthRequest = [YOSAuthRequest requestWithSession:self];
	
	if([tokenStore hasRequestToken] && self.requestToken == nil) {
		[self setRequestToken:[tokenStore requestToken]];
	} else if ([tokenStore hasAccessToken] && self.accessToken == nil) {
		[self setAccessToken:[tokenStore accessToken]];
	}
	
	if(self.requestToken) {
		if(![requestToken key] || ![requestToken secret]) {
			return FALSE;
		}
		
		// check if the request token has expired.
		// if expired, return FALSE as there is no session to resume.
		if([self.requestToken tokenHasExpired]) {
			// NSLog(@"Request token (%@) has expired.", self.requestToken.key);
			return FALSE;
		}
		
		if(self.verifier == nil) {
			// NSLog(@"OAuth Verifier value is null");
			return FALSE;
		}
		
		// exchange the request token for an access token.
		YOSAccessToken *newAccessToken = [tokenAuthRequest fetchAccessToken:self.requestToken withVerifier:self.verifier];
		
		// check for the presence of a key and secret,
		// if missing the session is invalid, most likely 
		// because the user did not authorize the app.
		// if invalid just wait to return FALSE at the end.
		if(newAccessToken.key && newAccessToken.secret) {
			// set and save the sessions access token
			[self setAccessToken:newAccessToken];
			[self setRequestToken:nil];	
			[self saveSession];		
			
			// session is ready
			return TRUE;
		}
	} else if(self.accessToken) {
		if(!accessToken.key || !accessToken.secret) {
			return FALSE;
		}
		
		//YOSAccessToken *storedAccessToken = [self.tokenStore accessToken];
		//[self setAccessToken:storedAccessToken];
		
		// check if the access token has expired
		// if expired we can try to renew it.
		if([self.accessToken tokenHasExpired]) {
			// NSLog(@"Access token (%@) has expired.", storedAccessToken.key);
			
			YOSAccessToken *refreshedAccessToken = [tokenAuthRequest fetchAccessToken:self.accessToken withVerifier:nil];
			
			// check for the presence of a key and secret
			// if missing the session is invalid, likely because the 
			// user or service provider has revoked the access token.
			if(refreshedAccessToken.key && refreshedAccessToken.secret) {
				// if we have a new, valid token
				// set and save the sessions new access token
				[self setAccessToken:refreshedAccessToken];
				[self setRequestToken:nil];
				[self saveSession];
			}else{
				// [self.tokenStore clearSession];
				return FALSE;
			}
		}
		
		// session is ready.
		return TRUE;
	}
	
	// no tokens found, start by directing the user to login
	// with sendUserToAuthorizationWithCallbackUrl
	return FALSE;
}

- (void)sendUserToAuthorizationWithCallbackUrl:(NSString *)callbackUrl
{
	// create a new YOSAuthRequest used to fetch OAuth tokens.
	YOSAuthRequest *tokenAuthRequest = [YOSAuthRequest requestWithSession:self];
	
	// fetch a new request token from oauth.
	YOSRequestToken *newRequestToken = [tokenAuthRequest fetchRequestTokenWithCallbackUrl:callbackUrl];
	
	// if it looks like we have a valid request token
	if(newRequestToken && newRequestToken.key && newRequestToken.secret) {
		// store the request token for later use
		[self setRequestToken:newRequestToken];
		[self saveSession];
		
		// create an authorization URL for the request token
		NSURL *authorizationUrl = [tokenAuthRequest authUrlForRequestToken:requestToken];
		
		//NSLog(@"authorizationUrl: %@",[authorizationUrl absoluteString]);
		
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
		// open safari with the auth url.
		[[UIApplication sharedApplication] openURL:authorizationUrl];
#endif
#if (TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR))
		// open the standard browser with the auth url.
		[[NSWorkspace sharedWorkspace] openURL:authorizationUrl];
#endif
		
	} else {
		// NSLog(@"error fetching request token. check your consumer key and secret.");
	}
}


@end
