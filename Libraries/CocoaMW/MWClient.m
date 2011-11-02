//
//  MWClient.m
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWClient.h"
#import "MWAPIRequest.h"


@implementation MWClient

@synthesize apiURL;
@synthesize delegate;
@synthesize isLoggedIn;
@synthesize timeoutInterval;


- (id)init {
	
	if ((self = [super init])) {
		apiURL = NULL;
		delegate = NULL;
		networkOperationIsInProgress = NO;
		isLoggedIn = NO;
		timeoutInterval = 30.0;
	}
	
	return self;
}

- (id)initWithAPIURL:(NSString *)_apiURL {
	
	return [self initWithAPIURL:_apiURL
					   delegate:NULL];
}

- (id)initWithAPIURL:(NSString *)_apiURL
			delegate:(id<MWClientDelegate>)_delegate {
	
	if ((self = [self init])) {
		[self setApiURL:_apiURL];
		[self setDelegate:_delegate];
	}
	
	return self;
}

- (void)setApiURL:(NSString *)_apiURL {
	if (! [apiURL isEqualToString:_apiURL]) {
		if (apiURL) {
			[self logout];
			[apiURL release];
		}
		apiURL = [_apiURL retain];
	}
}

- (void)uploadFileWithTitle:(NSString *)title
					summary:(NSString *)summary
				   filePath:(NSString *)filePath {
	
	[self uploadFileWithTitle:title
					  summary:summary
						 data:[NSData dataWithContentsOfFile:filePath]];
}


@end
