Yahoo SDK for iOS
=================

This open-source library allows you to integrate Yahoo login into your iOS app, access the user's profile and friends and query from all Yahoo! APIs through YQL.  

<img src="https://raw.githubusercontent.com/michaelchum/yos-social-objc/master/YahooSDK/YOAssets/button-sign-in-with-yahoo.png" />

Find documentation and support on [Yahoo! Developer Network](http://developer.yahoo.com/)
* Guide to accessing [Yahoo! Social APIs](https://developer.yahoo.com/social/rest_api_guide/index.html)
* Guide to accessing Yahoo! APIs through [Yahoo! Query Language (YQL)](http://developer.yahoo.com/yql/)
* Details of the [Yahoo! OAuth1.0a model](https://developer.yahoo.com/oauth/)
* Yahoo! OAuth1.0a [Authorization flow](https://developer.yahoo.com/oauth/guide/oauth-auth-flow.html)

NOTE: This library implements OAuth1.0a, Yahoo! APIs currently only supports this version of OAuth. OAuth2 is under development at Yahoo! 

## Install to your project
Insert the YahooSDK folder in your project and include the YahooSDK header file
```obj-c
#import "YahooSDK.h" 
```

## Create an application on YDN
To use Yahoo! Web Services, we need some information about you and the application you're building. 
Sign up for a new application ID to get your OAuth consumer key &amp; consumer secret.

 * YDN Developer Dashboard - [https://developer.yahoo.com/dashboard/](https://developer.yahoo.com/dashboard/)
 * New Application Form - [https://developer.yahoo.com/dashboard/createKey.html](https://developer.yahoo.com/dashboard/)

## Setting up a Yahoo Session 

The class anthenticating a YahooSession must implement the `<YahooSessionDelegate>` protocol in order to perform a callback after asynchronous authentication. The only required method to implement is `- (void)didReceiveAuthorization`. It is recommended to declare the `YahooSession` instance as a property for simplicity and reuse, a session is required as an argument for every request.

```obj-c
#import "YahooSDK.h"

@interface myAppDelegate() <YahooSessionDelegate>

@property (strong, nonatomic) YahooSession *session;

@end
```

## Initializing a Yahoo Session:

To create a new session using YahooSession, initialize it by setting your consumer 
key, consumer secret, application ID and callback URL as parameters. All parameters should exactly correspond to those of your application in the YDN Developer Dashboard in order to sign-in successfully.

```obj-c
- (void)createYahooSession
{
	// Create session with consumer key, secret, application ID and callback URL
	self.session = [YahooSession sessionWithConsumerKey:@"Key"
	                                  andConsumerSecret:@"Secret" 
	                                   andApplicationId:@"AppID"
	                                     andCallbackUrl:@"CallbackUrl"
	                                        andDelegate:self];
	// Try to resume a user session if one exists  
	BOOL hasSession = [self.session resumeSession];  
	
	// No session detected, send user to sign-in and authorization page
	if(!hasSession) {
		[self.session sendUserToAuthorization];
	// Session detected, user is already signed-in begin requests
	} else {
		NSLog(@"Session detected!");
		// Send authenticated requests to Yahoo APIs here...
	}
}

- (void)didReceiveAuthorization
{
    [self createYahooSession];
}

```

Because a session can be persistent, you have to check for an existing user session. 
If a user session does not exist yet, they must login in order for the 
application to gain access to their protected user information. (profile, 
connections, contacts, emails, phone numbers, etc.) Alternatively, if a session exists, the session 
will automatically fetch a new access token to renew the session.

## Fetching user profile:

Now that we have a ready session, we can now access social information for 
the logged-in user. The depth of user data you can access will depend on 
the permissions for which your application asked.

Each `GET` method of YOSUserRequest creates an asynchronous request with the 
delegate you provided. When the request is returned, the delegate method 
`requestDidFinishLoading` is invoked with a `YOSResponseData` object containing 
the `NSHTTPURLResponse` object, `NSData` response object, a responseText string 
and an NSError object (if an error occurred) for which your application should handle.

To work with the response data object, parse the `responseText` (NSString response encoded in JSON format) or `responseJSONDict` (NSDictionary response).
```obj-c
- (void)sendRequests
{
	// Initialize a user profile request
	YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
	
	// Fetch user profile
	[userRequest fetchProfileWithDelegate:self];
}

- (void)requestDidFinishLoading:(YOSResponseData *)data
{
	// Get the JSON response, will exist ONLY if requested response is JSON
	// If JSON does not exist, use data.responseText for NSString response
	NSDictionary *json = data.responseJSONDict;
    
	// Profile fetched
	NSDictionary *userProfile = json[@"profile"];
	if (userProfile) {
        	NSLog(@"User profile fetched");
        	NSLog(@"%@",userProfile);
	}
}
```

## Fetching user contacts
```obj-c
- (void)sendRequests
{
    // Initialize contact list request
    YOSUserRequest *request = [YOSUserRequest requestWithSession:self.session];
    
    // Fetch the user's contact list
    [request fetchContactsWithStart:0 andCount:300 withDelegate:self];
}

- (void)requestDidFinishLoading:(YOSResponseData *)data 
{
    // Get the JSON response, will exist ONLY if requested response is JSON
    // If JSON does not exist, use data.responseText for NSString response
    NSDictionary *json = data.responseJSONDict;

    NSDictionary *contactDict = json[@"contacts"];
    if (contactDict) {
        NSLog(@"Contact list fetched");
        NSLog(@"%@",contactDict);
    }
}
```

## Using YQL

Synchronous :
```obj-c	
// Initialize YQL request
YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];

// Build YQL query string
NSString *structuredYQLQuery = [NSString stringWithFormat:@"select * from social.profile where guid = me"];

// Fetch YQL response
[request query:structuredYQLQuery withDelegate:self];
```
Asynchronous:
```obj-c
- (void)sendRequests
{  
    // Initialize YQL request
    YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];
    
    // Build YQL query string
    NSString *structuredYQLQuery = [NSString stringWithFormat:@"select * from social.profile where guid = me"];
    
    // Fetch YQL response
    [request query:structuredYQLQuery withDelegate:self];
}  
  
- (void)requestDidFinishLoading:(YOSResponseData *)data
{
    // Get the JSON response, will exist ONLY if requested response is JSON
    // If JSON does not exist, use data.responseText for NSString response
    NSDictionary *json = data.responseJSONDict;

    // YQL query response fetched
    NSDictionary *yqlDict = json[@"query"];
    if (yqlDict) {
        NSDictionary *yqlResults = yqlDict[@"results"];
        NSLog(@"%@",yqlResults);
    }
}
```
## Terms of Use

Use of the YahooSDK is governed by the [Yahoo! APIs Terms of Use](http://developer.yahoo.com/terms/).
Your use of YQL is subject to the [YQL Terms of Service](http://info.yahoo.com/legal/us/yahoo/yql/yql-4307.html).

## License

Software License Agreement (BSD License)

Copyright 2014 Yahoo Inc.

All rights reserved.
 
 * YahooSDK
 * YOAuth
 
Redistribution and use of this software in source and binary forms, with
or without modification, are permitted provided that the following
conditions are met:
 
* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.
 
* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.
 
* Neither the name of Yahoo! Inc. nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of Yahoo! Inc.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
