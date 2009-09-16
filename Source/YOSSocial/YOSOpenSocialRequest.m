//
//  YOSOpenSocialRequest.m
//  YahooSocialSdk
//
//  Created by Zach Graves on 9/2/09.
//  Copyright 2009 Yahoo! Inc. All rights reserved.
//

#import "YOSOpenSocialRequest.h"
#import "YOSRequestClient.h"

static NSString *const kOpenSocialBaseUrl = @"http://appstore.apps.yahooapis.com/social/rest";

@implementation YOSOpenSocialRequest

+ (id)requestWithSession:(YOSSession *)session
{
	YOSUser *sessionedUser = [[YOSUser alloc] initWithSession:session];
	YOSOpenSocialRequest *request = [[YOSOpenSocialRequest alloc] initWithYOSUser:sessionedUser];
	
	[sessionedUser autorelease];
	[request autorelease];
	
	[request setBaseUrl:kOpenSocialBaseUrl];
	
	return request;
}

- (BOOL)getDataForUrl:(NSString *)relativeUrl andParameters:(NSMutableDictionary *)params delegate:(id)aDelegate
{	
	NSString *dataUrl = [self.baseUrl stringByAppendingString:relativeUrl];
	NSURL *url = [NSURL URLWithString:dataUrl];
	
	YOSRequestClient *client = [self requestClient];
	
	[client setRequestUrl:url];
	[client setRequestParameters:params];
	[client setHTTPMethod:@"GET"];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	return [client sendAsyncRequestWithDelegate:aDelegate];
}

- (BOOL) fetchConnectionsForUser:(NSString *)guid delegate:(id)delegate
{
	if(!guid) guid = @"@me";
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	[requestParameters setValue:@"100" forKey:@"count"];
	
	return [self getDataForUrl:[NSString stringWithFormat:@"/people/%@/@friends", guid] 
				 andParameters:requestParameters 
					  delegate:delegate];
}

- (BOOL) fetchProfileForUser:(NSString *)guid delegate:(id)delegate
{
	if(!guid) guid = @"@me";
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	[requestParameters setObject:@"displayName" forKey:@"fields"];
	
	return [self getDataForUrl:[NSString stringWithFormat:@"/people/%@/@self", guid] 
				 andParameters:requestParameters 
					  delegate:delegate];
}

- (BOOL) fetchActivitiesForUser:(NSString *)guid delegate:(id)delegate
{
	if(!guid) guid = @"@me";
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	[requestParameters setObject:@"100" forKey:@"count"];
	
	return [self getDataForUrl:[NSString stringWithFormat:@"/activities/%@/@self", guid] 
				 andParameters:requestParameters 
					  delegate:delegate];
}

- (BOOL) fetchApplicationActivitiesForUser:(NSString *)guid delegate:(id)delegate
{
	YOSSession *session = user.session;
	
	return [self getDataForUrl:[NSString stringWithFormat:@"/activities/%@/@self/%@", guid, session.applicationId]
				 andParameters:nil 
					  delegate:delegate];
}

- (BOOL) fetchApplicationActivityForUser:(NSString *)guid andActivityId:(NSString *)activityID delegate:(id)delegate
{
	if(!guid) guid = @"@me";
	
	YOSSession *session = user.session;
	
	return [self getDataForUrl:[NSString stringWithFormat:@"/activities/%@/@self/%@/%@", guid, session.applicationId, activityID] 
				 andParameters:nil 
					  delegate:delegate];
}

@end
