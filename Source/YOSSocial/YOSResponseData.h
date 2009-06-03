//
//  YOSResponseData.h
//  YOSSocial
//
//  Created by Zach Graves on 2/26/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>

/**
 * An object containing the response data from API requests.
 */
@interface YOSResponseData : NSObject {
@public
	/**
	 * Returns the NSHTTPURLResponse from the request.
	 */
	NSHTTPURLResponse		*HTTPURLResponse;
	
	/**
	 * Returns the text representation of the response data.
	 */
	NSString				*responseText;
	
	/**
	 * Returns the NSData response from the request.
	 */
	NSData					*data;
	
	/**
	 * Returns the NSError from the request, if any.
	 */
	NSError					*error;
	
	/**
	 * Returns a BOOL representing if the request succeeded or not.
	 */
	BOOL					didSucceed;
}

@property (nonatomic, readwrite, retain) NSHTTPURLResponse *HTTPURLResponse;
@property (nonatomic, readwrite, retain) NSString *responseText;
@property (nonatomic, readwrite, retain) NSData *data;
@property (nonatomic, readwrite, retain) NSError *error;
@property (assign) BOOL didSucceed;

/**
 * Creates a new YOSResponseData object given the response data.
 * @param responseData		The NSData object containing the request response.
 * @param urlResponse		The NSURLResponse object resulting from a request.
 */
+ (YOSResponseData *)responseWithData:(NSData *)responseData andURLResponse:(NSURLResponse *)urlResponse;

@end
