//
//  YOSOpenSocialRequest.h
//  YahooSocialSdk
//
//  Created by Zach Graves on 9/2/09.
//  Copyright 2009 Yahoo! Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YOSBaseRequest.h"

/**
 * Experimental OpenSocial request class.
 */
@interface YOSOpenSocialRequest : YOSBaseRequest {

}

/**
 * Fetches an OpenSocial data source.
 * @param relativeUrl			The relative opensocial url. 
 * @param params				A dictionary of parameters to be included in the request.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL) getDataForUrl:(NSString *)relativeUrl andParameters:(NSMutableDictionary *)params delegate:(id)delegate;

/**
 * Retrieves a users collection of connections.
 * @param guid					The GUID of the user.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL) fetchConnectionsForUser:(NSString *)guid delegate:(id)delegate;

/**
 * Retrieves a users profile.
 * @param guid					The GUID of the user.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL) fetchProfileForUser:(NSString *)guid delegate:(id)delegate;

/**
 * Retrieves a collection of user activities.
 * @param guid					The GUID of the user.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL) fetchActivitiesForUser:(NSString *)guid delegate:(id)delegate;

/**
 * Retrieves a collection of user activities from an application.
 * @param guid					The GUID of the user.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL) fetchApplicationActivitiesForUser:(NSString *)guid delegate:(id)delegate;

/**
 * Retrieves a single user activity from an application.
 * @param guid					The GUID of the user.
 * @param activityID			An activity indentifier.
 * @param delegate				An object containing the methods to handle the request's response. 
 */
- (BOOL) fetchApplicationActivityForUser:(NSString *)guid andActivityId:(NSString *)activityID delegate:(id)delegate;

@end
