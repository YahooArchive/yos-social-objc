//
//  YOAuthUtil.h
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/20/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

/**
 * A utility providing methods to create OAuth parameters for 
 * oauth_nonce, timestamp and version.
 */
@interface YOAuthUtil : NSObject

#pragma mark - Public methods

/**
 * Returns an unique oauth_nonce parameter.
 */
+ (NSString *)oauth_nonce;

/**
 * Returns the current timestamp usable as the oauth_timestamp parameter.
 */
+ (NSString *)oauth_timestamp;

/**
 * Returns the oauth_version parameter.
 */
+ (NSString *)oauth_version;

@end
