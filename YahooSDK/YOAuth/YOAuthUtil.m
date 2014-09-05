//
//  YOAuthUtil.m
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/20/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthUtil.h"

static NSString *const kOAuthVersion= @"1.0";

@implementation YOAuthUtil

#pragma mark - Public methods

+ (NSString *)oauth_nonce
{	
	NSString *nonce = nil;
	CFUUIDRef generatedUUID = CFUUIDCreate(kCFAllocatorDefault);
	nonce = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, generatedUUID));
	CFRelease(generatedUUID);
	
	return nonce;
}

+ (NSString *)oauth_timestamp
{
	return [NSString stringWithFormat:@"%ld", time(NULL)];
}

+ (NSString *)oauth_version
{
	return kOAuthVersion;
}

@end
