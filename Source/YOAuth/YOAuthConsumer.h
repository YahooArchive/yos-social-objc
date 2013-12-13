//
//  YOAuthConsumer.h
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

/**
 * Contains the consumer key and secret for an application to identify itself back to the service provider.
 * @see http://oauth.net/core/1.0#anchor9
 */
@interface YOAuthConsumer : NSObject {
@protected
	/**
	 * Return the receiver's OAuth consumer key.
	 */
	NSString		*key;
	
	/**
	 * Return the receiver's OAuth consumer secret.
	 */
	NSString		*secret;
}

@property(nonatomic, readwrite, strong) NSString *key;
@property(nonatomic, readwrite, strong) NSString *secret;

/**
 * Creates a consumer with the specified key and secret.
 * @param aKey		The consumer key assigned to the application.
 * @param aSecret	The consumer secret assigned to the application.
 * @return			The initialized consumer.
 */
+ (YOAuthConsumer *)consumerWithKey:(NSString *)aKey andSecret:(NSString *)aSecret;

/**
 * Initializes a consumer with the specified key and secret.
 * @param aKey		The consumer key assigned to the application.
 * @param aSecret	The consumer secret assigned to the application.
 * @return			The initialized consumer.
 */
- (id)initWithKey:(NSString *)aKey andSecret:(NSString *)aSecret;

@end
