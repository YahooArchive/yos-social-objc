//
//  YOSBaseRequest.h
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

#import "YOAuthRequest.h"
#import "YOSRequestClient.h"
#import "YOAuthConsumer.h"
#import "YOSSession.h"
#import "YOSUser.h"


@class YOAuthConsumer;
@class YOAuthRequest;
@class YOAuthToken;
@class YOSUser;

/**
 * The base request class for each endpoint of the Yahoo! social APIs.
 * <p>A base request contains the default endpoint, format and versioning information and provides 
 * a user or consumer and token properties to allow a URL request to be signed with OAuth.</p>
 */
@interface YOSBaseRequest : NSObject {
@protected
	/**
	 * Returns the specified response format of the request.
	 */
	NSString			*format;
	
	/**
	 * Returns the specified version of the API.
	 */
	NSString			*apiVersion;
	
	/**
	 * Returns the name of the OAuth signature method that will be used to sign a URL request.
	 */
	NSString			*signatureMethod;
	
	/**
	 * Returns the hostname used to create a URL request.
	 */
	NSString			*baseUrl;
	
	/**
	 * Returns the optional OAuth consumer used to create and sign a URL request. 
	 * <p>Leave this nil if a YOSUser is set.</p>
	 */
	YOAuthConsumer		*consumer;
	
	/**
	 * Returns the optional OAuth token used to create and sign a URL request.
	 * <p>Leave this nil if a YOSUser is set.</p>
	 */
	YOAuthToken			*token;
	
	/**
	 * Returns the optional YOSUser and its session data used to create and sign a URL request.
	 */
	YOSUser				*user;
}

@property (nonatomic, readwrite, strong) NSString *format;
@property (nonatomic, readwrite, strong) NSString *apiVersion;
@property (nonatomic, readwrite, strong) NSString *baseUrl;
@property (nonatomic, readwrite, strong) NSString *signatureMethod;
@property (nonatomic, readwrite, strong) YOAuthConsumer *consumer;
@property (nonatomic, readwrite, strong) YOAuthToken *token;
@property (nonatomic, readwrite, strong) YOSUser *user;

/**
 * Returns a new request for the sessioned-user.
 * @param session			A YOSSession object.
 * @return					The initialized request.
 */
+ (id)requestWithSession:(YOSSession *)session;

/**
 * Returns a request for the provided user.
 * @param aSessionedUser	A user and its session used to sign a URL request.
 * @return					The initialized request.
 * @see YOSUser
 */
- (id)initWithYOSUser:(YOSUser *)aSessionedUser;

/**
 * Returns a request for the provided consumer.
 * @param aConsumer			The OAuth consumer used to sign a URL request.
 * @return					The initialized request.
 * @see YOAuthConsumer
 */
- (id)initWithConsumer:(YOAuthConsumer *)aConsumer;

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
- (NSData *)serializeDictionary:(NSDictionary *)aDictionary;

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