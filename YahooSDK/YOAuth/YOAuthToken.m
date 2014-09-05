//
//  YOAuthToken.m
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/20/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthToken.h"

@implementation YOAuthToken

#pragma mark - Lifecycle

+ (instancetype)tokenWithKey:(NSString *)key andSecret:(NSString *)secret
{
	return [[self alloc] initWithKey:key
                           andSecret:secret];
}

+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary
{
	return [self tokenWithKey:[dictionary valueForKey:@"oauth_token"]
                    andSecret:[dictionary valueForKey:@"oauth_token_secret"]];
}

- (instancetype)initWithKey:(NSString *)key andSecret:(NSString *)secret
{
	if(self = [super init]) {
        self.key = key;
        self.secret = secret;
	}
	
	return self;
}

@end
