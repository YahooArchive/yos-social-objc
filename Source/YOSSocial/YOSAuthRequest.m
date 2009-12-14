//
//  YOSAuthRequest.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSAuthRequest.h"
#import "YOSRequestToken.h"
#import "YOSAccessToken.h"
#import "YOSResponseData.h"

static NSString *const kOAuthBaseUrl = @"https://api.login.yahoo.com";
static NSString *const kOAuthVersion = @"v2";
static NSString *const kOAuthOutOfBand = @"oob";

@implementation YOSAuthRequest

@synthesize oAuthLang;

#pragma mark init

+ (id)requestWithSession:(YOSSession *)session
{
	YOSAuthRequest *request = [[YOSAuthRequest alloc] initWithConsumer:session.consumer];
	[request autorelease];
	
	return request;
}

- (id)initWithConsumer:(YOAuthConsumer *)aConsumer
{
	if(self = [super initWithConsumer:aConsumer])
	{
		[self setBaseUrl:kOAuthBaseUrl];
		[self setApiVersion:kOAuthVersion];
	}
	return self;
}

#pragma mark -
#pragma mark Public

- (YOSRequestToken *)fetchRequestTokenWithCallbackUrl:(NSString *)callbackUrl
{
	NSString *method = [NSString stringWithFormat:@"get_request_token"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@",self.baseUrl,@"oauth",self.apiVersion,method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	
	callbackUrl = (callbackUrl != nil) ? callbackUrl : kOAuthOutOfBand;
	[requestParameters setValue:callbackUrl forKey:@"oauth_callback"];
	
	if(self.oAuthLang != nil) {
		[requestParameters setValue:self.oAuthLang forKey:@"xoauth_lang_pref"];
	}
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"POST"];
	[client setRequestParameters:requestParameters];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	
	if(!response.didSucceed) {
		return nil;
	}
	
	YOSRequestToken *requestToken = [YOSRequestToken tokenFromResponse:response.data];
	
	return (requestToken.key && requestToken.secret) ? requestToken : nil;
}

- (NSURL *)authUrlForRequestToken:(YOSRequestToken *)requestToken
{
	NSString *method = [NSString stringWithFormat:@"request_auth"];
	NSString *requestPath = [NSString stringWithFormat:@"%@/%@/%@/%@?oauth_token=%@",self.baseUrl,@"oauth",self.apiVersion,method,requestToken.key];
	
	return [NSURL URLWithString:requestPath];
}

- (YOSAccessToken *)fetchAccessToken:(YOAuthToken *)requestOrAccessToken withVerifier:(NSString *)verifier
{
	// set the token so its used when signing this request.
	[self setToken:(YOAuthToken*)requestOrAccessToken];
	
	NSString *method = [NSString stringWithFormat:@"get_token"];
	NSString *requestUrl = [NSString stringWithFormat:@"%@/%@/%@/%@", self.baseUrl, @"oauth", self.apiVersion, method];
	NSURL *url = [NSURL URLWithString:requestUrl];
	
	NSMutableDictionary *requestParameters = [NSMutableDictionary dictionary];
	
	if(verifier != nil) {
		[requestParameters setValue:verifier forKey:@"oauth_verifier"];
	}
	
	if([requestOrAccessToken isKindOfClass:[YOSAccessToken class]]) {
		YOSAccessToken *tokenAsAccessToken = (YOSAccessToken*)requestOrAccessToken;
		if(tokenAsAccessToken.sessionHandle) {
			[requestParameters setValue:tokenAsAccessToken.sessionHandle forKey:@"oauth_session_handle"];
		}
	}
	
	YOSRequestClient *client = [self requestClient];
	[client setRequestUrl:url];
	[client setHTTPMethod:@"POST"];
	[client setRequestParameters:requestParameters];
	[client setOauthParamsLocation:@"OAUTH_PARAMS_IN_QUERY_STRING"];
	
	YOSResponseData *response = [client sendSynchronousRequest];
	
	if(!response.didSucceed) {
		return nil;
	}
	
	YOSAccessToken *accessToken = [YOSAccessToken tokenFromResponse:response.data];
	
	return (accessToken.key && accessToken.secret) ? accessToken : nil;
}

@end