//
//  YOSRequestToken.m
//  YOSSocial
//
//  Created by Zach Graves on 2/14/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSRequestToken.h"
#import "NSData+OAuthResponse.h"


@implementation YOSRequestToken

@synthesize requestAuthUrl;
@synthesize tokenExpires;
@synthesize tokenExpiresDate;
@synthesize callbackConfirmed;

#pragma mark init

+ (YOSRequestToken *)tokenFromResponse:(NSData *)responseData
{
	NSDictionary *tokenDictionary = [responseData OAuthTokenResponse];
	
	BOOL isCallbackConfirmed = [[tokenDictionary valueForKey:@"oauth_callback_confirmed"] isEqualToString:@"true"];
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"oauth_expires_in"] intValue];
	
	YOSRequestToken *theToken = [[YOSRequestToken alloc] initWithKey:[tokenDictionary valueForKey:@"oauth_token"]
														   andSecret:[tokenDictionary valueForKey:@"oauth_token_secret"]];
	
	[theToken autorelease];
	[theToken setRequestAuthUrl:[tokenDictionary valueForKey:@"xoauth_request_auth_url"]];
	[theToken setTokenExpires:tokenExpires];
	[theToken setTokenExpiresDate:[NSDate dateWithTimeIntervalSinceNow:tokenExpires]];
	[theToken setCallbackConfirmed:isCallbackConfirmed];
	
	return theToken;
}

+ (YOSRequestToken *)tokenFromStoredDictionary:(NSDictionary *)tokenDictionary;
{
	NSInteger tokenExpires = [[tokenDictionary valueForKey:@"tokenExpires"] intValue];
	
	YOSRequestToken *theToken = [[YOSRequestToken alloc] initWithKey:[tokenDictionary valueForKey:@"key"]
														   andSecret:[tokenDictionary valueForKey:@"secret"]];
	[theToken autorelease];
	[theToken setRequestAuthUrl:[tokenDictionary valueForKey:@"requestAuthUrl"]];
	[theToken setTokenExpires:tokenExpires];
	[theToken setTokenExpiresDate:[NSDate dateWithTimeIntervalSinceNow:tokenExpires]];
	
	return theToken;
}

#pragma mark -
#pragma mark Public

- (NSMutableDictionary *)tokenAsDictionary
{
	NSMutableDictionary *tokenDictionary = [[NSMutableDictionary alloc] init];
	[tokenDictionary autorelease];
	[tokenDictionary setObject:self.key forKey:@"key"];
	[tokenDictionary setObject:self.secret forKey:@"secret"];
	[tokenDictionary setObject:[NSNumber numberWithInt:self.tokenExpires] forKey:@"tokenExpires"];
	[tokenDictionary setObject:self.requestAuthUrl forKey:@"requestAuthUrl"];
	
	return tokenDictionary;
}

- (BOOL)tokenHasExpired
{
	NSDate *dateAsNow = [NSDate date];
	BOOL isExpired = !([dateAsNow compare:tokenExpiresDate] == NSOrderedAscending);
	
	return isExpired; 
}

@end
