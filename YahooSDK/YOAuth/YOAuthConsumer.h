//
//  YOAuthConsumer.h
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Update by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

/**
 * Contains the consumer key and secret for an application to identify itself back to the service provider.
 * @see http://oauth.net/core/1.0#anchor9
 */
@interface YOAuthConsumer : NSObject

/**
 * Return the receiver's OAuth consumer key.
 */
@property(nonatomic, strong) NSString *key;

/**
 * Return the receiver's OAuth consumer secret.
 */
@property(nonatomic, strong) NSString *secret;

/**
 * Creates a consumer with the specified key and secret.
 * @param aKey		The consumer key assigned to the application.
 * @param aSecret	The consumer secret assigned to the application.
 * @return			The initialized consumer.
 */
+ (instancetype)consumerWithKey:(NSString *)key andSecret:(NSString *)secret;

/**
 * Initializes a consumer with the specified key and secret.
 * @param aKey		The consumer key assigned to the application.
 * @param aSecret	The consumer secret assigned to the application.
 * @return			The initialized consumer.
 */
- (instancetype)initWithKey:(NSString *)key andSecret:(NSString *)secret;

@end
