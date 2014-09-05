//
//  YOSResponseData.h
//  YOSSocial
//
//  Created by Zach Graves on 2/26/09.
//  Modified by Michael Ho on 08/18/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

/**
 * An object containing the response data from API requests.
 */
@interface YOSResponseData : NSObject

/**
 * Returns the NSHTTPURLResponse from the request.
 */
@property (nonatomic, readwrite, strong) NSHTTPURLResponse *HTTPURLResponse;
/**
 * Returns the text representation of the response data.
 */
@property (nonatomic, readwrite, strong) NSString *responseText;
/**
 * Returns the dictionary in json format of the response data.
 */
@property (nonatomic, readwrite, strong) NSDictionary *responseJSONDict;
/**
 * Returns the NSData response from the request.
 */
@property (nonatomic, readwrite, strong) NSData *data;
/**
 * Returns the NSError from the request, if any.
 */
@property (nonatomic, readwrite, strong) NSError *error;
/**
 * Returns a BOOL representing if the request succeeded or not.
 */
@property BOOL didSucceed;

/**
 * Creates a new YOSResponseData object given the response data.
 * @param responseData		The NSData object containing the request response.
 * @param urlResponse		The NSURLResponse object resulting from a request.
 */
+ (YOSResponseData *)responseWithData:(NSData *)responseData andURLResponse:(NSURLResponse *)urlResponse;

@end
