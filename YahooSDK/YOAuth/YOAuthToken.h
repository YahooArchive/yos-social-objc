//
//  YOAuthToken.h
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
 * Contains an OAuth token key and secret provided by the service provider for an application to access private information.
 * This class should be extended to add any additional token information returned by the service provider.
 */
@interface YOAuthToken : NSObject

/**
 * The token key.
 */
@property(nonatomic, readwrite, strong) NSString *key;

/**
 * The token secret.
 */
@property(nonatomic, readwrite, strong) NSString *secret;

/**
 * Creates a token with the specified key and secret.
 * @param aKey			The token key
 * @param aSecret		The token secret
 * @return				The initialized token.
 */
+ (instancetype)tokenWithKey:(NSString *)key andSecret:(NSString *)secret;

/**
 * Creates a token with the specified dictionary containing OAuth response. 
 * @param aDictionary	The dictionary containing the OAuth response.
 * @return				The initialized token.
 */
+ (instancetype)tokenWithDictionary:(NSDictionary *)dictionary;

/**
 * Initializes a token with the specified key and secret.
 * @param aKey			The token key
 * @param aSecret		The token secret
 * @return				The initialized token.
 */
- (instancetype)initWithKey:(NSString *)key andSecret:(NSString *)secret;

@end
