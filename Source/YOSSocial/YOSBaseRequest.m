//
//  YOSBaseRequest.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSBaseRequest.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

static NSString *const kRequestBaseUrl = @"http://social.yahooapis.com";
static NSString *const kRequestBaseVersion = @"v1";
static NSString *const kRequestBaseFormat = @"json";
static NSString *const kRequestBaseSignatureMethod = @"HMAC-SHA1";

@implementation YOSBaseRequest

@synthesize signatureMethod;
@synthesize baseUrl;
@synthesize format;
@synthesize apiVersion;
@synthesize user;
@synthesize consumer;
@synthesize token;

#pragma mark init

+ (id)requestWithSession:(YOSSession *)session
{
	YOSUser *user = [[[YOSUser alloc] initWithSession:session] autorelease];
	YOSBaseRequest *request = [[YOSBaseRequest alloc] initWithYOSUser:user];
	
	return [request autorelease];
}

- (id)init
{
	if(self = [super init]) {
		[self setBaseUrl:kRequestBaseUrl];
		[self setFormat:kRequestBaseFormat];
		[self setApiVersion:kRequestBaseVersion];
		[self setSignatureMethod:kRequestBaseSignatureMethod];
	}
	return self;
}

- (id)initWithYOSUser:(YOSUser *)aSessionedUser
{
	if(self = [self init]) {
		[self setUser:aSessionedUser];
	}
	
	return self;
}

- (id)initWithConsumer:(YOAuthConsumer *)aConsumer
{
	if(self = [self init]) {
		[self setConsumer:aConsumer];
	}
	return self;
}

#pragma mark -
#pragma mark Protected

- (YOAuthConsumer *)oauthConsumer
{
	YOAuthConsumer *theConsumer = (user) ? [user.session consumer] : consumer;	
	return theConsumer;
}

- (YOAuthToken *)oauthToken
{
	YOAuthToken *theToken = (user) ? [user.session accessToken] : token;
	return theToken;
}

- (YOSRequestClient *)requestClient
{
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self oauthConsumer]
																 andToken:[self oauthToken]];
	
	return [client autorelease];
}

- (id)deserializeJSON:(NSString *)aJSONString
{
	// if you are using another JSON encoder/decoder, you can swap it out here.
	return [aJSONString JSONValue];
}

- (NSString *)serializeDictionary:(NSDictionary *)aDictionary
{
	// if you are using another JSON encoder/decoder, you can swap it out here.
	return [aDictionary JSONRepresentation];
}

@end
