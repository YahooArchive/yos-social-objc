//
//  YOAuthSignatureMethod_PLAINTEXT.m
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Updated by Michael Ho on 8/20/14.
//  Copyright 2014 Yahoo Inc.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthSignatureMethod_PLAINTEXT.h"

@implementation YOAuthSignatureMethod_PLAINTEXT

#pragma mark Private methods

- (NSString *)name
{
	return @"PLAINTEXT";
}

- (NSString *)buildSignatureWithRequest:(NSString *)signableString andSecrets:(NSString *)secret
{
	return secret;
}

- (BOOL)checkSignature:(NSString *)signature withSignableString:(NSString *)signableString andSecrets:(NSString *)secret
{
	NSString *theGeneratedSignature = [self buildSignatureWithRequest:signableString andSecrets:secret];
    
	return [signature isEqualToString:theGeneratedSignature];
}

@end
