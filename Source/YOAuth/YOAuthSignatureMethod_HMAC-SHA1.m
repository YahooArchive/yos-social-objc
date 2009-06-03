//
//  YOAuthSignatureMethod_HMAC-SHA1.m
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthSignatureMethod_HMAC-SHA1.h"

#include "hmac.h"
#include "Base64Transcoder.h"

static NSString *const kSignatureMethodName = @"HMAC-SHA1";

@implementation YOAuthSignatureMethod_HMAC_SHA1

#pragma mark Public

- (NSString *)name
{
	return [kSignatureMethodName autorelease];
}

- (NSString *)buildSignatureWithRequest:(NSString *)aSignableString andSecrets:(NSString *)aSecret
{
	NSData *secretData = [aSecret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [aSignableString dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length], (unsigned char *)[secretData bytes], [secretData length], result);
    
    //Base64 Encoding
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    NSString *base64EncodedResult = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
    
    return [base64EncodedResult autorelease];
}

- (BOOL)checkSignature:(NSString *)aSignature withSignableString:(NSString *)aSignableString andSecrets:(NSString *)aSecret
{
	NSString *theGeneratedSignature = [self buildSignatureWithRequest:aSignableString andSecrets:aSecret];
	return [aSignature isEqualToString:theGeneratedSignature];
}

@end
