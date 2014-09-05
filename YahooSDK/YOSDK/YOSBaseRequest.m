//
//  YOSBaseRequest.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Updated by Michael Ho on 8/22/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSBaseRequest.h"

static NSString *const kRequestBaseUrl = @"https://social.yahooapis.com";
static NSString *const kRequestBaseVersion = @"v1";
static NSString *const kRequestBaseFormat = @"json";
static NSString *const kRequestBaseSignatureMethod = @"HMAC-SHA1";

@implementation YOSBaseRequest

#pragma mark - Lifecycle

+ (instancetype)requestWithSession:(YahooSession *)session
{
	YOSUser *user = [[YOSUser alloc] initWithSession:session];
	return [[self alloc] initWithYOSUser:user];
}

- (instancetype)init
{
	if (self = [super init]) {
        self.baseUrl = kRequestBaseUrl;
        self.format = kRequestBaseFormat;
        self.apiVersion =kRequestBaseVersion;
        self.signatureMethod = kRequestBaseSignatureMethod;
	}
	return self;
}

- (instancetype)initWithYOSUser:(YOSUser *)sessionedUser
{
	if (self = [self init]) {
        self.user = sessionedUser;
	}
	return self;
}

- (instancetype)initWithConsumer:(YOAuthConsumer *)consumer
{
	if (self = [self init]) {
        self.consumer = consumer;
	}
	return self;
}

#pragma mark - Protected

- (YOAuthConsumer *)oauthConsumer
{
	YOAuthConsumer *theConsumer = (self.user) ? [self.user.session consumer] : self.consumer;
	return theConsumer;
}

- (YOAuthToken *)oauthToken
{
	YOAuthToken *theToken = (self.user) ? [self.user.session accessToken] : self.token;
	return theToken;
}

- (YOSRequestClient *)requestClient
{
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self oauthConsumer]
																 andToken:[self oauthToken]];
	return client;
}

- (id)deserializeJSON:(NSData *)value
{
	NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:value options:0 error:&error];
    if (error) {
        NSString *string = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
        NSLog(@"ERROR: deserializing value: %@, raason: %@", string, error);
    }
    return returnValue;
}

- (NSData *)serializeDictionary:(NSDictionary *)dictionary
{
	// if you are using another JSON encoder/decoder, you can swap it out here.
    NSError *error = nil;
	NSData *returnValue = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error) {
        NSLog(@"ERROR: Serializing Dictionary: %@, reason: %@", dictionary, error);
    }
    return returnValue;
}

@end
