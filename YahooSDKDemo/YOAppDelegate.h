//
//  YOAppDelegate.h
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/5/14.
//  Copyright 2014 Yahoo Inc.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <UIKit/UIKit.h>

@interface YOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)createYahooSession;
- (void)logout;

- (void)pushUserProfileToVC;
- (void)pushContactListToVC;

@end
