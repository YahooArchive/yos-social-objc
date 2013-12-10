//
//  NSDictionary+QueryString.m
//  YOAuth
//
//  Created by Zach Graves on 3/4/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "NSDictionary+QueryString.h"
#import "NSString+URLEncoding.h"

@implementation NSDictionary (QueryStringAdditions)

+ (instancetype)dictionaryFromQueryString:(NSString *)queryString
{
    return [[NSDictionary alloc] initWithQueryString:queryString];
}

- (id)initWithQueryString:(NSString *)queryString
{
    NSArray *components = [queryString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSString *component in components)
    {
        NSArray *keyValue = [component componentsSeparatedByString:@"="];
        dictionary[[keyValue[0] URLDecodedString]] = [keyValue[1] URLDecodedString];
    }
    return dictionary;
}

- (NSString *)QueryString 
{
    NSMutableArray *queryParameters = [[NSMutableArray alloc] init];
	
	for (NSString *aKey in [self allKeys]) {
		NSString *keyValuePair = [NSString stringWithFormat:@"%@=%@", aKey, [self[aKey] URLEncodedString]];
		[queryParameters addObject:keyValuePair];
	}
	
	NSString *queryString = [queryParameters componentsJoinedByString:@"&"];
	
	return queryString;
}

@end