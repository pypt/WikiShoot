//
//  MWDefines.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Safele release shorthand
#define MW_RELEASE_SAFELY(__POINTER)	{ [__POINTER release]; __POINTER = nil; }

// Logging
#ifdef DEBUG
#define MWLOG(xx, ...)	NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MWLOG(xx, ...)	((void)0)
#endif

// Warnings
#define MWWARN(...)		NSLog(__VA_ARGS__)

// Errors
#define MWERR(...)		NSLog(__VA_ARGS__)

// Dummy implementation exception
#define MW_DUMMY_IMPL_EXC()	[NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
