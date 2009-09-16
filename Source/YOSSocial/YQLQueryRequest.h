//
//  YOSQueryRequest.h
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSBaseRequest.h"
#import "YOSResponseData.h"

/**
 * YOSQueryRequest is a sub-class of YOSBaseRequest that provides a wrapper for the YQL web-service.
 * @see http://developer.yahoo.com/yql/
 * @see http://developer.yahoo.com/yql/console/
 */
@interface YQLQueryRequest : YOSBaseRequest {
	/**
	 * Returns the receiver's optional YQL environment file.
	 */
	NSString *environmentFile;
	
	/**
	 * Returns a boolean determining if the request will return diagnostics information.
	 */
	BOOL diagnostics;
}

@property (nonatomic, readwrite, retain) NSString *environmentFile;
@property (readwrite) BOOL diagnostics;

/**
 * Sends a query request to YQL. 
 * @param aQuery				A YQL query.
 */
- (YOSRequestClient *)generateRequest:(NSString *)aQuery;

/**
 * Sends a select query request to YQL asynchronously.
 * @param aQuery				A YQL query.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)query:(NSString *)aQuery withDelegate:(id)delegate;

/**
 * Sends a query request to YQL synchronously.
 * @param aQuery				A YQL query.
 */
- (YOSResponseData *)query:(NSString *)aQuery;

/**
 * Sends an UPDATE/DELETE or INSERT query request to YQL synchronously. 
 * @param aQuery				A YQL query.
 */
- (BOOL)updateQuery:(NSString *)aQuery;

/**
 * Sends an UPDATE/DELETE or INSERT query request to YQL asynchronously. 
 * @param aQuery				A YQL query.
 * @param delegate				An object containing the methods to handle the request's response. 
 */ 
- (BOOL)updateQuery:(NSString *)aQuery withDelegate:(id)delegate;

/**
 * Joins stuff.
 * @param queries				An array of strings
 */
- (NSString *)queryByJoiningQueries:(NSArray *)queries;


@end
