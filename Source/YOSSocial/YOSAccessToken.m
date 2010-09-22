//
//  YOSAccessToken.m
//  YOSSocial
//
//  Created by Zach Graves on 2/14/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSAccessToken.h"
#import "NSData+OAuthResponse.h"


@implementation YOSAccessToken

@synthesize guid;
@synthesize sessionHandle;
@synthesize consumer;
@synthesize tokenExpiresDate;
@synthesize authExpiresDate;

#pragma mark init

+ (YOSAccessToken *)tokenFromResponse:(NSData *)responseData
{
	NSDictionary *tokenDictionary = nil;
	@try {
		tokenDictionary = [responseData OAuthTokenResponse];
	} @catch (id responseException) {
		return nil;
	}
	
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"oauth_expires_in"] intValue];
	NSInteger authExpires = [[tokenDictionary valueForKey:@"oauth_authorization_expires_in"] intValue];
	
	YOSAccessToken *theToken = [[YOSAccessToken alloc] initWithKey:[tokenDictionary valueForKey:@"oauth_token"]
														 andSecret:[tokenDictionary valueForKey:@"oauth_token_secret"]];
	[theToken autorelease];
	[theToken setGuid:[tokenDictionary valueForKey:@"xoauth_yahoo_guid"]];
	[theToken setSessionHandle:[tokenDictionary valueForKey:@"oauth_session_handle"]];
	[theToken setTokenExpiresDate:[NSDate dateWithTimeIntervalSinceNow:tokenExpires]];
	[theToken setAuthExpiresDate:[NSDate dateWithTimeIntervalSinceNow:authExpires]];
	
	return theToken;
}

+ (YOSAccessToken *)tokenFromStoredDictionary:(NSDictionary *)tokenDictionary
{
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"tokenExpires"] intValue];
	NSInteger authExpires = [[tokenDictionary valueForKey:@"authExpires"] intValue];
	
	YOSAccessToken *theToken = [[YOSAccessToken alloc] initWithKey:[tokenDictionary valueForKey:@"key"]
														 andSecret:[tokenDictionary valueForKey:@"secret"]];
	[theToken autorelease];
	[theToken setGuid:[tokenDictionary valueForKey:@"guid"]];
	[theToken setSessionHandle:[tokenDictionary valueForKey:@"sessionHandle"]];
	[theToken setTokenExpiresDate:[NSDate dateWithTimeIntervalSinceReferenceDate:tokenExpires]];
	[theToken setAuthExpiresDate:[NSDate dateWithTimeIntervalSinceReferenceDate:authExpires]];
	
	if([tokenDictionary valueForKey:@"consumer"]) {
		[theToken setConsumer:[tokenDictionary valueForKey:@"consumer"]];
	}
	
	return theToken;
}

#pragma mark -
#pragma mark Public

- (NSMutableDictionary *)tokenAsDictionary
{
	NSInteger tokenExpires = [[self tokenExpiresDate] timeIntervalSinceReferenceDate];
	NSInteger authExpires = [[self authExpiresDate] timeIntervalSinceReferenceDate];
  
	NSMutableDictionary *tokenDictionary = [[NSMutableDictionary alloc] init];
	[tokenDictionary autorelease];
	[tokenDictionary setObject:self.key forKey:@"key"];
	[tokenDictionary setObject:self.secret forKey:@"secret"];
	[tokenDictionary setObject:self.guid forKey:@"guid"];
	[tokenDictionary setObject:self.sessionHandle forKey:@"sessionHandle"];
	[tokenDictionary setObject:[NSNumber numberWithDouble:tokenExpires] forKey:@"tokenExpires"];
	[tokenDictionary setObject:[NSNumber numberWithDouble:authExpires] forKey:@"authExpires"];
	
	if(self.consumer) [tokenDictionary setObject:self.consumer forKey:@"consumer"];
	
	return tokenDictionary;
}

- (BOOL)tokenHasExpired
{
	NSDate *dateAsNow = [NSDate date];
	BOOL isExpired = !([dateAsNow compare:tokenExpiresDate] == NSOrderedAscending);
	
	return isExpired; 
}

@end
