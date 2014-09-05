//
//  YOSQueryRequest.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Updated by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YQLQueryRequest.h"

static NSString *const kYQLBaseUrl = @"https://query.yahooapis.com";
static NSString *const kYQLOpenTables = @"store://datatables.org/alltableswithkeys";

@implementation YQLQueryRequest

#pragma mark - Lifecycle

+ (instancetype)requestWithSession:(YahooSession *)session
{
	YOSUser *sessionedUser = [[YOSUser alloc] initWithSession:session];
	YQLQueryRequest *request = [[YQLQueryRequest alloc] initWithYOSUser:sessionedUser];
	
	return request;
}

#pragma mark - Public methods

- (BOOL)query:(NSString *)query withDelegate:(id)delegate
{
	YOSRequestClient *client = [self generateRequest:query];
	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	return [client sendAsyncRequestWithDelegate:delegate];
}


- (YOSResponseData *)query:(NSString *)query
{	
	YOSRequestClient *client = [self generateRequest:query];
	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	
	if(!response.didSucceed) {
		return nil;
	}
	
	return response;
}

- (BOOL)updateQuery:(NSString *)query withDelegate:(id)delegate
{
	YOSRequestClient *client = [self generateRequest:query];
	[client setHTTPMethod:@"PUT"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)updateQuery:(NSString *)query
{	
	YOSRequestClient *client = [self generateRequest:query];
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

#pragma mark - Private methods

- (YOSRequestClient *)generateRequest:(NSString *)query
{
	if(!self.environmentFile) [self setEnvironmentFile:kYQLOpenTables];
	
	// If a consumer is not available, we can assume public tables are being used
	// and we'll use the public yql endpoint. 
	NSString *requestUrl = ([self oauthConsumer]) ? [NSString stringWithFormat:@"%@/%@/%@", kYQLBaseUrl, self.apiVersion, @"yql"]
	: [NSString stringWithFormat:@"%@/%@/%@/%@", kYQLBaseUrl, self.apiVersion, @"public", @"yql"];
	
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"q"] = query;
	requestParameters[@"format"] = self.format;
	
	NSString *useDiagnostics = (self.diagnostics) ? @"true" : @"false";
	requestParameters[@"diagnostics"] = useDiagnostics;
	requestParameters[@"env"] = self.environmentFile;
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setRequestParameters:requestParameters];
	
	return client;
}

@end

