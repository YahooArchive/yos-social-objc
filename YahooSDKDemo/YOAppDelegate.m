//
//  YOAppDelegate.m
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/5/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAppDelegate.h"

#import "YahooSDK.h"

#import "YOContactViewController.h"
#import "YOLoginViewController.h"
#import "YOUserProfileViewController.h"

@interface YOAppDelegate() <YahooSessionDelegate>

@property (strong, nonatomic) YahooSession *session;

#pragma mark - Private properties

@property (strong, nonatomic) YOContactViewController *contactViewController;
@property (strong, nonatomic) YOLoginViewController *loginViewController;
@property (strong, nonatomic) YOUserProfileViewController *userProfileViewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end

@implementation YOAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.contactViewController = [[YOContactViewController alloc] initWithNibName:@"YOContactViewController" bundle:nil];
    self.loginViewController = [[YOLoginViewController alloc] initWithNibName:@"YOLoginViewController" bundle:nil];
    self.userProfileViewController = [[YOUserProfileViewController alloc] initWithNibName:@"YOUserProfileViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - YahooSessionDelegate

- (void)didReceiveAuthorization
{
    [self createYahooSession];
}

#pragma mark - YOSUserRequestDelegate

// Waiting to fetch response
- (void)requestDidFinishLoading:(YOSResponseData *)data
{
    
    // Get the JSON response, will exist ONLY if requested response is JSON
    // If JSON does not exist, use data.responseText for NSString response
    NSDictionary *json = data.responseJSONDict;
    
    // Profile fetched
    NSDictionary *userProfile = json[@"profile"];
	if (userProfile) {
        NSLog(@"User profile fetched");
        [self.userProfileViewController loadUserProfile:userProfile];
	}
    // Contacts fetched
    NSDictionary *contactDict = json[@"contacts"];
    if (contactDict) {
        NSLog(@"Contact list fetched");
        NSArray *contactList = [YOSUserRequest parseContactList:contactDict];
        NSArray *parsedContactList = [YOSUserRequest parseContactListForNameOnly:contactList];
        [self.contactViewController loadContactList:parsedContactList];
    }
    // YQL query response fetched
    NSDictionary *yqlDict = json[@"query"];
    if (yqlDict) {
        NSDictionary *yqlResults = yqlDict[@"results"];
        NSLog(@"%@",yqlResults);
    }
}

#pragma mark - Public methods

- (void)logout
{
    [self.session clearSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createYahooSession
{
	// Create session with consumer key, secret and application id
	// Set up a new app here: https://developer.yahoo.com/dashboard/createKey.html
	// The default values here won't work
    self.session = [YahooSession sessionWithConsumerKey:@"dj0yJmk9R1N5VUpMb3ZNQm1RJmQ9WVdrOVUybGxTazFsTnpRbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1mOA--"
                                    andConsumerSecret:@"081c033eabfed58ddc2afcdf04a96667e66dd355"
									 andApplicationId:@"SieJMe74"
                                       andCallbackUrl:@"http://mickey.io"
                                          andDelegate:self];
	
	BOOL hasSession = [self.session resumeSession];
    NSLog(@"%i",hasSession);
	
	if(!hasSession) {
        // Not logged-in, send login and authorization pages to user
		[self.session sendUserToAuthorization];
	} else {
        // Logged-in, send requests
        NSLog(@"Session detected!");
        [self sendUserContactsRequest];
        [self sendUserProfileRequest];
        [self pushContactListToVC];
        // [self sendASyncYQLRequests];
        // [self sendSyncYQLRequests];
	}
}

- (void)sendUserProfileRequest
{
	// Initialize profile request
	YOSUserRequest *userRequest = [YOSUserRequest requestWithSession:self.session];
	
	// Fetch user profile
	[userRequest fetchProfileWithDelegate:self];
}

- (void)sendUserContactsRequest
{
    // Initialize contact list request
    YOSUserRequest *request = [YOSUserRequest requestWithSession:self.session];
    
    // Fetch the user's contact list
    [request fetchContactsWithStart:0 andCount:300 withDelegate:self];
}

- (void)sendASyncYQLRequests
{
    // Initialize YQL request
    YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];
    
    // Build YQL query string
    NSString *structuredYQLQuery = [NSString stringWithFormat:@"select * from social.profile where guid = me"];
    
    // Fetch YQL response
    [request query:structuredYQLQuery withDelegate:self];
}

- (void)sendSyncYQLRequests
{
    YQLQueryRequest *request = [YQLQueryRequest requestWithSession:self.session];
    
    NSString *structuredLocationQuery = [NSString stringWithFormat:@"select * from geo.places where text=\"sfo\""];
    
    YOSResponseData *data = [request query:structuredLocationQuery];
    NSDictionary *json = data.responseJSONDict;
    NSDictionary *queryData = json[@"query"];
    NSDictionary *results = queryData[@"results"];
    
    NSLog(@"%@", results);
}

- (void)pushUserProfileToVC
{
    [self.navigationController pushViewController:self.userProfileViewController animated: YES];
}

- (void)pushContactListToVC
{
    [self.navigationController pushViewController:self.contactViewController animated: YES];
}

@end
