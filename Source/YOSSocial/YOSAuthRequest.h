//
//  YOSAuthRequest.h
//  YOSSocial
//
//  Created by Zach Graves on 2/11/09.
//  Copyright (c) 2009 Yahoo! Inc. All rights reserved.
//  
//  The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license.
//

#import <Foundation/Foundation.h>
#import "YOSBaseRequest.h"

@class YOSRequestToken;
@class YOSAccessToken;

/**
 * YOSAuthRequest is a sub-class of YOSBaseRequest that provides access to the OAuth service to generate request and access tokens.
 */
@interface YOSAuthRequest : YOSBaseRequest {
@public
	/**
	 * An optional OAuth language preference.
	 * <p>Set to nil if your service provider does not not accept this argument. (xoauth_lang_pref, OAuth 1.1)</p>
	 * @see http://oauth.googlecode.com/svn/spec/ext/language_preference/1.0/drafts/1/spec.html#parameter
	 */
	NSString		*oAuthLang;
}

@property (nonatomic, readwrite, retain) NSString *oAuthLang;

/**
 * Sends a request to fetch a request token.
 * @return							A request token.
 * @param callbackUrl				A callback URL.
 * @see YOSRequestToken
 */
- (YOSRequestToken *)fetchRequestTokenWithCallbackUrl:(NSString *)callbackUrl;

/**
 * Returns a URL to <code>request_auth</code> containing a request token key and optional callback URL.
 * @param	requestToken			A Request Token.
 * @return							A URL to redirect the user for authorization.
 */
- (NSURL *)authUrlForRequestToken:(YOSRequestToken *)requestToken;

/**
 * Sends a request to fetch an access token.
 * @param requestOrAccessToken		An authorized request token or expired access token to renew.
 * @param verifier					The oauth_verifier key returned to the application.
 * @return							An access token.
 * @see YOSAccessToken
 */
- (YOSAccessToken *)fetchAccessToken:(YOAuthToken *)requestOrAccessToken withVerifier:(NSString *)verifier;

@end