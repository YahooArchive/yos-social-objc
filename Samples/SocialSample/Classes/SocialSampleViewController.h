//
//  SocialSampleViewController.h
//  SocialSample
//
//  Created by Zach Graves on 3/18/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <UIKit/UIKit.h>

@interface SocialSampleViewController : UIViewController {
@private
	UILabel				*nicknameLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nicknameLabel;

- (void)setUserProfile:(NSDictionary *)data;

@end

