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
		client = [[MWClient alloc] initWithAPIURL:MW_URL
										 delegate:self];
	}
	
	return self;
}

- (void)dealloc {
	MW_RELEASE_SAFELY(client);
	
	[super dealloc];
}

- (void)run {
	
	
}

@end
