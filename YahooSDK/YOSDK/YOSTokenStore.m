//
//  YOSTokenStore.m
//  YOSSocial
//
//  Created by Zach Graves on 2/23/09.
//  Updated by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//


#import "YOSTokenStore.h"

@implementation YOSTokenStore

#pragma mark - Lifecycle

- (instancetype)initWithConsumer:(YOAuthConsumer *)consumer
{
	if(self = [self init]) {
        self.consumer = consumer;
	}
	return self;
}

#pragma mark - Access token

- (YOSAccessToken *)accessToken
{
	NSDictionary *tokenDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:OAuthAccessToken", self.consumer.key]];
	
	if(tokenDictionary && [tokenDictionary count]) {
		YOSAccessToken *oauthToken = [YOSAccessToken tokenFromStoredDictionary:tokenDictionary];
		return oauthToken;
	} else {
		return nil;
	}
}

- (BOOL)hasAccessToken
{
	return (self.accessToken != nil);
}

- (void)setAccessToken:(YOSAccessToken *)token
{    
	[[NSUserDefaults standardUserDefaults] setObject:[token tokenAsDictionary]
											  forKey:[NSString stringWithFormat:@"%@:OAuthAccessToken", self.consumer.key]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAccessToken
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@:OAuthAccessToken", self.consumer.key]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Request token

- (YOSRequestToken *)requestToken
{
	NSDictionary *tokenDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@:OAuthRequestToken", self.consumer.key]];
	
	if(tokenDictionary && [tokenDictionary count]) {
		YOSRequestToken *oauthToken = [YOSRequestToken tokenFromStoredDictionary:tokenDictionary];
		return oauthToken;
	} else {
		return nil;
	}
}

- (BOOL)hasRequestToken
{
	return (self.requestToken != nil);
}

- (void)setRequestToken:(YOSRequestToken *)token
{
	[[NSUserDefaults standardUserDefaults] setObject:[token tokenAsDictionary]
											  forKey:[NSString stringWithFormat:@"%@:OAuthRequestToken", self.consumer.key]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeRequestToken
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@:OAuthRequestToken", self.consumer.key]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
