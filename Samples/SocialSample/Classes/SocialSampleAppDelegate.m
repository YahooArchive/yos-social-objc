//
//  SocialSampleAppDelegate.m
//  SocialSample
//
//  Created by Zach Graves on 3/18/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "SocialSampleAppDelegate.h"
#import "SocialSampleViewController.h"

#import "YOSUser.h"
#import "YOSUserRequest.h"
#import "NSString+SBJSON.h"

@implementation SocialSampleAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize session;
@synthesize launchDefault;
@synthesize oauthResponse;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	launchDefault = YES;
	[self performSelector:@selector(handlePostLaunch) withObject:nil afterDelay:0.0];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url 
{
	launchDefault = NO;
	
	if (!url) { 
		return NO; 
	}
	
	NSArray *pairs = [[url query] componentsSeparatedByString:@"&"];
	NSMutableDictionary *response = [NSMutableDictionary dictionary];
	
	for (NSString *item in pairs) {
		NSArray *fields = [item componentsSeparatedByString:@"="];
		NSString *name = [fields objectAtIndex:0];
		NSString *value = [[fields objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		[response setObject:value forKey:name];
	}
	
	self.oauthResponse = response;
	
	[self createYahooSession];
	
	return YES;
}

- (void)handlePostLaunch
{
	if(self.launchDefault) {
		[self createYahooSession];
	}
}

- (void)createYahooSession
{
	// create session with consumer key, secret and application id
	// set up a new app here: https://developer.yahoo.com/dashboard/createKey.html
	// because the default values here won't work
	self.session = [YOSSession sessionWithConsumerKey:@"YOUR_CONSUMER_KEY" 
									andConsumerSecret:@"YOUR_CONSUMER_SECRET" 
									 andApplicationId:@"YOUR_APP_ID"];
	
	if(self.oauthResponse) {
		NSString *verifier = [self.oauthResponse valueForKey:@"oauth_verifier"];
		[self.session setVerifier:verifier];
	}
	
	BOOL hasSession = [self.session resumeSession];
	
	if(!hasSession) {
		[self.session sendUserToAuthorizationWithCallbackUrl:nil];
	} else {
		[self getUserProfile];
	}
}

- (void)getUserProfile
{
	// initialize the profile request with our user.
	YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
	
	// get the users profile
	[userRequest fetchProfileWithDelegate:self];
}

- (void)requestDidFinishLoading:(YOSResponseData *)data
{
	NSDictionary *userProfile = [[data.responseText JSONValue] objectForKey:@"profile"];
	// NSLog(@"%@",[userProfile description]);
	if(userProfile) {
		[viewController setUserProfile:userProfile];
	}
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
