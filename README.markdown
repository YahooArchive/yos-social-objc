Yahoo! Social SDK, Objective-C library
=================

Find documentation and support on Yahoo! Developer Network: http://developer.yahoo.com

 * Yahoo! Application Platform - http://developer.yahoo.com/yap/
 * Yahoo! Social APIs - http://developer.yahoo.com/social/
 * Yahoo! Query Language - http://developer.yahoo.com/yql/

Hosted on GitHub: http://github.com/yahoo/yos-social-objc/tree/master

License
=======

Software License Agreement (BSD License)
Copyright (c) 2009, Yahoo! Inc.
All rights reserved.
 
YOAuth
YOSSocial
 
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

The following dependencies are bundled with the Yahoo! Python SDK, but are under
terms of a separate license:

 * json-framework - http://code.google.com/p/json-framework/
 * OAuthConsumer Crypto - http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/Crypto/


Install
=======

Include the YOAuth, YOSSocial and json-framework groups into your Xcode project path. 
Then, include the YOSSocial.h header into your code.

    #import "YOSSocial.h" 


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
	   [session sendUserToAuthorizationWithCallback:nil];  
	}else{  
	   [self sendRequests];  
	}


## Fetching Social Data:
	
