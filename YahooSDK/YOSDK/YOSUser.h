//
//  YOSUser.h
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Updated by Michael Ho on 8/23/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

@class YahooSession;

/**
 * YOSUser is wrapper that acts as a bridge between YahooSession and all request classes 
 * by providing session, application and user information to those requests. From here 
 * a developer can specify a session, GUID, region and language for this user that all 
 * requests classes will reference in order to create, sign and send URL requests to the 
 * Yahoo! social APIs. 
 */
@interface YOSUser : NSObject
/**
 * Returns the specified region code for the user.
 * <p>The language code must conform to RFC 4646.</p>
 * <p>The default value is "US".</p>
 * @see http://www.ietf.org/rfc/rfc4646.txt
 */
@property (nonatomic, readwrite, strong) NSString *region;
/**
 * Returns the specified language code for the user.
 * <p>The region code must conform to an ISO 3166-1 alpha-2 country code.</p>
 * <p>The default value is "en-US".</p>
 * @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
 */
@property (nonatomic, readwrite, strong) NSString *language;
/**
 * Returns the alpha-numeric GUID that represents the user.
 * <p>A GUID is 26 bytes in length and can contain only the following characters: A-Z and 2-7.</p>
 */
@property (nonatomic, readwrite, strong) NSString *guid;
/**
 * Returns the YahooSession that has ownership of this user. (By virtue of it's access token)
 * @return				A YahooSession containing the consumer and access tokens that make up the session.
 */
@property (nonatomic, readwrite, strong) YahooSession *session;

/**
 * Returns a user for the owner of specified session.
 * @param theSession		The session that will provide the OAuth credentials and application information to this user.
 */
- (instancetype)initWithSession:(YahooSession *)theSession;

/**
 * Returns a user for the specified session and user GUID.
 * @param theSession		The session that will provide the OAuth credentials and application information to this user.
 * @param aGuid				The GUID of the user.
 */
- (instancetype)initWithSession:(YahooSession *)theSession andGuid:(NSString *)aGuid;

/**
 * Sets the YAP small view contents for this user.
 * @param theContent		A string containing text, HTML and YML.
 */
- (BOOL)setSmallView:(NSString *)theContent;

/**
 * Returns <code>true</code> if the user is the logged-in user of the session and access token.
 */
- (BOOL)isSessionedUser;

@end