//
//  YOSRequestClient.m
//  YOSSocial
//
//  Created by Zach Graves on 2/19/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//  

#import "YOSRequestClient.h"
#import "NSDictionary+QueryString.h"

#define OAUTH_PARAMS_IN_HTTP_BODY		@"OAUTH_PARAMS_IN_HTTP_BODY"
#define OAUTH_PARAMS_IN_AUTH_HEADER		@"OAUTH_PARAMS_IN_AUTH_HEADER"
#define OAUTH_PARAMS_IN_QUERY_STRING	@"OAUTH_PARAMS_IN_QUERY_STRING"

static NSString *const kYOSUserAgentPrefix = @"YosCocoaSdk/0.5";

@implementation YOSRequestClient

@synthesize consumer;
@synthesize token;
@synthesize HTTPMethod;
@synthesize requestUrl;
@synthesize requestParameters;
@synthesize requestHeaders;
@synthesize HTTPBody;
@synthesize oauthParamsLocation;
@synthesize timeoutInterval;
@synthesize userAgentHeaderValue;

@synthesize requestDelegate;
@synthesize response;
@synthesize responseData;
@synthesize URLConnection;

#pragma mark init

- (id)initWithConsumer:(YOAuthConsumer *)aConsumer andToken:(YOAuthToken *)aToken
{
	if(self = [self init]) {
		[self setConsumer:aConsumer];
		[self setToken:aToken];
		[self setOauthParamsLocation:OAUTH_PARAMS_IN_AUTH_HEADER];
		[self setTimeoutInterval:20.0]; // TODO: need to switch for EDGE/3G v. wi-fi
		[self setUserAgentHeaderValue:[self buildUserAgentHeaderValue]];
	}
	return self;
}

#pragma mark -
#pragma mark Public

- (YOSResponseData *)sendSynchronousRequest
{
	NSMutableURLRequest *urlRequest = [self buildUrlRequest];
	
	NSError *rspError = nil;
	NSURLResponse *urlResponse = nil;
	
	NSData *connectionResponseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&rspError];
	
	[rspError autorelease];	
	[connectionResponseData autorelease];
	
	YOSResponseData *serviceResponseData = [YOSResponseData responseWithData:connectionResponseData 
															  andURLResponse:urlResponse];
	return serviceResponseData;
}

- (BOOL)sendAsyncRequestWithDelegate:(id)delegate
{
	self.responseData = [[NSMutableData data] retain];
	[self setRequestDelegate:delegate];
	
	NSMutableURLRequest *urlRequest = [self buildUrlRequest];
	// self.URLConnection = [[NSURLConnection connectionWithRequest:urlRequest delegate:self] retain];
	
	[self setURLConnection:[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES]];
	
	BOOL connectionCreated = (self.URLConnection != nil);
	
	return connectionCreated;
}

#pragma mark -
#pragma mark Private

- (NSMutableURLRequest *)buildUrlRequest
{
	YOAuthRequest *oauthRequest = [self buildOAuthRequest];
	
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
	[urlRequest setHTTPMethod:self.HTTPMethod];
	[urlRequest setTimeoutInterval:self.timeoutInterval];
	[urlRequest setValue:self.userAgentHeaderValue forHTTPHeaderField:@"User-Agent"];
	
	if([self.HTTPMethod isEqualToString:@"POST"])
	{
		//		NSString *requestAbsoluteURLString = [self.requestUrl absoluteString];
		//		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", requestAbsoluteURLString]];
		//		[urlRequest setURL:url];
		//		
		//		NSString *postDataQueryString = (oauthRequest) 
		//		? [[oauthRequest allRequestParametersAsDictionary] QueryString] 
		//		: [requestParameters QueryString];
		//		
		//		NSData *postData = [postDataQueryString dataUsingEncoding: NSASCIIStringEncoding];
		//		[urlRequest setHTTPBody:postData];
		
		NSDictionary *queryParameters = (oauthRequest && [oauthParamsLocation isEqualToString:OAUTH_PARAMS_IN_QUERY_STRING]) 
		? [oauthRequest allRequestParametersAsDictionary] 
		: requestParameters; 
		
		NSString *requestAbsoluteURLString = [NSString stringWithFormat:@"%@?%@", [self.requestUrl absoluteString], [queryParameters QueryString]];
		NSURL *url = [NSURL URLWithString:requestAbsoluteURLString];
		
		[urlRequest setURL:url];
		[urlRequest setHTTPBody:self.HTTPBody];
	}
	else {
		NSDictionary *queryParameters = (oauthRequest && [oauthParamsLocation isEqualToString:OAUTH_PARAMS_IN_QUERY_STRING]) 
		? [oauthRequest allRequestParametersAsDictionary] 
		: requestParameters; 
		
		NSString *requestAbsoluteURLString = [NSString stringWithFormat:@"%@?%@", [self.requestUrl absoluteString], [queryParameters QueryString]];
		NSURL *url = [NSURL URLWithString:requestAbsoluteURLString];
		
		[urlRequest setURL:url];
		
		if ([self.HTTPMethod isEqualToString:@"PUT"]) {
			[urlRequest setHTTPBody:self.HTTPBody];
		}
	}
	
	if(oauthRequest) {
		if([oauthParamsLocation isEqualToString:OAUTH_PARAMS_IN_AUTH_HEADER]) {
			[requestHeaders setObject:[oauthRequest buildAuthorizationHeaderValue] forKey:@"Authorization"];
		}
		else if([oauthParamsLocation isEqualToString:OAUTH_PARAMS_IN_HTTP_BODY]) {
			NSString *requestQueryString = [[oauthRequest allOAuthRequestParametersAsDictionary] QueryString];
			[urlRequest setHTTPBody:[requestQueryString dataUsingEncoding: NSASCIIStringEncoding]];
		}
	}
	
	if(self.requestHeaders && [self.requestHeaders count]) {
		for (NSString *headerKey in [self.requestHeaders allKeys]) {
			NSString *headerValue = [self.requestHeaders objectForKey:headerKey];
			[urlRequest setValue:headerValue forHTTPHeaderField:headerKey];
		}
	}
	
	return [urlRequest autorelease];
}

- (YOAuthRequest *)buildOAuthRequest
{
	YOAuthRequest *oauthRequest = nil;
	
	if(self.consumer) {
		oauthRequest = [[YOAuthRequest alloc] initWithConsumer:self.consumer 
														andUrl:self.requestUrl 
												 andHTTPMethod:self.HTTPMethod 
											andSignatureMethod:@"HMAC-SHA1"];
		
		if(self.token) 
			[oauthRequest setToken:self.token];
		
		if(self.requestParameters && [self.requestParameters count])
			[oauthRequest setRequestParams:requestParameters];
		
		[oauthRequest prepareRequest];
	}
	
	return [oauthRequest autorelease];
}

- (NSString *)buildUserAgentHeaderValue
{
	
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	// iPhone apps
	// Examples:
	// YosCocoaSdk/0.1 (iPhone/2.2.1; iPhone OS; en_US;)
	// YosCocoaSdk/0.1 (iPhone Simulator/2.2.1; iPhone OS; en_US;) 
	// YosCocoaSdk/0.1 (iPod Touch/2.2.1; iPhone OS; en_US;) 
	UIDevice *currentDevice = [UIDevice currentDevice];
	NSString *currentLocaleIdentifier = [[NSLocale currentLocale] localeIdentifier];
	NSString *currentDeviceInfo = [NSString stringWithFormat:@"%@/%@; %@; %@;",[currentDevice model],[currentDevice systemVersion],[currentDevice systemName],currentLocaleIdentifier];
	NSString *clientUrlRequestUserAgent = [NSString stringWithFormat:@"%@ (%@)",kYOSUserAgentPrefix,currentDeviceInfo];
	
	return clientUrlRequestUserAgent;
#endif
#if (TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR))
	// Mac apps
	// Examples:
	// YosCocoaSdk/0.1 (Mac OS X/10.5.6; en_US;) 
	NSDictionary *systemVersionDictionary = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
	NSString *systemProductName = [systemVersionDictionary objectForKey:@"ProductName"];
	NSString *systemProductVersion = [systemVersionDictionary objectForKey:@"ProductVersion"];
	NSString *currentLocaleIdentifier = [[NSLocale currentLocale] localeIdentifier];
	NSString *currentDeviceInfo = [NSString stringWithFormat:@"%@/%@; %@;", systemProductName, systemProductVersion, currentLocaleIdentifier];
	NSString *clientUrlRequestUserAgent = [NSString stringWithFormat:@"%@ (%@)",kYOSUserAgentPrefix,currentDeviceInfo];	
	
	return clientUrlRequestUserAgent;
#endif
	
	// return default user-agent in case target OS is not available.
	return kYOSUserAgentPrefix;
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)cancel
{
	[self.URLConnection cancel];
	
	if ([self.requestDelegate respondsToSelector:@selector(connectionWasCancelled:)]) {
		[self.requestDelegate connectionWasCancelled];
	}
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
	if(self.response) [self.response release];
	
	self.response = [aResponse retain];
	[self.responseData setLength:0];
	
	if ([self.requestDelegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
		[self.requestDelegate request:self didReceiveResponse:self.response];
	}
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	[self.responseData appendData:data];
	
	if ([self.requestDelegate respondsToSelector:@selector(request:didReceiveData:)]) {
		[self.requestDelegate request:self didReceiveData:self.responseData];
	}
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
	YOSResponseData *serviceResponseData = [[YOSResponseData alloc] init];
	[serviceResponseData autorelease];
	[serviceResponseData setError:error];
	[serviceResponseData setDidSucceed:NO];
	
	if ([self.requestDelegate respondsToSelector:@selector(requestDidFailWithError:)]) {
		[self.requestDelegate requestDidFailWithError:serviceResponseData];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	YOSResponseData *serviceResponseData = [YOSResponseData responseWithData:self.responseData 
															  andURLResponse:self.response];
	
	if ([self.requestDelegate respondsToSelector:@selector(requestDidFinishLoading:)]) {
		[self.requestDelegate requestDidFinishLoading:serviceResponseData];
	}
}

@end