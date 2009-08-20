//
//  YOSUserRequest.h
//  YosCocoaSdk
//
//  Created by Zach Graves on 2/17/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>
#import "YOSBaseRequest.h"
#import "YOSResponseData.h"
#import "YOSSession.h"

/**
 * YOSUserRequest is a sub-class of YOSBaseRequest that provides access to each of the user-specific
 * resources of the social platform.
 */
@interface YOSUserRequest : YOSBaseRequest {
	
}

/**
 * Fetches the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first connection returned. 
 * @param count					An integer specifying the number of connections returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchConnectionsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the user's contacts using an asynchronous request.
 * @param start					An integer specifying the index of the first contact returned. 
 * @param count					An integer specifying the number of contacts returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchContactsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the profile of the user using an asynchronous request.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchProfileWithDelegate:(id)delegate;

/**
 * Fetches the user's location data.
 * @param delegate
 */ 
- (void)fetchProfileLocationWithDelegate:(id)delegate;

/**
 * Fetches the profiles of the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first connection returned. 
 * @param count					An integer specifying the number of connections returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchConnectionProfilesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the current status messages of the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first connection returned. 
 * @param count					An integer specifying the number of connections returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchConnectionsStatusWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the updates for the user using an asynchronous request.
 * @param start					An integer specifying the index of the first update returned. 
 * @param count					An integer specifying the number of updates returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the updates for the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first update returned. 
 * @param count					An integer specifying the number of updates returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchConnectionUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the current status message for the user using an asynchronous request.
 * @return YOSResponseData		An object containing the response data and any errors encountered.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (void)fetchStatusWithDelegate:(id)delegate;

/**
 * Sets the user's status message using a synchronous request.
 * @param theStatus				A status message string.
 * @return						A boolean, true if the users status was successfully set.
 */
- (BOOL)setStatus:(NSString *)theStatus;

/**
 * Deletes an update for the specified SUID using a synchronous request.
 * @param aSuid					A string that represents an update.
 * @return						A boolean, true if the update was successfully deleted.
 */
- (BOOL)deleteUpdate:(NSString *)aSuid;

/**
 * Inserts an update into the users stream using a synchronous request.
 * @param aTitle				Specifies a title string for the update.
 * @param aDescription			Specifies a description string for the update.
 * @param aLink					Specifies a URL for the update.
 * @param aDate					Specifies a date for the update.
 * @param aSuid					Specifies an unique ID string for the update.
 * @return						A boolean, true if the update was succesfully inserted.
 */
- (BOOL)insertUpdateWithTitle:(NSString *)aTitle 
			   andDescription:(NSString *)aDescription 
					  andLink:(NSString *)aLink 
					  andDate:(NSDate *)aDate
					  andSuid:(NSString *)aSuid;

/**
 * Sets the YAP small view contents of this application for this user using a synchronous request.
 * @param content	A string containing text, HTML and YML. 
 * @return				A boolean, true if the request was successful.
 */
- (BOOL)setSmallViewWithContents:(NSString *)content;

/**
 * Creates a unique string (SUID) usable for inserting an update.
 * @return						A string containing a unique ID.
 */
- (NSString *)generateUniqueSuid;

@end
