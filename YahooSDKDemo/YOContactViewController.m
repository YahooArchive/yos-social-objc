//
//  YOViewController.m
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/5/14.
//  Copyright (c) 2014 Yahoo! Inc. All rights reserved.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOContactViewController.h"
#import "YOAppDelegate.h"

@implementation YOContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setTitle:@"Find your friends"];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(skipToProfile)];
    self.navigationItem.rightBarButtonItem = skipButton;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Friends"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"My contacts";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        NSString *givenName = [self.contactList objectAtIndex:indexPath.row][@"name"][@"givenName"];
        NSString *familyName = [self.contactList objectAtIndex:indexPath.row][@"name"][@"familyName"];
        
        NSString *fullName;
        if (familyName) {
            fullName = [NSString stringWithFormat:@"%@ %@",givenName,familyName];
        } else if (givenName) {
            fullName = givenName;
        }
        
        cell.textLabel.text = fullName;
        cell.imageView.image = [UIImage imageNamed:@"profile-150x150.png"];
        
        UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        inviteButton.frame = CGRectMake(115.0f, 0.0f, 320.0f, 44.0f);
        
        [inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
        [inviteButton addTarget:self action:@selector(buttonInvited:) forControlEvents: UIControlEventTouchUpInside];
        [cell addSubview:inviteButton];
    }

    return cell;
}

#pragma mark - Public methods

- (void)loadContactList:(NSArray *)contactList
{
    self.contactList = contactList;

    // Set number of friends on left navigation item
    UINavigationItem *topNavigationItem = self.topNavigationBar.items[0];
    [topNavigationItem.leftBarButtonItem setTitle:[NSString stringWithFormat:@"%zd friends found",[self.contactList count]]];
    
    // Reload table
    [self.tableView reloadData];
}

- (void)skipToProfile
{
    YOAppDelegate *appDelegate = (YOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate pushUserProfileToVC];
}

#pragma IBAction

- (IBAction)buttonInvited:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitle:@"Invited" forState:UIControlStateNormal];
}

@end
