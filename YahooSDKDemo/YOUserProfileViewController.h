//
//  YOUserProfileViewController.h
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/6/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <UIKit/UIKit.h>

@interface YOUserProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) NSDictionary *userProfile;

- (void)loadUserProfile:(NSDictionary *)userProfile;
- (void)signOut;

@end
