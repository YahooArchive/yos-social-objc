//
//  YOSSession.h
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

#import "YOAuthConsumer.h"
#import "YOSAccessToken.h"
#import "YOSTokenStore.h"

/**
 * <code>YOSSession</code> objects represent an application session connecting it to the Yahoo! social APIs. 
 * <p>A session encapsulates three basic elements that provide access information to a 
 * <code>YOSUser</code> and each request that utilize it; the application ID, OAuth consumer and OAuth access token.</p>
 */
@interface YOSSession : NSObject {
@protected
	/**
	 * Returns the application ID to identify this session.
	 */
	NSString			*applicationId;
	
	/**
	 * Returns the OAuth consumer for this session.
	 */
	YOAuthConsumer		*consumer;
	
	/**
	 * Returns the token store for this session's consumer.
	 */
	YOSTokenStore		*tokenStore;
	
	/**
	 * Returns the reciever's OAuth access token for this session.
	 * @private
	 */
	YOSAccessToken		*accessToken;
	
	/**
	 * Returns the reciever's OAuth request token for this session.
	 * @private
	 */
	YOSRequestToken		*requestToken;
	
	/**
	 * The verifier key entered into or returned to the application after the user allows access.
	 * @private
	 */
	NSString			*verifier;
}

@property (nonatomic, readwrite, retain) NSString *applicationId;
@property (nonatomic, readwrite, retain) YOAuthConsumer *consumer;
@property (nonatomic, readwrite, retain) YOSAccessToken *accessToken;
@property (nonatomic, readwrite, retain) YOSRequestToken *requestToken;
@property (nonatomic, readwrite, retain) YOSTokenStore *tokenStore;
@property (nonatomic, readwrite, retain) NSString *verifier;

/**
 * Creates and returns a new <code>YOSSession</code> with an initialized token store.
 * @param aConsumerKey		The OAuth consumer key assigned to the application.
 * @param aConsumerSecret	The OAuth consumer secret assigned to the application.
 * @param anApplicationId	The application ID to identify this session.
 * @return					The initialized session.
 */
+ (YOSSession *)sessionWithConsumerKey:(NSString *)aConsumerKey 
					 andConsumerSecret:(NSString *)aConsumerSecret 
					  andApplicationId:(NSString *)anApplicationId;

/**
 * Returns a session for the specified OAuth consumer and application ID.
 * <p>In order to make the session able to handle user requests, use <code>resumeSession</code>
 * to get and set the session's access token.
 * 
 * @param anOAuthConsumer	The OAuth consumer for your application.
 * @param anApplicationId	The application ID to identify this session.
 * @return					The initialized session.
 * @see YOAuthConsumer
 */
- (id)initWithConsumer:(YOAuthConsumer *)anOAuthConsumer andApplicationId:(NSString *)anApplicationId;

/**
 * Removes the session's request and access token from the session, effectively logging out the user and application.
 */
- (void)clearSession;

/**
 * Saves the session's request and access token to the token store.
 */
- (void)saveSession;

/**
 * Resumes a session with a stored request or access token.
 * @return				A Boolean which signals if a session was successfully resumed.  
 */
- (BOOL)resumeSession;

/**
 * Automatically fetches a new request token and opens the native browser for the user to login.
 * @param callbackUrl	An optional callback URL.
 */
- (void)sendUserToAuthorizationWithCallbackUrl:(NSString *)callbackUrl;

@end