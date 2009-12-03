Yahoo! Social SDK, Objective-C library
=================

Find documentation and support on Yahoo! Developer Network: [http://developer.yahoo.com](http://developer.yahoo.com/yap/)

 * Yahoo! Application Platform - [http://developer.yahoo.com/yap/](http://developer.yahoo.com/yap/)
 * Yahoo! Social APIs - [http://developer.yahoo.com/social/](http://developer.yahoo.com/social/)
 * Yahoo! Query Language - [http://developer.yahoo.com/yql/](http://github.com/yahoo/yos-social-objc/tree/master)

Hosted on GitHub: [http://github.com/yahoo/yos-social-objc/tree/master](http://github.com/yahoo/yos-social-objc/tree/master)

License
=======

Software License Agreement (BSD License)

Copyright (c) 2009, Yahoo! Inc.

All rights reserved.
 
 * YOAuth
 * YOSSocial
 
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

This software additionally references or incorporates the following sources
of intellectual property, the license terms for which are set forth
in the sources themselves:

Requirements
============

The following dependencies are bundled with the Yahoo! Social SDK, but are under
terms of a separate license:

 * json-framework - [http://code.google.com/p/json-framework/](http://code.google.com/p/json-framework/)
 * OAuthConsumer Crypto - [http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/Crypto/](http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/Crypto/)


Install
=======

Include the YOAuth, YOSSocial and json-framework groups into your Xcode project path. 
Then, include the YOSSocial.h header into your code.

    #import "YOSSocial.h" 


Creating A New Application
========

To use Yahoo! Web Services, we need some information about you and the application you're building. 
Sign up for a new application ID to get your OAuth consumer key &amp; secret.

 * YDN Developer Dashboard - [https://developer.yahoo.com/dashboard/](https://developer.yahoo.com/dashboard/)
 * New Application Form - [https://developer.yahoo.com/dashboard/createKey.html](https://developer.yahoo.com/dashboard/)


Examples
========

## Creating a Session:

A session hold three important objects: a YDN Application ID, an OAuth 
consumer and an OAuth access token. These objects provide the 
credentials needed to initialize requests and sign using OAuth. To create a 
new session using YOSSession, initialize it by using your consumer 
key, consumer secret and application ID you just got as parameters.

	// create a session by passing our   
	// consumer key, consumer secret and application id.  
	YOSSession *session = [YOSSession sessionWithConsumerKey:@"Key"  
	                                       andConsumerSecret:@"Secret"  
	                                        andApplicationId:@"AppID"];

## Initializing a Session:

Because a session can persistent you next check for an existing user session. 
If a user session does not exist yet, they must login in order for the 
application to gain access to their protected user information. (profile, 
connections, updates, etc.) Alternatively, if a session exists, the session 
will automatically fetch a new access token to renew the session.

	// try to resume a user session if one exists  
	BOOL hasSession = [session resumeSession];  
	
	if(hasSession == FALSE) {  
	   [session sendUserToAuthorizationWithCallbackUrl:nil];  
	}else{  
	   [self sendRequests];  
	}

## Fetching Social Data:

Now that we have a ready session, we can now access social information for 
the logged-in user. The depth of user data you can access will depend on 
the permissions for which your application asked.

Each 'GET' method of YOSUserRequest creates an asynchronous request with the 
delegate you provided. When the request is returned, the delegate method 
'requestDidFinishLoading' is invoked with a YOSResponseData object containing 
the NSHTTPURLResponse object, NSData response object, a responseText string 
and an NSError object (if an error occurred) for which your application should handle.

To work with the response data object, parse the response text 
(defaults to encoded JSON data) using the methods from json-framework.

	- (void)sendRequests {
	   // initialize a user request for the logged-in user   
	   YOSUserRequest *request = [YOSUserRequest requestWithSession:session];
	   
	   // fetch the user's profile data
	   YOSResponseData *userProfileResponse = [request fetchProfileWithDelegate:self];
	}

	- (void)requestDidFinishLoading:(YOSResponseData *)data {
	   // parse the response text string into a dictionary
	   NSDictionary *rspData = [data.responseText JSONValue];
	   NSDictionary *profileData = [rspData objectForKey:@"profile"];
	   
  	   // format a string using the nickname object from the profile.
  	   NSString *welcomeText = [NSString stringWithFormat:@"Hey %@ %@!", 
	      [profileData objectForKey:@"givenName"],
	      [profileData objectForKey:@"familyName"]];
	}

## Posting User Activities

Yahoo! provides two means for you to share your user's activities back to other Yahoo! users:

Status: A line of text describing what a user is currently doing.

Updates: A user's stream of shared activities. (Each containing, at the very least, a 
line of developer-supplied text, your icon and a link back to your application.)

You can use these channels to advertise your user's use of your app to a 
large audience of Yahoo! users, driving this larger group to your product.

The sample code below shows how to set a user's status and post an update 
to their activity stream.

Status:

	// get the logged-in user
	YOSUserRequest *request = [YOSUserRequest requestWithSession:session];
   
	// set the user's current status message
	[request setStatus:@"is hacking"];

Updates:

	YOSUserRequest *request = [YOSUserRequest requestWithSession:session];
	
	[request insertUpdateWithTitle:@"installed Foo app on their iPhone" 
                    andDescription:@""
                           andLink:@"http://myapplication.com/download"
                           andDate:nil 
                           andSuid:[request generateUniqueSuid]];

## Using YQL

Synchronous :
	
	YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];  
	   
	NSString *structuredLocationQuery = [NSString   
	            stringWithFormat:@"select * from geo.places where text=\"sfo\""];  
	   
	YOSResponseData *data = [request query:structuredLocationQuery];
	NSDictionary *rspData = [data.responseText JSONValue];
	NSDictionary *queryData = [rspData objectForKey:@"query"];  
	NSDictionary *results = [queryData objectForKey:@"results"];  
	   
	NSLog(@"%@", [results description]);

Asynchronous:

	- (void)sendRequests {  
	   YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];  
	   
	   NSString *structuredLocationQuery = [NSString   
	            stringWithFormat:@"select * from geo.places where text=\"sfo\""];  
	   
	   [request query:structuredLocationQuery withDelegate:self];  
	}  
  
	- (void)requestDidFinishLoading:(YOSResponseData *)data {  
	   NSDictionary *rspData = [data.responseText JSONValue];  
	   NSDictionary *queryData = [rspData objectForKey:@"query"];  
	   NSDictionary *results = [queryData objectForKey:@"results"];  
	   
	   NSLog(@"%@", [results description]);  
	}

## Terms of Use

Use of the Yahoo! Social APIs is governed by the [Yahoo! APIs Terms of Use](http://developer.yahoo.com/terms/).
Your use of YQL is subject to the [YQL Terms of Service](http://info.yahoo.com/legal/us/yahoo/yql/yql-4307.html).