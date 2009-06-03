//
//  YOSResponseData.m
//  YOSSocial
//
//  Created by Zach Graves on 2/26/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOSResponseData.h"


@implementation YOSResponseData

@synthesize HTTPURLResponse;
@synthesize responseText;
@synthesize data;
@synthesize error;
@synthesize didSucceed;

+ (YOSResponseData *)responseWithData:(NSData *)responseData andURLResponse:(NSURLResponse *)urlResponse
{
	NSStringEncoding responseEncoding = NSUTF8StringEncoding;
	
	if([urlResponse textEncodingName]) {
		NSString *textEncodingName = [urlResponse textEncodingName];
		responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)textEncodingName));
	}
	
	NSString *responseText = [[[NSString alloc] initWithData:responseData encoding:responseEncoding] autorelease];
	NSInteger httpStatusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
	
	YOSResponseData *serviceResponseData = [[YOSResponseData alloc] init];
	[serviceResponseData setHTTPURLResponse:(NSHTTPURLResponse *)urlResponse];
	[serviceResponseData setResponseText:responseText];
	[serviceResponseData setData:responseData];
	[serviceResponseData setDidSucceed:(httpStatusCode < 400)];
	
	return [serviceResponseData autorelease];
}

@end
