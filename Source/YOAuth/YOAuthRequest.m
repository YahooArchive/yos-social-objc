//
//  YOAuthRequest.m
//  YOAuth
//
//  Created by Zach Graves on 2/14/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import "YOAuthRequest.h"

#import "NSString+URLEncoding.h"
#import "YOAuthUtil.h"
#import "YOAuthSignatureMethod_HMAC-SHA1.h"
#import "YOAuthSignatureMethod_PLAINTEXT.h"
#import "YOAuthConsumer.h"
#import "YOAuthToken.h"
#import "YOAuthSignatureMethod.h"

#pragma mark private methods interface

/**
 * Contains the private properties and methods of YOAuthRequest.
 * @private
 */
@interface YOAuthRequest (Private)
/**
 * Returns a url-encoded signable string containing the HTTP method, 
 * absolute URL string and signable request parameters.
 * @return			A string containing the url-encoded request string, joined by an ampersand (&).
 */
- (NSString *)signableString;

/**
 * Returns a signable string containing the OAuth consumer key and OAuth token key, 
 * if present.
 * @return 			A string containing the signable secrets joined by an ampersand (&).
 */
- (NSString *)signableSecrets;

/**
 * Returns a string of url-encoded signable parameters as key=value pairs.
 * @return 			A string containing the url-encoded signable parameters, joined by an ampersand (&). 
 */
- (NSString *)signableParameters;

/**
 * Builds the <code>oauth_signature</code> parameter using the specified signature method.
 * @return			A string containing the signature.
 */
- (NSString *)buildSignature;
@end

#pragma mark private methods implementation

@implementation YOAuthRequest (Private)

- (NSString *)signableString
{
	NSMutableArray *signableObjects = [[NSMutableArray alloc] init];
	
	[signableObjects addObject:[HTTPMethod URLEncodedString] ];
	[signableObjects addObject:[[url absoluteString] URLEncodedString]];
	[signableObjects addObject:[[self signableParameters] URLEncodedString]];
	
	NSString *theSignableString = [signableObjects componentsJoinedByString:@"&"];
	
	return theSignableString;
}

- (NSString *)signableSecrets
{
	NSString *theTokenSecret = (token != nil) ? token.secret : @"";
	
	NSMutableArray *secrets = [[NSMutableArray alloc] init];
	[secrets addObject:consumer.secret];
	[secrets addObject:theTokenSecret];
	
	NSString *theSignableSecrets = [secrets componentsJoinedByString:@"&"];
	
	return theSignableSecrets;
}

- (NSString *)signableParameters
{
	NSMutableDictionary *requestDictionary = [self allRequestParametersAsDictionary];
	NSMutableArray *queryParameters = [[NSMutableArray alloc] init];
	
	if([requestDictionary valueForKey:@"oauth_signature"]) {
		[requestDictionary removeObjectForKey:@"oauth_signature"];
	}
	
	for (NSString *key in [requestDictionary allKeys]) {
		NSString *value = [requestDictionary objectForKey:key];
		NSString *keyValuePair = [NSString stringWithFormat:@"%@=\%@", [key URLEncodedString], [value URLEncodedString]];
		[queryParameters addObject:keyValuePair];
	}
	
	NSMutableArray *sortedQueryParams = (NSMutableArray*)[queryParameters sortedArrayUsingSelector:@selector(compare:)];
	
	
	NSString *keyValuePairs = [sortedQueryParams componentsJoinedByString:@"&"];
	return keyValuePairs;
}

- (NSString *)buildSignature
{
	NSString *theSignableString = [self signableString];
	NSString *theSignableSecrets = [self signableSecrets];
	
	NSString *theSignature = [signatureMethod buildSignatureWithRequest:theSignableString andSecrets:theSignableSecrets];
	return theSignature;
}

@end

#pragma mark regular implementation
@implementation YOAuthRequest

@synthesize consumer;
@synthesize token;
@synthesize realm;
@synthesize HTTPMethod;
@synthesize url;
@synthesize requestParams;
@synthesize oauthParams;

@synthesize oauthNonce;
@synthesize oauthSignature;
@synthesize oauthTimestamp;
@synthesize oauthVersion;


- (id)initWithConsumer:(YOAuthConsumer *)aConsumer 
				andUrl:(NSURL *)aUrl 
		 andHTTPMethod:(NSString *)aHTTPMethod 
	andSignatureMethod:(NSString *)aMethod
{
	if(self = [self init])
	{
		[self setConsumer:aConsumer];
		[self setUrl:aUrl];
		[self setHTTPMethod:aHTTPMethod];
		
		if(aMethod == nil || [aMethod isEqualToString:@"HMAC-SHA1"]) {
			signatureMethod = [[YOAuthSignatureMethod_HMAC_SHA1 alloc] init];
		}else if([aMethod isEqualToString:@"PLAINTEXT"]){
			signatureMethod = [[YOAuthSignatureMethod_PLAINTEXT alloc] init];
		}else{
			NSLog(@"Signature Method: \"%@\" not supported.", aMethod);
		}
	}
	return self;
}

- (id)initWithConsumer:(YOAuthConsumer *)aConsumer 
				andUrl:(NSURL *)aUrl 
		 andHTTPMethod:(NSString *)aHTTPMethod 
			  andToken:(YOAuthToken *)aToken 
	andSignatureMethod:(NSString *)aMethod
{
	if(self = [self initWithConsumer:aConsumer andUrl:aUrl andHTTPMethod:aHTTPMethod andSignatureMethod:aMethod])
	{
		[self setToken:aToken];
	}
	return self;
}

- (void)prepareRequest
{
	// store these for easy retrieval later
	[self setOauthTimestamp:[YOAuthUtil oauth_timestamp]];
	[self setOauthNonce:[YOAuthUtil oauth_nonce]];
	[self setOauthVersion:[YOAuthUtil oauth_version]];
	
	oauthParams = [[NSMutableDictionary alloc] init];
	[oauthParams setObject:self.oauthNonce forKey:@"oauth_nonce"];
	[oauthParams setObject:self.oauthTimestamp forKey:@"oauth_timestamp"];
	[oauthParams setObject:self.oauthVersion forKey:@"oauth_version"];
	[oauthParams setObject:self.consumer.key forKey:@"oauth_consumer_key"];
	[oauthParams setObject:[signatureMethod name] forKey:@"oauth_signature_method"];
	
	if(token && ![[token key] isEqualToString:@""]) {
		[oauthParams setObject:self.token.key forKey:@"oauth_token"];
	}
	
	[self setOauthSignature:[self buildSignature]];
	[oauthParams setObject:oauthSignature forKey:@"oauth_signature"];
}

- (NSMutableDictionary *)allRequestParametersAsDictionary
{
	NSMutableDictionary *parameterDictionary = [[NSMutableDictionary alloc] init];
	[parameterDictionary addEntriesFromDictionary:oauthParams];
	if(requestParams && [requestParams count]) [parameterDictionary addEntriesFromDictionary:requestParams];
	
	return parameterDictionary;
}

- (NSMutableDictionary *)allNonOAuthRequestParametersAsDictionary
{
	NSMutableDictionary *parameterDictionary = [[NSMutableDictionary alloc] init];
	if(requestParams && [requestParams count]) [parameterDictionary addEntriesFromDictionary:requestParams];
	
	return parameterDictionary;
}

- (NSMutableDictionary *)allOAuthRequestParametersAsDictionary
{
	NSMutableDictionary *parameterDictionary = [[NSMutableDictionary alloc] init];
	[parameterDictionary addEntriesFromDictionary:self.oauthParams];
	
	return parameterDictionary;
}

- (NSString *)buildAuthorizationHeaderValue
{
	NSMutableArray *authorizationHeaderParts = [[NSMutableArray alloc] init];
	
	if(realm && ![realm isEqualToString:@""]) {
		[authorizationHeaderParts addObject:[NSString stringWithFormat:@"realm=\"%@\"", [realm URLEncodedString]]];
	}
	
	[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_consumer_key=\"%@\"", [self.consumer.key URLEncodedString]]];
	[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_signature_method=\"%@\"", [[signatureMethod name] URLEncodedString]]];
	[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_signature=\"%@\"", [self.oauthSignature URLEncodedString]]];
	[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_timestamp=\"%@\"", [self.oauthTimestamp URLEncodedString]]];
	[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_nonce=\"%@\"", [self.oauthNonce URLEncodedString]]];
	[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_version=\"%@\"", [self.oauthVersion URLEncodedString]]];
	
	if(token && ![token.key isEqualToString:@""]){
		[authorizationHeaderParts addObject:[NSString stringWithFormat:@"oauth_token=\"%@\"", [self.token.key URLEncodedString]]];
	}
	
	NSString *authorizationHeaderValue = [NSString stringWithFormat:@"OAuth %@", [authorizationHeaderParts componentsJoinedByString:@","]];
	
	
	return authorizationHeaderValue;
}

@end
