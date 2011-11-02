//
//  MWClient.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWDefines.h"
#import "MWClientDelegate.h"

// FIXME ar _ yra private, ar laikinieji variables?

@class MWClient;
@class MWAPIRequest;


@interface MWClient : NSObject {
	
	@public
	
	NSString *apiURL;
	id<MWClientDelegate> delegate;
	BOOL isLoggedIn;
	NSTimeInterval timeoutInterval;
	
	@private
	
	// Network operation in progress
	BOOL networkOperationIsInProgress;
	
}

@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) id<MWClientDelegate> delegate;
@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic) NSTimeInterval timeoutInterval;

// Initialize with API URL
- (id)initWithAPIURL:(NSString *)_apiURL;
- (id)initWithAPIURL:(NSString *)_apiURL
			delegate:(id<MWClientDelegate>)_delegate;

// Log in
- (void)loginWithUsername:(NSString *)username
				 password:(NSString *)password;

// Log out
- (void)logout;

// Call API
- (void)callAPIWithRequest:(MWAPIRequest *)query;

// Upload file helper
- (void)uploadFileWithTitle:(NSString *)title
					summary:(NSString *)summary
					   data:(NSData *)data;

- (void)uploadFileWithTitle:(NSString *)title
					summary:(NSString *)summary
				   filePath:(NSString *)filePath;

@end
