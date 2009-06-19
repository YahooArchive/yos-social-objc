//
//  YOSUserRequest.m
//  YosCocoaSdk
//
//  Created by Zach Graves on 2/17/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSUserRequest.h"
#import "YQLQueryRequest.h"
#import "YOSUser.h"

static NSString *const kYAPBaseUrl = @"http://appstore.apps.yahooapis.com";

@implementation YOSUserRequest

+ (id)requestWithSession:(YOSSession *)session
{
	YOSUser *sessionedUser = [[YOSUser alloc] initWithSession:session];
	YOSUserRequest *request = [[YOSUserRequest alloc] initWithYOSUser:sessionedUser];
	
	[sessionedUser autorelease];
	[request autorelease];
	
	return request;
}

- (void)fetchConnectionsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"connections"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:self.format forKey:@"format"];
	[requestParameters setObject:self.user.region forKey:@"region"];
	[requestParameters setObject:self.user.language forKey:@"lang"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
	[requestParameters release];
}

- (void)fetchContactsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"contacts"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:self.format forKey:@"format"];
	[requestParameters setObject:self.user.region forKey:@"region"];
	[requestParameters setObject:self.user.language forKey:@"lang"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
	[requestParameters release];
}

- (void)fetchProfileWithDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"profile"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:self.format forKey:@"format"];
	[requestParameters setObject:self.user.region forKey:@"region"];
	[requestParameters setObject:self.user.language forKey:@"lang"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
	[requestParameters release];
}

- (void)fetchConnectionProfilesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	YQLQueryRequest *yqlRequest = [[YQLQueryRequest alloc] initWithYOSUser:[self user]];
	
	NSString *queryJoin = [NSString stringWithFormat:@"select guid from social.connections(%d,%d) where owner_guid=\"%@\"", start, count, user.guid];
	NSString *yqlQuery = [NSString stringWithFormat:@"select * from social.profile where guid in (%@)", queryJoin];
	
	[yqlRequest query:yqlQuery withDelegate:delegate];
	[yqlRequest release];
}

- (void)fetchStatusWithDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"profile/status"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",self.baseUrl,self.apiVersion,@"user",self.user.guid,method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:self.format forKey:@"format"];
	[requestParameters setObject:self.user.region forKey:@"region"];
	[requestParameters setObject:self.user.language forKey:@"lang"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
	[requestParameters release];
}

- (void)fetchConnectionsStatusWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	YQLQueryRequest *yqlRequest = [[YQLQueryRequest alloc] initWithYOSUser:[self user]];
	
	NSString *yqlJoin = [NSString stringWithFormat:@"select guid from social.connections(%d,%d) where owner_guid=\"%@\"", start, count, user.guid];
	NSString *yqlQuery = [NSString stringWithFormat:@"select guid,status from social.profile where guid in (%@) | sort(field=\"status.lastStatusModified\") | reverse()", yqlJoin];
	
	[yqlRequest query:yqlQuery withDelegate:delegate];
	[yqlRequest release];
}

- (void)fetchUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"updates"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSString *updatesDefaultSortingParam = [NSString stringWithFormat:@"pubDate"];
	NSString *updatesTransform = [NSString stringWithFormat:@"(sort \"%@\" numeric descending (all))", updatesDefaultSortingParam];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:self.format forKey:@"format"];
	[requestParameters setObject:self.user.region forKey:@"region"];
	[requestParameters setObject:self.user.language forKey:@"lang"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
	[requestParameters setObject:updatesTransform forKey:@"transform"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
	[requestParameters release];
}

- (void)fetchConnectionUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"updates/connections"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", baseUrl, apiVersion, @"user", user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSString *updatesDefaultSortingParam = [NSString stringWithFormat:@"pubDate"];
	NSString *updatesTransform = [NSString stringWithFormat:@"(sort \"%@\" numeric descending (all))", updatesDefaultSortingParam];
	
	NSMutableDictionary *requestParameters = [[NSMutableDictionary alloc] init];
	[requestParameters setObject:self.format forKey:@"format"];
	[requestParameters setObject:self.user.region forKey:@"region"];
	[requestParameters setObject:self.user.language forKey:@"lang"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
	[requestParameters setObject:[NSString stringWithFormat:@"%d", count] forKey:@"count"];
	[requestParameters setObject:updatesTransform forKey:@"transform"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	[client sendAsyncRequestWithDelegate:delegate];
	
	[client release];
	[requestParameters release];
}

- (BOOL)insertUpdateWithTitle:(NSString *)aTitle
			   andDescription:(NSString *)aDescription
					  andLink:(NSString *)aLink 
					  andDate:(NSDate *)aDate
					  andSuid:(NSString *)aSuid
{
	if(![user isSessionedUser]) {
		return FALSE;
	}
	
	YOSSession *theSession = user.session;
	if(theSession.applicationId == nil || [theSession.applicationId isEqualToString:@""]) {
		return FALSE;
	}
	
	if(aSuid == nil) aSuid = [self generateUniqueSuid];
	
	if(aDate == nil) aDate = [NSDate date];
	
	NSString *timestamp = [NSString stringWithFormat:@"%d", (long)[aDate timeIntervalSince1970]];
	NSString *updateSource = [NSString stringWithFormat:@"APP.%@", theSession.applicationId];
	
	NSMutableDictionary *updateData = [[NSMutableDictionary alloc] initWithCapacity:10];
	[updateData setObject:user.guid forKey:@"collectionID"];
	[updateData setObject:updateSource forKey:@"source"];
	[updateData setObject:aSuid forKey:@"suid"];
	[updateData setObject:aTitle forKey:@"title"];
	[updateData setObject:aDescription forKey:@"description"];
	[updateData setObject:aLink forKey:@"link"];
	[updateData setObject:timestamp forKey:@"pubDate"];
	[updateData setObject:@"guid" forKey:@"collectionType"];
	[updateData setObject:@"app" forKey:@"class"];
	[updateData setObject:@"appActivity" forKey:@"type"];
	
	NSArray *updateDataWrapper = [NSArray arrayWithObject:updateData];
	
	NSMutableDictionary *updatesDataPayload = [NSMutableDictionary dictionary];
	[updatesDataPayload setObject:updateDataWrapper forKey:@"updates"];
	
	NSString *jsonUpdatesPayload = [self serializeDictionary:updatesDataPayload];
	NSData *updatesHTTPBody = [jsonUpdatesPayload dataUsingEncoding:NSUTF8StringEncoding];
	
	[updateData release];
	
	NSString *method = [NSString stringWithFormat:@"updates"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@", baseUrl, apiVersion, @"user", user.guid, method, updateSource, aSuid];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
	[requestHeaders setObject:@"application/json" forKey:@"Content-Type"];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:updatesHTTPBody];
	[client setRequestHeaders:requestHeaders];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
	// NSLog(@"%d", httpStatusCode);
	
	[client release];
	
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200);
}

- (BOOL)deleteUpdate:(NSString *)aSuid
{
	if(![user isSessionedUser]) {
		return FALSE;
	}
	
	YOSSession *theSession = user.session;
	NSString *applicationId = [theSession applicationId];
	
	if(applicationId == nil || [applicationId isEqualToString:@""]) {
		return FALSE;
	}
	
	NSString *updateSource = [NSString stringWithFormat:@"APP.%@", applicationId];
	
	NSString *method = [NSString stringWithFormat:@"updates"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@", baseUrl, apiVersion, @"user", user.guid, method, updateSource, aSuid];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setRequestUrl:url];
	[client setHTTPMethod:@"DELETE"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
	// NSLog(@"%d", httpStatusCode);
	
	[client release];
	
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200);
}

- (BOOL)setStatus:(NSString *)theMessage
{
	if(![user isSessionedUser] || theMessage == nil) {
		return FALSE;
	}
	
	NSString *method = [NSString stringWithFormat:@"profile/status"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",baseUrl,apiVersion,@"user",user.guid,method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
	[requestHeaders setObject:@"application/json" forKey:@"Content-Type"];
	
	NSMutableDictionary *messageDicationary = [NSMutableDictionary dictionary];
	[messageDicationary setObject:theMessage forKey:@"message"];
	
	NSMutableDictionary *statusDictionary = [NSMutableDictionary dictionary];
	[statusDictionary setObject:messageDicationary forKey:@"status"];
	
	NSData *statusHTTPBody = [[self serializeDictionary:statusDictionary] dataUsingEncoding:NSUTF8StringEncoding];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:statusHTTPBody];
	[client setRequestHeaders:requestHeaders];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
	// NSLog(@"%d", httpStatusCode);
	
	[client release];
	
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200 || httpStatusCode == 204);
}

- (BOOL)setSmallViewWithContents:(NSString *)content
{	
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",kYAPBaseUrl,apiVersion,@"cache/view/small",self.user.guid];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
	[requestHeaders setObject:@"text/html;charset=utf-8" forKey:@"Content-Type"];
	
	NSData *smallViewContentHTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
	
	YOSRequestClient *client = [[YOSRequestClient alloc] initWithConsumer:[self consumerForRequest] 
																 andToken:[self tokenForRequest]];
	
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:smallViewContentHTTPBody];
	[client setRequestHeaders:requestHeaders];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
	[client release];
	
	// NSLog(@"%d", httpStatusCode);
	
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200);
}

- (NSString *)generateUniqueSuid
{
	NSString *generatedSuid = nil;
	CFUUIDRef generatedUUID = CFUUIDCreate(kCFAllocatorDefault);
	generatedSuid = (NSString*)CFUUIDCreateString(kCFAllocatorDefault, generatedUUID);
	CFRelease(generatedUUID);
	
	return [generatedSuid autorelease];
}

@end
