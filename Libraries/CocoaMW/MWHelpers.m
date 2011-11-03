//
//  MWHelpers.m
//  CocoaMW
//
//  Created by Linas Valiukas on 2011-11-03.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWHelpers.h"

@implementation MWHelpers

+ (NSString *)logInTokenThatWasRequestedOrNil:(NSDictionary *)data {
	
	// Logging in?
	if ([data objectForKey:@"login"]) {
		
		// Token requested?
		if ([[[data objectForKey:@"login"] objectForKey:@"result"] isEqualToString:@"NeedToken"]) {
			
			return [[data objectForKey:@"login"] objectForKey:@"token"];
			
		}
	}

	return nil;
}

@end
