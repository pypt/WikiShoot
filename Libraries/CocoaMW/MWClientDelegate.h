//
//  MWClientDelegate.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWDefines.h"

@class MWClient;
@class MWAPIRequest;


#pragma mark - MWClient delegate

@protocol MWClientDelegate

@optional

// Log in
- (void)mwClientDidStartLoggingIn:(MWClient *)client;

- (void)mwClientDidSucceedLoggingIn:(MWClient *)client;

- (void)mwClient:(MWClient *)client
didFailLoggingInWithError:(NSError *)error;

// Log out
- (void)mwClientDidStartLoggingOut:(MWClient *)client;

- (void)mwClientDidSucceedLoggingOut:(MWClient *)client;

- (void)mwClient:(MWClient *)client
didFailLoggingOutWithError:(NSError *)error;

// API call
- (void)mwClient:(MWClient *)client
didStartCallingAPIWithRequest:(MWAPIRequest *)query;

// Big POST requests might want to use an uplink progress report
- (void)mwClient:(MWClient *)client
	   sentBytes:(NSUInteger)bytesSent
	  outOfBytes:(NSUInteger)bytesAvailable
	 withRequest:(MWAPIRequest *)request;

- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)query
		 results:(NSObject *)results;

- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)
		   error:(NSError *)error;

@end
