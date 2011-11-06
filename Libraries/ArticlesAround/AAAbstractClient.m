//
//  AAClient.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAAbstractClient.h"
#import "MWDefines.h"


NSString *const kAAClientErrorDomain = @"lt.pypt.aaclient";


#pragma mark - AAClient private methods

@interface AAAbstractClient (Private)

@end

@implementation AAAbstractClient (Private)


@end


#pragma mark - AAClient public methods


@implementation AAAbstractClient

@synthesize delegate;


- (id)init {
	
	if ((self = [super init])) {
		delegate = nil;
	}
	
	return self;
}

- (id)initWithDelegate:(id<AAClientDelegate>)initDelegate {
	
	if ((self = [self init])) {
		delegate = initDelegate;
	}
	
	return self;
}

- (void)searchForNearbyArticlesForRequest:(AAClientRequest *)request {
	// Do not use directly
	MW_DUMMY_IMPL_EXC();
}

@end
