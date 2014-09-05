//
//  YOSAccessToken.h
//  YOSSocial
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthToken.h"

/**
 * YOSAccessToken is a sub-class of YOAuthToken that contains the access token key and secret, along 
 * with extensions for the logged-in user's GUID, token expiration dates and OAuth session handle.
 */
@interface YOSAccessToken : YOAuthToken
/**
 * Returns the GUID of the logged-in (the token owner) user.
 */
@property (nonatomic, readwrite, strong) NSString *guid;
/**
 * Returns the OAuth session handle for the token.
 */
@property (nonatomic, readwrite, strong) NSString *sessionHandle;
/**
 * Returns the OAuth consumer key for the token.
 */
@property (nonatomic, readwrite, strong) NSString *consumer;
/**
 * Returns a NSDate representing the expiry date of this token.
 */
@property (nonatomic, readwrite, strong) NSDate *tokenExpiresDate;
/**
 * Returns a NSDate representing the application authorization expiry date.
 */
@property (nonatomic, readwrite, strong) NSDate *authExpiresDate;
/**
 * Returns an integer of the UNIX time that the token will expire.
 */
@property (nonatomic, readwrite) NSInteger tokenExpires;
/**
 * Returns an integer of the UNIX time that application authorization will expire.
 */
@property (nonatomic, readwrite) NSInteger authExpires;

/**
 * Returns an access token for the specified dictionary containing token variables.
 * @param responseData	FooDoc
 * @return				The initialized access token.
 */
+ (instancetype)tokenFromResponse:(NSData *)responseData;

/**
 * FooDoc
 */
+ (instancetype)tokenFromStoredDictionary:(NSDictionary *)tokenDictionary;

/**
 * Creates a mutable dictionary containing the token data.
 * @return				A dictionary containing access token variables.
 */
- (NSMutableDictionary *)tokenAsDictionary;

/**
 * Returns true if the token has expired.
 */
- (BOOL)tokenHasExpired;

@end
