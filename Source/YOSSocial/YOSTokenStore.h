//
//  YOSTokenStore.h
//  YOSSocial
//
//  Created by Zach Graves on 2/23/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>
#import "YOAuthConsumer.h"
#import "YOSAccessToken.h"
#import "YOSRequestToken.h"

/**
 * A basic OAuth token storage system utilizing the user defaults. 
 * <p>Allows a developer can place and remove request and access tokens on demand.</p>
 */
@interface YOSTokenStore : NSObject {
	/**
	 * Returns the OAuth consumer used to identify a token.
	 */
	YOAuthConsumer		*consumer;
}

@property (nonatomic, readwrite, retain) YOAuthConsumer	*consumer;

/**
 * Returns a token store for the specified OAuth consumer.
 * @param theConsumer		An OAuth consumer containing a key and secret.
 * @return The initialized token store.
 */
- (id)initWithConsumer:(YOAuthConsumer *)theConsumer;

/**
 * Checks if an access token is found in the store.
 * @return				A boolean, true if the token store has an access token.
 */
- (BOOL)hasAccessToken;

/**
 * Returns the access token found in the store. 
 * <p>May be nil if a token is not present for the given consumer.</p>
 */
- (YOSAccessToken *)accessToken;

/**
 * Sets the access token into the store.
 * @param theToken		An OAuth request token
 * @return				A boolean, true if the token was set into the store successfully.
 */
- (BOOL)setAccessToken:(YOSAccessToken *)theToken;

/**
 * Removes the access token from the store.
 * @return				A boolean, true if the token was successfully removed.
 */
- (BOOL)removeAccessToken;

/**
 * Checks if a request token is found in the store.
 * @return				A boolean, true if the token store has an request token.
 */
- (BOOL)hasRequestToken;

/**
 * Returns the request token found in the store. 
 * <p>May be nil if none is present for the given consumer.</p>
 * @return				A request token.
 */
- (YOSRequestToken *)requestToken;

/**
 * Sets the request token into the store.
 * @param theToken		An OAuth request token
 * @return				A boolean, true if the token was set into the store successfully.
 */
- (BOOL)setRequestToken:(YOSRequestToken *)theToken;

/**
 * Removes the request token from the store.
 * @return				A boolean, true if the token was successfully removed.
 */
- (BOOL)removeRequestToken;

@end
