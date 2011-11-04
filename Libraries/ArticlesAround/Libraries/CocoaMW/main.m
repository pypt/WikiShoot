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
	
	// make sure the application singleton has been instantiated
	NSApplication *application = [NSApplication sharedApplication];
	
	// instantiate our application delegate
	CocoaMWTests *applicationDelegate = [[[CocoaMWTests alloc] init] autorelease];
	
	// assign our delegate to the NSApplication
	[application setDelegate:applicationDelegate];
	
	// call the run method of our application
	[application run];
	
	[pool drain];
	MW_RELEASE_SAFELY(pool);
	return 0;
}
