//
//  AppDelegate.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "AAClient.h"


@interface AppDelegate : NSObject <NSApplicationDelegate, AAClientDelegate> {
	
	@private
	
	AAClient *articlesAroundClient;
}

- (void)run;

@end
