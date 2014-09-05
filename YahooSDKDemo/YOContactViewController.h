//
//  YOViewController.h
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/5/14.
//  Copyright 2014 Yahoo Inc.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <UIKit/UIKit.h>

@interface YOContactViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationBar *topNavigationBar;

@property (strong, nonatomic) NSArray *contactList;
- (void)loadContactList:(NSArray *)contactList;
- (void)skipToProfile;

@end
