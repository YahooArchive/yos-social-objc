//
//  YahooSession.h
//  YahooSDK
//
//  Created by Michael Ho on 8/21/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

#import "YOAuthConsumer.h"
#import "YOSAccessToken.h"
#import "YOSTokenStore.h"

/**
 * Protocol for callback after successful login.
 */
@protocol YahooSessionDelegate <NSObject>

@required
- (void)didReceiveAuthorization;

@end

/**
 * YahooSession objects represent an application session connecting it to the Yahoo! social APIs.
 * A session encapsulates three basic elements that provide access information to a
 * YOSUser and each request that utilize it: the application ID, OAuth consumer and OAuth access token.
 */
@interface YahooSession : NSObject <UIWebViewDelegate>

#pragma mark - Public properties

/**
 * Returns the application ID to identify this session.
 */
@property (nonatomic, strong) NSString *applicationId;
/**
 * Returns the callback URL associated with this session's application ID.
 */
@property (nonatomic, strong) NSString *callbackUrl;
/**
 * Returns the OAuth consumer (contains consumer key and secret) for this session.
 */
@property (nonatomic, strong) YOAuthConsumer *consumer;
/**
 * Returns the receiver's OAuth access token for this session.
 * @private
 */
@property (nonatomic, strong) YOSAccessToken *accessToken;
/**
 * Returns the receiver's OAuth request token for this session.
 * @private
 */
@property (nonatomic, strong) YOSRequestToken *requestToken;
/**
 * Returns the token store for this session's consumer.
 */
@property (nonatomic, strong) YOSTokenStore *tokenStore;
/**
 * The authorization URL for the webView to allow the user to authorize the application.
 * @private
 */
@property (nonatomic, strong) NSURL *authorizationUrl;

@property BOOL mobileWebAuthorization;
@property UIViewController *rootViewController;
@property UIWebView *authorizationWebView;
@property UIWebView *mobileAuthorizationWebView;
@property (nonatomic, weak) id<YahooSessionDelegate> delegate;

#pragma mark - Lifecycle

/**
 * Creates and returns a new <code>YahooSession</code> with an initialized token store.
 * @param aConsumerKey		The OAuth consumer key assigned to the application.
 * @param aConsumerSecret	The OAuth consumer secret assigned to the application.
 * @param anApplicationId	The application ID to identify this session.
 * @return					The initialized session.
 */
+ (instancetype)sessionWithConsumerKey:(NSString *)consumerKey
					 andConsumerSecret:(NSString *)consumerSecret
					  andApplicationId:(NSString *)applicationId
                        andCallbackUrl:(NSString *)callbackUrl
                           andDelegate:(id)delegate;

/**
 * Returns a session for the specified OAuth consumer and application ID.
 * In order to make the session able to handle user requests, use resumeSession
 * to get and set the session's access token.
 * 
 * @param anOAuthConsumer	The OAuth consumer for your application.
 * @param anApplicationId	The application ID to identify this session.
 * @return					The initialized session.
 * @see YOAuthConsumer
 */
- (instancetype)initWithConsumer:(YOAuthConsumer *)oAuthConsumer
                andApplicationId:(NSString *)applicationId
                  andCallbackUrl:(NSString *)callbackUrl
                     andDelegate:(id)delegate;

#pragma mark - Public methods

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
- (void)sendUserToAuthorization;

/**
 * Protocol for callback after login
 */

@end