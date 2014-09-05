//
//  YOSBaseRequest.h
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Updated by Michael Ho on 8/22/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

#import "YOAuthRequest.h"
#import "YOSRequestClient.h"
#import "YOAuthConsumer.h"
#import "YahooSession.h"
#import "YOSUser.h"


@class YOAuthConsumer;
@class YOAuthRequest;
@class YOAuthToken;
@class YOSUser;

/**
 * The base request class for each endpoint of the Yahoo! social APIs.
 * A base request contains the default endpoint, format and versioning information and provides
 * a user or consumer and token properties to allow a URL request to be signed with OAuth.
 */
@interface YOSBaseRequest : NSObject
/**
 * Returns the specified response format of the request.
 */
@property (nonatomic, strong) NSString *format;
/**
 * Returns the specified version of the API.
 */
@property (nonatomic, strong) NSString *apiVersion;
/**
 * Returns the hostname used to create a URL request.
 */
@property (nonatomic, strong) NSString *baseUrl;
/**
 * Returns the name of the OAuth signature method that will be used to sign a URL request.
 */
@property (nonatomic, strong) NSString *signatureMethod;
/**
 * Returns the optional OAuth consumer used to create and sign a URL request.
 * Leave this nil if a YOSUser is set.
 */
@property (nonatomic, strong) YOAuthConsumer *consumer;
/**
 * Returns the optional OAuth token used to create and sign a URL request.
 * Leave this nil if a YOSUser is set.
 */
@property (nonatomic, strong) YOAuthToken *token;
/**
 * Returns the optional YOSUser and its session data used to create and sign a URL request.
 */
@property (nonatomic, strong) YOSUser *user;

/**
 * Returns a new request for the sessioned-user.
 * @param session			A YahooSession object.
 * @return					The initialized request.
 */
+ (instancetype)requestWithSession:(YahooSession *)session;

/**
 * Returns a request for the provided user.
 * @param aSessionedUser	A user and its session used to sign a URL request.
 * @return					The initialized request.
 * @see YOSUser
 */
- (instancetype)initWithYOSUser:(YOSUser *)sessionedUser;

/**
 * Returns a request for the provided consumer.
 * @param aConsumer			The OAuth consumer used to sign a URL request.
 * @return					The initialized request.
 * @see YOAuthConsumer
 */
- (instancetype)initWithConsumer:(YOAuthConsumer *)consumer;

/**
 * Returns a deserialized object representing the provided JSON string.
 * @param value				The string to deserialize.
 * @return					An initialized object containing the JSON data.
 */
- (id)deserializeJSON:(NSData *)value;

/**
 * Returns a serialized JSON string representing the provided dictionary.
 * @param aDictionary		The dictionary to serialize.
 * @return					serialized json data
 */
- (NSData *)serializeDictionary:(NSDictionary *)dictionary;

/**
 * Returns the OAuth consumer located in either the user's session or this object. 
 * @return					The OAuth consumer. First preference goes to the session's consumer. May be nil.
 * @see YOAuthConsumer
 */
- (YOAuthConsumer *)oauthConsumer;

/**
 * Returns the OAuth token located in either the user's session or this object.
 * @return					The OAuth token. First preference goes to the session's token. May be nil.
 * @see YOAuthToken
 */
- (YOAuthToken *)oauthToken;

/**
 * Returns a new YOSRequestClient object.
 */
- (YOSRequestClient *)requestClient;

@end