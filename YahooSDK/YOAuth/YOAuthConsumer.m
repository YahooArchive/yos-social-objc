//
//  YOAuthConsumer.m
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Update by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthConsumer.h"

@implementation YOAuthConsumer

#pragma mark - Lifecycle

+ (instancetype)consumerWithKey:(NSString *)key andSecret:(NSString *)secret
{
	return [[self alloc] initWithKey:key andSecret:secret];
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
