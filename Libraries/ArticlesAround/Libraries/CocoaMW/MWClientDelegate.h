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

// API call
- (void)mwClient:(MWClient *)client
didStartCallingAPIWithRequest:(MWAPIRequest *)request;

// Big POST requests might want to use an uplink progress report
- (void)mwClient:(MWClient *)client
	   sentBytes:(NSUInteger)bytesSent
	  outOfBytes:(NSUInteger)bytesAvailable
	 withRequest:(MWAPIRequest *)request;

// Big POST requests might want to use an uplink progress report
- (void)mwClient:(MWClient *)client
   receivedBytes:(NSUInteger)bytesSent
	  outOfBytes:(NSUInteger)bytesAvailable
	 withRequest:(MWAPIRequest *)request;

- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results;

- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error;

@end
