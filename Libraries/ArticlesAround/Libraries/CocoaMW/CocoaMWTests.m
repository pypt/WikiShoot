//
//  CocoaMWTests.m
//  CocoaMW
//
//  Created by Linas Valiukas on 2011-11-02.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CocoaMWTests.h"

@implementation CocoaMWTests

- (id)init {
	if ((self = [super init])) {
		[self run];
	}
	
	return self;
}

- (void)dealloc {
	MW_RELEASE_SAFELY(client);
	
	[super dealloc];
}

- (void)run {

	// Create client
	client = [[MWClient alloc] initWithApiURL:MW_API_URL
									 delegate:self];
	
	// Log in
	[client loginWithUsername:MW_TEST_USERNAME
					 password:MW_TEST_PASSWORD];
}


#pragma mark - MWClientDelegate

- (void)mwClient:(MWClient *)client
didStartCallingAPIWithRequest:(MWAPIRequest *)request {
	
	MWLOG(@"mwClient: %@ didStartCallingAPIWithRequest: %@", client, request);
}

- (void)mwClient:(MWClient *)client
	   sentBytes:(NSUInteger)bytesSent
	  outOfBytes:(NSUInteger)bytesAvailable
	 withRequest:(MWAPIRequest *)request {
	
	MWLOG(@"mwClient: %@ sentBytes: %d outOfBytes: %d withRequest: %@", client, bytesSent, bytesAvailable, request);
}

- (void)mwClient:(MWClient *)client
   receivedBytes:(NSUInteger)bytesSent
	  outOfBytes:(NSUInteger)bytesAvailable
	 withRequest:(MWAPIRequest *)request {
	
	MWLOG(@"mwClient: %@ receivedBytes: %d outOfBytes: %d withRequest: %@", client, bytesSent, bytesAvailable, request);	
}

- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results {
	
	MWLOG(@"mwClient: %@ didSucceedCallingAPIWithRequest: %@ results: %@", client, request, results);
	
	NSString *token = [MWHelpers logInTokenThatWasRequestedOrNil:results];
	if (token) {
				
		// Re-login with token
		[client loginWithUsername:MW_TEST_USERNAME
						 password:MW_TEST_PASSWORD
						   domain:nil
							token:token];
	}
}

- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error {
	
	MWLOG(@"mwClient: %@ didFailCallingAPIWithRequest: %@ error: %@", client, request, error);
}

@end
