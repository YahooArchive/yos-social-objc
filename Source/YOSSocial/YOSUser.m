//
//  YOSUser.m
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSUser.h"
#import "YOSUserRequest.h"
#import "YOSSession.h"

static NSString *const kYOSUserDefaultLanguage = @"en-US";
static NSString *const kYOSUserDefaultRegion = @"US";

@implementation YOSUser

@synthesize region;
@synthesize language;
@synthesize guid;
@synthesize session;

#pragma mark init

- (id)initWithSession:(YOSSession *)theSession
{
	NSString *sessionedGuid = [[theSession accessToken] guid];
	
	return [self initWithSession:theSession andGuid:sessionedGuid];
}

- (id)initWithSession:(YOSSession *)theSession andGuid:(NSString *)aGuid
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

#pragma mark -
#pragma mark Public

- (BOOL)setSmallView:(NSString *)theContent
{
	YOSUserRequest *userRequest = [[YOSUserRequest alloc] initWithYOSUser:self];
	BOOL smallViewWasSet = [userRequest setSmallViewWithContents:theContent];
	
	[userRequest release];
	
	return smallViewWasSet;
}

- (BOOL)isSessionedUser
{
	return [session.accessToken.guid isEqualToString:guid];
}

@end
