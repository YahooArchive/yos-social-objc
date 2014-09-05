//
//  YOUserProfileViewController.m
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/6/14.
//  Copyright 2014 Yahoo Inc.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOUserProfileViewController.h"
#import "YOAppDelegate.h"

@implementation YOUserProfileViewController

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
    [self.navigationItem setTitle:@"My profile"];
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(signOut)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    [self loadUserProfile:self.userProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods

- (void)loadUserProfile:(NSDictionary *)userProfile
{
    self.userProfile = userProfile;
        
    // Check e-mail
    NSArray *emails = self.userProfile[@"emails"];
    NSString *primaryEmail = emails[0][@"handle"];
    
    // Check name
	NSString *welcomeText = [NSString stringWithFormat:@"Hey %@ %@!",
							 self.userProfile[@"givenName"],
							 self.userProfile[@"familyName"]];
    
    // Fetch image asynchronously
    NSURL *imageURL = [NSURL URLWithString:userProfile[@"image"][@"imageUrl"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            [self.profileImage setImage:[UIImage imageWithData:imageData]];
        });
    });
    
    // Set labels
	[self.welcomeLabel setText:welcomeText];
    [self.emailLabel setText:primaryEmail];
}

- (void)signOut
{
    YOAppDelegate *appDelegate = (YOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logout];
}

@end
