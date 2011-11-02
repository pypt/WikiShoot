//
//  MWAPIRequest.m
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWAPIRequest.h"

#pragma mark - Private methods

@interface MWAPIRequest (Private)

+ (NSString *)URLEncodedStringForString:(NSString *)string;

@end

@implementation MWAPIRequest (Private)

+ (NSString *)URLEncodedStringForString:(NSString *)string {
	
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
															   (CFStringRef)string,
															   NULL,
															   (CFStringRef)@"!*'();:@&=+$,/?%#[] -",
															   kCFStringEncodingUTF8);
}

@end


#pragma mark - Public methods


@implementation MWAPIRequest

@synthesize action;


- (NSUInteger)count {
	return [properties count];
}

- (id)objectForKey:(id)aKey {
	return [properties objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator {
	return [properties keyEnumerator];
}

- (void)setObject:(id)anObject forKey:(id)aKey {
	[properties setObject:anObject
					forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey {
	[properties removeObjectForKey:aKey];
}

- (NSString *)HTTPRequestString {
	
	NSMutableArray *result = [NSMutableArray array];
	NSString *key = NULL;
	NSObject *value = NULL;
	
	for (key in properties) {
		value = [properties objectForKey:key];
		
		// Encode key
		key = [MWAPIRequest URLEncodedStringForString:key];
		
		if ([value isKindOfClass:[NSArray class]]) {
			
			// Make value a string
			value = [(NSArray *)value componentsJoinedByString:@"|"];
		}
		
		// Encode value
		value = [MWAPIRequest URLEncodedStringForString:(NSString *)value];
		
		[result addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
	}
	
	return [result componentsJoinedByString:@"&"];
}

@end
