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
static NSString *const kYQLOpenTables = @"store://datatables.org/alltableswithkeys";

@implementation YQLQueryRequest

@synthesize environmentFile;
@synthesize diagnostics;

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

- (BOOL)query:(NSString *)aQuery withDelegate:(id)delegate
{
	YOSRequestClient *client = [self generateRequest:aQuery];
	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	return [client sendAsyncRequestWithDelegate:delegate];
}


- (YOSResponseData *)query:(NSString *)aQuery
{	
	YOSRequestClient *client = [self generateRequest:aQuery];
	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	
	if(!response.didSucceed) {
		return nil;
	}
	
	return response;
}

- (BOOL)updateQuery:(NSString *)aQuery withDelegate:(id)delegate
{
	YOSRequestClient *client = [self generateRequest:aQuery];
	[client setHTTPMethod:@"PUT"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)updateQuery:(NSString *)aQuery
{	
	YOSRequestClient *client = [self generateRequest:aQuery];
	[client setHTTPMethod:@"PUT"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	
	return (response.didSucceed);
}

- (NSString *)queryByJoiningQueries:(NSArray *)queries
{
	NSString *joinedQueries = [[queries componentsJoinedByString:@";"] stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
	return [NSString stringWithFormat:@"select * from query.multi where queries=\"%@\"", joinedQueries];
}


#pragma mark -
#pragma mark private

- (YOSRequestClient *)generateRequest:(NSString *)aQuery
{
	if(!self.environmentFile) [self setEnvironmentFile:kYQLOpenTables];
	
	// If a consumer is not available, we can assume public tables are being used
	// and we'll use the public yql endpoint. 
	NSString *requestUrl = ([self oauthConsumer]) ? [NSString stringWithFormat:@"%@/%@/%@", kYQLBaseUrl, self.apiVersion, @"yql"]
	: [NSString stringWithFormat:@"%@/%@/%@/%@", kYQLBaseUrl, self.apiVersion, @"public", @"yql"];
	
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	[requestParameters setObject:aQuery forKey:@"q"];
	[requestParameters setObject:self.format forKey:@"format"];
	
	NSString *useDiagnostics = (self.diagnostics) ? @"true" : @"false";
	[requestParameters setObject:useDiagnostics forKey:@"diagnostics"];
	[requestParameters setObject:self.environmentFile forKey:@"env"];
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setRequestParameters:requestParameters];
	
	return client;
}

@end

