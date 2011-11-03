//
//  CocoaMWTests.h
//  CocoaMW
//
//  Created by Linas Valiukas on 2011-11-02.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MW.h"

// MediaWiki API URL
#define MW_API_URL	@"http://wikishoot.localdomain/api.php"

// MediaWiki test username
#define MW_TEST_USERNAME	@"testuser"

// MediaWiki test password
#define MW_TEST_PASSWORD	@"testpassword"


@interface CocoaMWTests : NSObject <NSApplicationDelegate, MWClientDelegate> {
	
	@private
	MWClient *client;
	
}

- (void)run;

// MWClientDelegate

- (void)mwClient:(MWClient *)client
didStartCallingAPIWithRequest:(MWAPIRequest *)request;

- (void)mwClient:(MWClient *)client
	   sentBytes:(NSUInteger)bytesSent
	  outOfBytes:(NSUInteger)bytesAvailable
	 withRequest:(MWAPIRequest *)request;

- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results;

- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error;

@end
