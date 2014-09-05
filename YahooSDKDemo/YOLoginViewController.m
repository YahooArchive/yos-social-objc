//
//  YOLoginViewController.m
//  YahooSDKDemo
//
//  Created by Michael Ho on 8/6/14.
//  Copyright 2014 Yahoo Inc.
//
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOLoginViewController.h"
#import "YOAppDelegate.h"

@implementation YOLoginViewController

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
    [self.navigationItem setTitle:@"Yahoo SDK Demo"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)loginYahooPressed:(id)sender {
    YOAppDelegate*appDelegate = (YOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate createYahooSession];
}

@end
