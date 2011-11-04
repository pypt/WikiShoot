//
//  main.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

int main (int argc, const char * argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	// make sure the application singleton has been instantiated
	NSApplication *application = [NSApplication sharedApplication];
	
	// instantiate our application delegate
	AppDelegate *applicationDelegate = [[[AppDelegate alloc] init] autorelease];
	
	// assign our delegate to the NSApplication
	[application setDelegate:applicationDelegate];
	
	// call the run method of our application
	[application run];
	
	[pool drain];
	[pool release];
	return 0;
}
