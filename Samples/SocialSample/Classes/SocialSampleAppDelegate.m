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
    NSLog(@"url = %@", url);
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
    self.session = [YOSSession sessionWithConsumerKey:@"dj0yJmk9WERUdWdhazVJdWFxJmQ9WVdrOVRuZGhSMWRqTXpJbWNHbzlNVEkyTXpVd05UZzJNZy0tJnM9Y29uc3VtZXJzZWNyZXQmeD04Yg--"
									andConsumerSecret:@"f03ee662ba1602d30d2d88e5dc7defb30ff49827"
									 andApplicationId:@"NwaGWc32"];
    
    
	if(self.oauthResponse) {
		NSString *verifier = [self.oauthResponse valueForKey:@"oauth_verifier"];
		[self.session setVerifier:verifier];
	}
	
	BOOL hasSession = [self.session resumeSession];
	
	if(!hasSession) {
		[self.session sendUserToAuthorizationWithCallbackUrl:@"com-yourcompany-SocialSample:oauth"];
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




@end
