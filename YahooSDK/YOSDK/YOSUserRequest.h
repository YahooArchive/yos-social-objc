//
//  YOSUserRequest.h
//  YosCocoaSdk
//
//  Created by Zach Graves on 2/17/09.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>
#import "YOSBaseRequest.h"
#import "YOSResponseData.h"
#import "YahooSession.h"

/**
 * YOSUserRequest is a sub-class of YOSBaseRequest that provides access to each of the user-specific
 * resources of the social platform.
 */
@interface YOSUserRequest : YOSBaseRequest

/**
 * Fetches the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first connection returned. 
 * @param count					An integer specifying the number of connections returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchConnectionsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the user's contacts using an asynchronous request.
 * @param start					An integer specifying the index of the first contact returned. 
 * @param count					An integer specifying the number of contacts returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchContactsWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches a single contact given a contact ID number.
 * @param contactId				An integer specifying a contact ID.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchContactWithID:(NSInteger)contactId withDelegate:(id)delegate;

/**
 * Adds a contact to the users address book given a dictionary of contact fields. 
 * @param contact				A dictionary containing a list of contact fields such as name, email and nickname
 */ 
- (BOOL)addContact:(NSDictionary *)contact;

/**
 * Fetches the users contact list given a local revision ID.
 * @param revision				An integer specifying the local revision.
 * @param delegate				An object containing the methods to handle the request's response. 
 */ 
- (BOOL)fetchContactSyncRevision:(NSInteger)revision withDelegate:(id)delegate;

/**
 * Fetches the users contact list given a local revision ID.
 * @param contactsync			A dictionary of a users local contact list with a local revision ID.
 */ 
- (BOOL)syncContactsRevision:(NSDictionary *)contactsync;

/**
 * Fetches the profile of the user using an asynchronous request.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchProfileWithDelegate:(id)delegate;

/**
 * Fetches the location of the user from their profile using an asynchronous request.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchProfileLocationWithDelegate:(id)delegate;

/**
 * Fetches probable locations from the content of a document.
 * @param documentContent		A string of text.
 * @param documentType			A document type such as 'text/plain'
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchPlacesFromContent:(NSString *)documentContent andDocumentType:(NSString *)documentType withDelegate:(id)delegate;

/**
 * Fetches the structured location data for a given place name.
 * @param location				A place name or location string.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchPlaceForLocation:(NSString *)location withDelegate:(id)delegate;

/**
 * Fetches the profiles of the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first connection returned. 
 * @param count					An integer specifying the number of connections returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchConnectionProfilesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the current status messages of the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first connection returned. 
 * @param count					An integer specifying the number of connections returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchConnectionsStatusWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the updates for the user using an asynchronous request.
 * @param start					An integer specifying the index of the first update returned. 
 * @param count					An integer specifying the number of updates returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the updates for the user's connections using an asynchronous request.
 * @param start					An integer specifying the index of the first update returned. 
 * @param count					An integer specifying the number of updates returned.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchConnectionUpdatesWithStart:(NSInteger)start andCount:(NSInteger)count withDelegate:(id)delegate;

/**
 * Fetches the current status message for the user using an asynchronous request.
 * @return YOSResponseData		An object containing the response data and any errors encountered.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL)fetchStatusWithDelegate:(id)delegate;

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
 * Foo
 */
- (BOOL)query:(NSString *)aQuery withDelegate:(id)delegate;

/**
 * Creates a unique string (SUID) usable for inserting an update.
 * @return						A string containing a unique ID.
 */
- (NSString *)generateUniqueSuid;

+ (NSArray *)parseContactList:(NSDictionary *)contactDict;

+ (NSArray *)parseContactListForNameOnly:(NSArray *)contactList;

+ (NSArray *)parseContactListForYahooIDOnly:(NSArray *)contactList;

@end
