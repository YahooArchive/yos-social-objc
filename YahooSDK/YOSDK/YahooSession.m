//
//  YahooSession.h
//  YahooSDK
//
//  Created by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YahooSession.h"
#import "YOSAuthRequest.h"
#import <UIKit/UIKit.h>

@implementation YahooSession

#pragma mark - Lifecycle

+ (instancetype)sessionWithConsumerKey:(NSString *)consumerKey
					 andConsumerSecret:(NSString *)consumerSecret
					  andApplicationId:(NSString *)applicationId
                        andCallbackUrl:(NSString *)callbackUrl
                           andDelegate:(id)delegate
{
	YOAuthConsumer *sessionConsumer = [YOAuthConsumer consumerWithKey:consumerKey
                                                            andSecret:consumerSecret];
	return [[self alloc] initWithConsumer:sessionConsumer
                         andApplicationId:applicationId
                           andCallbackUrl:callbackUrl
                              andDelegate:delegate];
}

- (instancetype)initWithConsumer:(YOAuthConsumer *)consumer
                andApplicationId:(NSString *)applicationId
                  andCallbackUrl:(NSString *)callbackUrl
                     andDelegate:(id)delegate
{
	if (self = [super init]) {
        self.consumer = consumer;
        self.applicationId = applicationId;
        self.callbackUrl = callbackUrl;
        self.delegate = delegate;
		
		YOSTokenStore *sessionTokenStore = [[YOSTokenStore alloc] initWithConsumer:consumer];
        self.tokenStore = sessionTokenStore;
    }
    
	return self;
}

#pragma mark - Public methods

- (void)clearSession
{
    self.accessToken = nil;
    self.requestToken = nil;
	
	if (self.tokenStore) {
		[self.tokenStore removeAccessToken];
		[self.tokenStore removeRequestToken];
	}
    
    // Clear all Yahoo cookies in the webview
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSHTTPCookie *cookie;
    for (cookie in [cookieJar cookies]) {
        if ([cookie.domain rangeOfString:@"yahoo.com"].location != NSNotFound) {
            [cookieJar deleteCookie:cookie];
        }
    }
}

- (void)saveSession
{
	if (self.tokenStore) {
		if(self.accessToken) {
            self.tokenStore.accessToken = self.accessToken;
		} else {
			[self.tokenStore removeAccessToken];
		}
		
		if(self.requestToken) {
            self.tokenStore.requestToken = self.requestToken;
		} else {
			[self.tokenStore removeRequestToken];
		}
	}
}

- (BOOL)resumeSession
{
	YOSAuthRequest *tokenAuthRequest = [YOSAuthRequest requestWithSession:self];
	
    // Fetch token from tokenStore
	if ([self.tokenStore hasRequestToken] && self.requestToken == nil) {
        self.requestToken = self.tokenStore.requestToken;
	} else if ([self.tokenStore hasAccessToken] && self.accessToken == nil) {
        self.accessToken = self.tokenStore.accessToken;
	}
	
	if (self.requestToken) {
		if(!self.requestToken.key || !self.requestToken.secret) {
			return FALSE;
		}
		
		// Check if the request token has expired.
		// If expired, return FALSE as there is no session to resume.
		if ([self.requestToken tokenHasExpired]) {
			NSLog(@"Request token (%@) has expired.", self.requestToken.key);
			return FALSE;
		}
		
		if (self.requestToken.verifier == nil) {
			return FALSE;
		}
		
		// Exchange the request token for an access token.
		YOSAccessToken *newAccessToken = [tokenAuthRequest fetchAccessToken:self.requestToken
                                                               withVerifier:self.requestToken.verifier];
		
		// Check for the presence of a key and secret,
		// If missing the session is invalid, most likely
		// because the user did not authorize the app.
		// if invalid just wait to return FALSE at the end.
		if(newAccessToken.key && newAccessToken.secret) {
            // Delete the verifier and requestToken
            self.requestToken.verifier = nil;
            self.requestToken = nil;
			// Set and save the sessions access token
            self.accessToken = newAccessToken;
			[self saveSession];		
			
			// Session is ready
            NSLog(@"Yahoo session resuming.");
			return TRUE;
		}
	} else if (self.accessToken) {
		if (!self.accessToken.key || !self.accessToken.secret) {
			return FALSE;
		}
		// Check if the access token has expired. If expired we can try to renew it.
		if ([self.accessToken tokenHasExpired]) {
			NSLog(@"Access token (%@) has expired.", self.accessToken.key);
			
			YOSAccessToken *refreshedAccessToken = [tokenAuthRequest fetchAccessToken:self.accessToken
                                                                         withVerifier:nil];
			
			// Check for the presence of a key and secret.
			// If missing the session is invalid, likely because the user or service provider has revoked the access token.
			if (refreshedAccessToken.key && refreshedAccessToken.secret) {
				// If we have a new, valid token
				// Set and save the sessions new access token
                self.accessToken = refreshedAccessToken;
                self.requestToken = nil;
				[self saveSession];
			} else{
				[self.tokenStore removeRequestToken];
                [self.tokenStore removeAccessToken];
				return FALSE;
			}
		}
		
		// Session is ready.
        NSLog(@"Yahoo session is ready.");
		return TRUE;
	}
	
	// No tokens found, start by directing the user to the login page with sendUserToAuthorization
	return FALSE;
}

- (void)sendUserToAuthorization
{
    // Create a new YOSAuthRequest used to fetch OAuth tokens.
	YOSAuthRequest *tokenAuthRequest = [YOSAuthRequest requestWithSession:self];
    
	// Fetch a new request token from oauth.
	YOSRequestToken *newRequestToken = [tokenAuthRequest fetchRequestTokenWithCallbackUrl:self.callbackUrl];
	
	// If it looks like we have a valid request token
	if (newRequestToken && newRequestToken.key && newRequestToken.secret) {
		// Store the request token for later use
        self.requestToken = newRequestToken;
		[self saveSession];
		
		// Create an authorization URL for the request token
		self.authorizationUrl = [tokenAuthRequest authUrlForRequestToken:self.requestToken];

        if (self.mobileWebAuthorization) {
            NSString *mobileWebLogin = @"https://login.yahoo.com/m?&.src=oauth&.lang=en-us&.intl=us&.done=";
            self.authorizationUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mobileWebLogin,self.authorizationUrl]];
        }
		
        // Use UIWebView
        self.rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        self.authorizationWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height)];
        [self.authorizationWebView setDelegate:self];
        NSURLRequest *request = [NSURLRequest requestWithURL:self.authorizationUrl];
        [self.authorizationWebView loadRequest:request];
        [self.rootViewController.view addSubview:self.authorizationWebView];
		
	} else {
        NSLog(@"Error, no request token returned. Check your consumer key and secret.");
	}
}

#pragma mark - UIWebViewDelegate

// Waiting for user's authorization from webView
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    // Check if authorization accepted. Save token verifier and close webView.
    if ([request.URL.absoluteString rangeOfString:@"&oauth_verifier="].location != NSNotFound) {

        NSLog(@"Yahoo authorization succeeded, closing webview.");
        
        // Return to the app
        [webView removeFromSuperview];
        self.authorizationWebView = nil;
        self.rootViewController = nil;
        
        // Parse the tokens
        NSString *query = [request.URL.absoluteString componentsSeparatedByString:@"?"][1];
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *response = [NSMutableDictionary dictionary];
        for (NSString *item in pairs) {
            NSArray *fields = [item componentsSeparatedByString:@"="];
            NSString *name = fields[0];
            NSString *value = [fields[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            response[name] = value;
        }
        
        // Store the verifier
        self.requestToken.verifier = [response valueForKey:@"oauth_verifier"];
        [self saveSession];
        
        // Handle the tokens to the delegate
        if([self.delegate respondsToSelector:@selector(didReceiveAuthorization)]) {
            [self.delegate didReceiveAuthorization];
        }
        
        return NO;
    
    // Check if desktop authorization web page detected. Refresh webView with mobile page.
    } else if ([request.URL.absoluteString hasPrefix:@"https://login.yahoo.com/config/login?.src=oauth2&.partner=&.pd="]) {
        
        // If mobile mask has already been already activated, reset variable and ignore
        if (self.mobileWebAuthorization) {
            self.mobileWebAuthorization = NO;
            return YES;
        }
        
        // If desktop web page, close and resend authorization with mobile mask activated
        [webView removeFromSuperview];
        self.authorizationWebView = nil;
        self.rootViewController = nil;
        self.mobileWebAuthorization = YES;
        [self sendUserToAuthorization];
        
        return NO;
    }
    
    return YES;
}

@end
