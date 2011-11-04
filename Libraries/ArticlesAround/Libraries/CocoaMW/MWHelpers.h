//
//  MWHelpers.h
//  CocoaMW
//
//  Created by Linas Valiukas on 2011-11-03.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWDefines.h"

@interface MWHelpers : NSObject {
	
}

// Checks if after trying to log in we got 'NeedToken' or 'Success'.
// Returns the token that has to be sent, or nil if we're logged in without token already.
+ (NSString *)logInTokenThatWasRequestedOrNil:(NSDictionary *)data;

@end
