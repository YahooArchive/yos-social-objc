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
	return request;
}

- (BOOL)fetchConnectionsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"connections"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	requestParameters[@"start"] = @(start);
	requestParameters[@"count"] = @(count);
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)fetchContactsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"contacts"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	requestParameters[@"start"] = @(start);
	requestParameters[@"count"] = @(count);
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)fetchContactWithID:(NSInteger)contactId withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"contact"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method, @(contactId)];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)addContact:(NSDictionary *)contact
{
	NSString *method = [NSString stringWithFormat:@"contacts"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	
	NSMutableDictionary *contactData = [NSMutableDictionary dictionary];
	contactData[@"contact"] = contact;
	
	NSString *jsonContact = [self serializeDictionary:contactData];
	NSData *contactHTTPBody = [jsonContact dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
	requestHeaders[@"Content-Type"] = @"application/json";
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"POST"];
	[client setHTTPBody:contactHTTPBody];
	[client setRequestHeaders:requestHeaders];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
		
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200);
}

- (BOOL)fetchContactSyncRevision:(NSInteger)revision withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"contacts"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"view"] = @"sync";
	requestParameters[@"rev"] = @(revision);
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)syncContactsRevision:(NSDictionary *)contactsync
{
	NSString *method = [NSString stringWithFormat:@"contacts"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	
	NSMutableDictionary *contactSyncData = [NSMutableDictionary dictionary];
	contactSyncData[@"contactsync"] = contactsync;
	
	NSString *jsonContactsync = [self serializeDictionary:contactSyncData];
	NSData *contactsyncHTTPBody = [jsonContactsync dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
	requestHeaders[@"Content-Type"] = @"application/json";
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:contactsyncHTTPBody];
	[client setRequestHeaders:requestHeaders];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200);
}

- (BOOL)fetchProfileWithDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"profile"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)fetchProfileLocationWithDelegate:(id)delegate
{	
	NSString *queryJoin = [NSString stringWithFormat:@"select location from social.profile where guid=\"%@\"", user.guid];
	return [self query:[NSString stringWithFormat:@"select * from geo.places where text in (%@)", queryJoin] withDelegate:delegate];
}

- (BOOL)fetchConnectionProfilesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{	
	NSString *queryJoin = [NSString stringWithFormat:@"select guid from social.connections(%d,%d) where owner_guid=\"%@\"", start, count, user.guid];
	return [self query:[NSString stringWithFormat:@"select * from social.profile where guid in (%@)", queryJoin] withDelegate:delegate];
}

- (BOOL)fetchPlacesFromContent:(NSString *)documentContent andDocumentType:(NSString *)documentType withDelegate:(id)delegate
{
	documentType = (documentType) ? documentType : @"text/plain";
	return [self query:[NSString stringWithFormat:@"select * from geo.placemaker where documentContent=\"%@\" and documentType=\"%@\"", documentContent, documentType]
		  withDelegate:delegate];
}

- (BOOL)fetchPlaceForLocation:(NSString *)location withDelegate:(id)delegate
{
	return [self query:[NSString stringWithFormat:@"select * from geo.places where text=\"%@\"", location] withDelegate:delegate];
}

- (BOOL)fetchConnectionsStatusWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *yqlJoin = [NSString stringWithFormat:@"select guid from social.connections(%d,%d) where owner_guid=\"%@\"", start, count, user.guid];
	return [self query:[NSString stringWithFormat:@"select guid,status from social.profile where guid in (%@) | sort(field=\"status.lastStatusModified\") | reverse()", yqlJoin] 
		  withDelegate:delegate];
}

- (BOOL)fetchStatusWithDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"profile/status"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",self.baseUrl,self.apiVersion,@"user",self.user.guid,method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)fetchUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"updates"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", self.baseUrl, self.apiVersion, @"user", self.user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSString *updatesDefaultSortingParam = [NSString stringWithFormat:@"pubDate"];
	NSString *updatesTransform = [NSString stringWithFormat:@"(sort \"%@\" numeric descending (all))", updatesDefaultSortingParam];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	requestParameters[@"start"] = @(start);
	requestParameters[@"count"] = @(count);
	requestParameters[@"transform"] = updatesTransform;
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
}

- (BOOL)fetchConnectionUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate
{
	NSString *method = [NSString stringWithFormat:@"updates/connections"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", baseUrl, apiVersion, @"user", user.guid, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSString *updatesDefaultSortingParam = [NSString stringWithFormat:@"pubDate"];
	NSString *updatesTransform = [NSString stringWithFormat:@"(sort \"%@\" numeric descending (all))", updatesDefaultSortingParam];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	requestParameters[@"format"] = self.format;
	requestParameters[@"region"] = self.user.region;
	requestParameters[@"lang"] = self.user.language;
	requestParameters[@"start"] = @(start);
	requestParameters[@"count"] = @(count);
	requestParameters[@"transform"] = updatesTransform;
	
	YOSRequestClient *client = [self requestClient];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"GET"];
	[client setRequestParameters:requestParameters];
	return [client sendAsyncRequestWithDelegate:delegate];
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
	
	NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[aDate timeIntervalSince1970]];
	NSString *updateSource = [NSString stringWithFormat:@"APP.%@", theSession.applicationId];
	
	NSMutableDictionary *updateData = [NSMutableDictionary dictionary];
	updateData[@"collectionID"] = user.guid;
	updateData[@"source"] = updateSource;
	updateData[@"suid"] = aSuid;
	updateData[@"title"] = aTitle;
	updateData[@"description"] = aDescription;
	updateData[@"link"] = aLink;
	updateData[@"pubDate"] = timestamp;
	updateData[@"collectionType"] = @"guid";
	updateData[@"class"] = @"app";
	updateData[@"type"] = @"appActivity";
	
	NSArray *updateDataWrapper = @[updateData];
	
	NSMutableDictionary *updatesDataPayload = [NSMutableDictionary dictionary];
	updatesDataPayload[@"updates"] = updateDataWrapper;
	
	NSString *jsonUpdatesPayload = [self serializeDictionary:updatesDataPayload];
	NSData *updatesHTTPBody = [jsonUpdatesPayload dataUsingEncoding:NSUTF8StringEncoding];
	
	NSString *method = [NSString stringWithFormat:@"updates"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@", baseUrl, apiVersion, @"user", user.guid, method, updateSource, aSuid];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestHeaders = [NSMutableDictionary dictionary];
	requestHeaders[@"Content-Type"] = @"application/json";
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:updatesHTTPBody];
	[client setRequestHeaders:requestHeaders];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
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
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"DELETE"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
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
	requestHeaders[@"Content-Type"] = @"application/json";
	
	NSMutableDictionary *messageDictionary = [NSMutableDictionary dictionary];
	messageDictionary[@"message"] = theMessage;
	
	NSMutableDictionary *statusDictionary = [NSMutableDictionary dictionary];
	statusDictionary[@"status"] = messageDictionary;
	
	NSData *statusHTTPBody = [[self serializeDictionary:statusDictionary] dataUsingEncoding:NSUTF8StringEncoding];
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:statusHTTPBody];
	[client setRequestHeaders:requestHeaders];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
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
	requestHeaders[@"Content-Type"] = @"text/html;charset=utf-8";
	
	NSData *smallViewContentHTTPBody = [content dataUsingEncoding:NSUTF8StringEncoding];
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"PUT"];
	[client setHTTPBody:smallViewContentHTTPBody];
	[client setRequestHeaders:requestHeaders];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	NSInteger httpStatusCode = [response.HTTPURLResponse statusCode];
	
	if(!response.data) {
		return FALSE;
	}
	
	return (httpStatusCode == 200);
}

- (BOOL)query:(NSString *)aQuery withDelegate:(id)delegate
{
	YQLQueryRequest *yqlRequest = [[YQLQueryRequest alloc] initWithYOSUser:[self user]];
	
	BOOL connectionWasCreated = [yqlRequest query:aQuery withDelegate:delegate];
	
	return connectionWasCreated;
}

- (NSString *)generateUniqueSuid
{
	NSString *generatedSuid = nil;
	CFUUIDRef generatedUUID = CFUUIDCreate(kCFAllocatorDefault);
	generatedSuid = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, generatedUUID));
	CFRelease(generatedUUID);
	
	return generatedSuid;
}

@end
