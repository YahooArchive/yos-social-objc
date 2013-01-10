//
//  SocialSampleAppDelegate.h
//  SocialSample
//
//  Created by Zach Graves on 3/18/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <UIKit/UIKit.h>

@class SocialSampleViewController;
@class YOSSession;

@interface SocialSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    SocialSampleViewController *viewController;
	
	YOSSession					*session;
	NSMutableDictionary			*oauthResponse;
	BOOL						launchDefault;
}

@property BOOL launchDefault;
@property (nonatomic, readwrite, strong) YOSSession *session;
@property (nonatomic, readwrite, strong) NSMutableDictionary *oauthResponse;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet SocialSampleViewController *viewController;

- (void)getUserProfile;
- (void)createYahooSession;
- (void)handlePostLaunch;

@end

