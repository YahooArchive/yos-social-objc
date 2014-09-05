//
//  YOSTokenStore.h
//  YOSSocial
//
//  Created by Zach Graves on 2/23/09.
//  Updated by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>
#import "YOAuthConsumer.h"
#import "YOSAccessToken.h"
#import "YOSRequestToken.h"

/**
 * A basic OAuth token storage system utilizing the user defaults. 
 * Allows a developer to place and remove request and access tokens on demand.
 */
@interface YOSTokenStore : NSObject

/**
 * Returns the OAuth consumer used to identify a token.
 */
@property (nonatomic, strong) YOAuthConsumer *consumer;

/**
 * Returns a token store for the specified OAuth consumer.
 * @param theConsumer		An OAuth consumer containing a key and secret.
 * @return The initialized token store.
 */
- (instancetype)initWithConsumer:(YOAuthConsumer *)consumer;

/**
 * Returns the access token found in the store. 
 * May be nil if a token is not present for the given consumer.
 */
- (YOSAccessToken *)accessToken;
/**
 * Checks if an access token is found in the store.
 * @return				A boolean, true if the token store has an access token.
 */
- (BOOL)hasAccessToken;
/**
 * Sets the access token into the store.
 * @param theToken		An OAuth request token
 * @return				A boolean, true if the token was set into the store successfully.
 */
- (void)setAccessToken:(YOSAccessToken *)token;
/**
 * Removes the access token from the store.
 * @return				A boolean, true if the token was successfully removed.
 */
- (void)removeAccessToken;

/**
 * Returns the request token found in the store. 
 * May be nil if none is present for the given consumer.
 * @return				A request token.
 */
- (YOSRequestToken *)requestToken;
/**
 * Checks if a request token is found in the store.
 * @return				A boolean, true if the token store has an request token.
 */
- (BOOL)hasRequestToken;
/**
 * Sets the request token into the store.
 * @param theToken		An OAuth request token
 * @return				A boolean, true if the token was set into the store successfully.
 */
- (void)setRequestToken:(YOSRequestToken *)token;
/**
 * Removes the request token from the store.
 * @return				A boolean, true if the token was successfully removed.
 */
- (void)removeRequestToken;

@end
