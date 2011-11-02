//
//  MWAPIRequest.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWDefines.h"


@interface MWAPIRequest : NSObject {
	
	@public
	NSString *action;
	
	@private
	NSMutableDictionary *properties;
}

@property (nonatomic, retain) NSString *action;

// NSDictionary-like methods for setting/getting properties
- (NSUInteger)count;
- (id)objectForKey:(id)aKey;
- (NSEnumerator *)keyEnumerator;
- (void)setObject:(id)anObject forKey:(id)aKey;
- (void)removeObjectForKey:(id)aKey;

// Returns a string of key=value&key=value&...&key=value parameters for HTTP request
// Used by MWClient
- (NSString *)HTTPRequestString;

@end
