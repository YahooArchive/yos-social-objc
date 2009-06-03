//
//  YOSAccessToken.h
//  YOSSocial
//
//  Created by Zach Graves on 2/14/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthToken.h"

/**
 * YOSAccessToken is a sub-class of YOAuthToken that contains the access token key and secret, along 
 * with extensions for the logged-in user's GUID, token expiration dates and OAuth session handle.
 */
@interface YOSAccessToken : YOAuthToken {
@protected
	/**
	 * Returns the GUID of the logged-in (the token owner) user.
	 */
	NSString		*guid;
	
	/**
	 * Returns the OAuth session handle for the token.
	 */
	NSString		*sessionHandle;
	
	/**
	 * Returns the OAuth consumer key for the token.
	 */
	NSString		*consumer;
	
	/**
	 * Returns a NSDate representing the expiry date of this token.
	 */
	NSDate			*tokenExpiresDate;
	
	/**
	 * Returns a NSDate representing the application authorization expiry date.
	 */
	NSDate			*authExpiresDate;
	
	/**
	 * Returns an integer of the UNIX time that the token will expire.
	 */
	NSInteger		tokenExpires;
	
	/**
	 * Returns an integer of the UNIX time that application authorization will expire.
	 */
	NSInteger		authExpires;
}

@property (nonatomic, readwrite, retain) NSString *guid;
@property (nonatomic, readwrite, retain) NSString *sessionHandle;
@property (nonatomic, readwrite, retain) NSString *consumer;
@property (nonatomic, readwrite, retain) NSDate *tokenExpiresDate;
@property (nonatomic, readwrite, retain) NSDate *authExpiresDate;
@property (nonatomic, readwrite) NSInteger tokenExpires;
@property (nonatomic, readwrite) NSInteger authExpires;

/**
 * Returns an access token for the specified dictionary containing token variables.
 * @param responseData	FooDoc
 * @return				The initialized access token.
 */
+ (YOSAccessToken *)tokenFromResponse:(NSData *)responseData;

/**
 * FooDoc
 */
+ (YOSAccessToken *)tokenFromStoredDictionary:(NSDictionary *)tokenDictionary;

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
