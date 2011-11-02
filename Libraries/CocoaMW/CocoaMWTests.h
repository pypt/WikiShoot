//
//  CocoaMWTests.h
//  CocoaMW
//
//  Created by Linas Valiukas on 2011-11-02.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MW.h"

// MediaWiki API URL
#define MW_URL	@"http://wikishoot.localdomain/api.php"


@interface CocoaMWTests : NSObject <MWClientDelegate> {
	
	@private
	MWClient *client;
	
}

- (void)run;

@end
