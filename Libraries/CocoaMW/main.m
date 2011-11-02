//
//  main.m
//  CocoaMW
//
//  Created by Linas Valiukas on 2011-11-02.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MW.h"
#import "CocoaMWTests.h"


int main (int argc, const char * argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// Run the tests
	CocoaMWTests *tests = [[CocoaMWTests alloc] init];
	[tests run];
	MW_RELEASE_SAFELY(tests);
	
	MW_RELEASE_SAFELY(pool);
	return 0;
}
