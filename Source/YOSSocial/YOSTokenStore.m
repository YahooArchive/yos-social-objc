//
//  YOSTokenStore.m
//  YOSSocial
//
//  Created by Zach Graves on 2/23/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//


#import "YOSTokenStore.h"


@implementation YOSTokenStore

@synthesize consumer;

#pragma mark init

- (id)initWithConsumer:(YOAuthConsumer *)theConsumer
{
	if(self = [self init]) {
		[self setConsumer:theConsumer];
	}
	return self;
}

#pragma mark -
#pragma mark Public

- (BOOL)hasAccessToken
{
	return ([self accessToken] != nil);
}

- (BOOL)hasRequestToken
{
	return ([self requestToken] != nil);
}

- (YOSAccessToken *)accessToken
{
	NSDictionary *tokenDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:OAuthAccessToken", consumer.key]];
	
	if(tokenDictionary && [tokenDictionary count]) {
		YOSAccessToken *oauthToken = [YOSAccessToken tokenFromStoredDictionary:tokenDictionary];
		return oauthToken;
	} else {
		return nil;
	}
}

- (BOOL)setAccessToken:(YOSAccessToken *)theToken
{
	[[NSUserDefaults standardUserDefaults] setObject:[theToken tokenAsDictionary] 
											  forKey:[NSString stringWithFormat:@"%@:OAuthAccessToken", consumer.key]];
	
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)removeAccessToken
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@:OAuthAccessToken", consumer.key]];
	
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (YOSRequestToken *)requestToken
{
	NSDictionary *tokenDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:OAuthRequestToken", consumer.key]];
	
	if(tokenDictionary && [tokenDictionary count]) {
		YOSRequestToken *oauthToken = [YOSRequestToken tokenFromStoredDictionary:tokenDictionary];
		return oauthToken;
	} else {
		return nil;
	}
}

- (BOOL)setRequestToken:(YOSRequestToken *)theToken
{
	[[NSUserDefaults standardUserDefaults] setObject:[theToken tokenAsDictionary] 
											  forKey:[NSString stringWithFormat:@"%@:OAuthRequestToken", consumer.key]];
	
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)removeRequestToken
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@:OAuthRequestToken", consumer.key]];
	
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
