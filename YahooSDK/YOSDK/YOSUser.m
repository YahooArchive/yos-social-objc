//
//  YOSUser.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Updated by Michael Ho on 8/23/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSUser.h"
#import "YOSUserRequest.h"
#import "YahooSession.h"

static NSString *const kYOSUserDefaultLanguage = @"en-US";
static NSString *const kYOSUserDefaultRegion = @"US";

@implementation YOSUser

#pragma mark - Lifecycle

- (instancetype)initWithSession:(YahooSession *)theSession
{
	NSString *sessionedGuid = [[theSession accessToken] guid];
	
	return [self initWithSession:theSession andGuid:sessionedGuid];
}

- (instancetype)initWithSession:(YahooSession *)theSession andGuid:(NSString *)aGuid
{
	if(self = [super init])
	{
		[self setRegion:kYOSUserDefaultRegion];
		[self setLanguage:kYOSUserDefaultLanguage];
		[self setGuid:aGuid];
		[self setSession:theSession];
	}
	return self;
}

#pragma mark - Public methods

- (BOOL)setSmallView:(NSString *)theContent
{
	YOSUserRequest *userRequest = [[YOSUserRequest alloc] initWithYOSUser:self];
	BOOL smallViewWasSet = [userRequest setSmallViewWithContents:theContent];
	
	
	return smallViewWasSet;
}

- (BOOL)isSessionedUser
{
	return [self.session.accessToken.guid isEqualToString:self.guid];
}

@end
