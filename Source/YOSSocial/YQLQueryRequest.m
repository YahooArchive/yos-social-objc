//
//  YOSQueryRequest.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YQLQueryRequest.h"

static NSString *const kYQLBaseUrl = @"http://query.yahooapis.com";

@implementation YQLQueryRequest

@synthesize environmentFile;

#pragma mark init

+ (id)requestWithSession:(YOSSession *)session
{
	YOSUser *sessionedUser = [[YOSUser alloc] initWithSession:session];
	YQLQueryRequest *request = [[YQLQueryRequest alloc] initWithYOSUser:sessionedUser];
	
	[sessionedUser autorelease];
	[request autorelease];
	
	return request;
}

#pragma mark -
#pragma mark Public

- (void)query:(NSString *)aQuery withDelegate:(id)delegate
{
	YOSRequestClient *client = [self generateRequest:aQuery];

	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
}


- (YOSResponseData *)query:(NSString *)aQuery
{	
	YOSRequestClient *client = [self generateRequest:aQuery];
	
	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];

	[client release];
	
	if(!response.didSucceed) {
		return nil;
	}
	
	return response;
}

- (BOOL)updateQuery:(NSString *)aQuery
{	
	YOSRequestClient *client = [self generateRequest:aQuery];
	
	[client setHTTPMethod:@"PUT"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	
	[client release];
	
	if (!response.didSucceed) {
		return NO;
	}
	
	return YES;
}


#pragma mark -
#pragma mark private

- (YOSRequestClient *)generateRequest:(NSString *)aQuery
{
	// If a consumer is not available, we can assume public tables are being used
	// and we'll use the public yql endpoint. 
	NSString *requestUrl = ([self consumerForRequest] != nil)
		?[NSString stringWithFormat:@"%@/%@/%@",kYQLBaseUrl,self.apiVersion,@"yql"]
 		:[NSString stringWithFormat:@"%@/%@/%@/%@",kYQLBaseUrl,self.apiVersion,@"public",@"yql"];
	
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:aQuery forKey:@"q"];
	[requestParameters setObject:self.format forKey:@"format"];
	
	if(self.environmentFile != nil) 
		[requestParameters setObject:self.environmentFile forKey:@"env"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setRequestUrl:url];
	[client setRequestParameters:requestParameters];
	
	return client;
}

@end

