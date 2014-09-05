//
//  YOSResponseData.m
//  YOSSocial
//
//  Created by Zach Graves on 2/26/09.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSResponseData.h"

@implementation YOSResponseData

+ (YOSResponseData *)responseWithData:(NSData *)responseData andURLResponse:(NSURLResponse *)urlResponse
{
	NSString *responseText = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSInteger httpStatusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
	
	YOSResponseData *serviceResponseData = [[YOSResponseData alloc] init];
    
    serviceResponseData.HTTPURLResponse = (NSHTTPURLResponse *)urlResponse;
    serviceResponseData.responseText = responseText;
    serviceResponseData.data = responseData;
    serviceResponseData.didSucceed = (httpStatusCode < 400);

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [responseText dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    serviceResponseData.responseJSONDict = json ? json : nil;
    
	return serviceResponseData;
}

@end
