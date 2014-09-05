//
//  YOSRequestToken.m
//  YOSSocial
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSRequestToken.h"
#import "NSData+OAuthResponse.h"


@implementation YOSRequestToken

#pragma mark - Lifecycle

+ (instancetype)tokenFromResponse:(NSData *)responseData
{
	NSDictionary *tokenDictionary = nil;
	@try {
		tokenDictionary = [responseData OAuthTokenResponse];
	} @catch (id responseException) {
		return nil;
	}
	
	BOOL isCallbackConfirmed = [[tokenDictionary valueForKey:@"oauth_callback_confirmed"] isEqualToString:@"true"];
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"oauth_expires_in"] intValue];
	
	YOSRequestToken *token = [[self alloc] initWithKey:[tokenDictionary valueForKey:@"oauth_token"]
                                             andSecret:[tokenDictionary valueForKey:@"oauth_token_secret"]];
	
    token.requestAuthUrl = [tokenDictionary valueForKey:@"xoauth_request_auth_url"];
    token.tokenExpires = tokenExpires;
    token.tokenExpiresDate = [NSDate dateWithTimeIntervalSinceNow:tokenExpires];
    token.callbackConfirmed = isCallbackConfirmed;
	
	return token;
}

+ (instancetype)tokenFromStoredDictionary:(NSDictionary *)tokenDictionary;
{
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"tokenExpires"] intValue];
	
	YOSRequestToken *token = [[self alloc] initWithKey:[tokenDictionary valueForKey:@"key"]
                                             andSecret:[tokenDictionary valueForKey:@"secret"]];
	
    token.requestAuthUrl = [tokenDictionary valueForKey:@"requestAuthUrl"];
    token.tokenExpires = tokenExpires;
    token.tokenExpiresDate = [NSDate dateWithTimeIntervalSinceNow:tokenExpires];
    token.verifier = [tokenDictionary valueForKey:@"verifier"];
	
	return token;
}

#pragma mark - Public methods

- (NSMutableDictionary *)tokenAsDictionary
{
	NSMutableDictionary *tokenDictionary = [[NSMutableDictionary alloc] init];

	tokenDictionary[@"key"] = self.key;
	tokenDictionary[@"secret"] = self.secret;
	tokenDictionary[@"tokenExpires"] = @(self.tokenExpires);
	tokenDictionary[@"requestAuthUrl"] = self.requestAuthUrl;
    if (self.verifier) {
        tokenDictionary[@"verifier"] = self.verifier;
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
