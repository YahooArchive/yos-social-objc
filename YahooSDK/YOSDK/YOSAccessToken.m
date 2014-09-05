//
//  YOSAccessToken.m
//  YOSSocial
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSAccessToken.h"
#import "NSData+OAuthResponse.h"

@implementation YOSAccessToken

#pragma mark - Lifecycle

+ (instancetype)tokenFromResponse:(NSData *)responseData
{
	NSDictionary *tokenDictionary = nil;
	@try {
		tokenDictionary = [responseData OAuthTokenResponse];
	} @catch (id responseException) {
		return nil;
	}
	
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"oauth_expires_in"] intValue];
	NSInteger authExpires = [[tokenDictionary valueForKey:@"oauth_authorization_expires_in"] intValue];
	
	YOSAccessToken *token = [[YOSAccessToken alloc] initWithKey:[tokenDictionary valueForKey:@"oauth_token"]
                                                      andSecret:[tokenDictionary valueForKey:@"oauth_token_secret"]];

    token.guid = [tokenDictionary valueForKey:@"xoauth_yahoo_guid"];
    token.sessionHandle = [tokenDictionary valueForKey:@"oauth_session_handle"];
    token.tokenExpires = tokenExpires;
    token.authExpires = authExpires;
    token.tokenExpiresDate = [NSDate dateWithTimeIntervalSinceNow:tokenExpires];
    token.authExpiresDate = [NSDate dateWithTimeIntervalSinceNow:authExpires];
	
	return token;
}

+ (instancetype)tokenFromStoredDictionary:(NSDictionary *)tokenDictionary
{
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"tokenExpires"] intValue];
	NSInteger authExpires = [[tokenDictionary valueForKey:@"authExpires"] intValue];
	
	YOSAccessToken *token = [[YOSAccessToken alloc] initWithKey:[tokenDictionary valueForKey:@"key"]
                                                      andSecret:[tokenDictionary valueForKey:@"secret"]];
	
    token.guid = [tokenDictionary valueForKey:@"guid"];
    token.sessionHandle = [tokenDictionary valueForKey:@"sessionHandle"];
    token.tokenExpires = tokenExpires;
    token.authExpires = authExpires;
    token.tokenExpiresDate = [tokenDictionary valueForKey:@"tokenExpiresDate"];
    token.authExpiresDate = [tokenDictionary valueForKey:@"authExpiresDate"];

	if ([tokenDictionary valueForKey:@"consumer"]) {
        token.consumer = [tokenDictionary valueForKey:@"consumer"];
	}
	
	return token;
}

#pragma mark - Public methods

- (NSMutableDictionary *)tokenAsDictionary
{
	NSMutableDictionary *tokenDictionary = [[NSMutableDictionary alloc] init];

	tokenDictionary[@"key"] = self.key;
	tokenDictionary[@"secret"] = self.secret;
	tokenDictionary[@"guid"] = self.guid;
	tokenDictionary[@"sessionHandle"] = self.sessionHandle;
	tokenDictionary[@"tokenExpires"] = @(self.tokenExpires);
	tokenDictionary[@"authExpires"] = @(self.authExpires);
    tokenDictionary[@"authExpiresDate"] = self.authExpiresDate;
    tokenDictionary[@"tokenExpiresDate"] = self.tokenExpiresDate;
    
	if (self.consumer) {
        tokenDictionary[@"consumer"] = self.consumer;
    }
	
	return tokenDictionary;
}

- (BOOL)tokenHasExpired
{
	NSDate *dateAsNow = [NSDate date];
	BOOL isExpired = !([dateAsNow compare:self.tokenExpiresDate] == NSOrderedAscending);
	
	return isExpired; 
}

@end
