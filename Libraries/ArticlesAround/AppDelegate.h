//
//  AppDelegate.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "AAGeoNamesMediaWikiClient.h"


@interface AppDelegate : NSObject <NSApplicationDelegate, AAClientDelegate> {
	
	@private
	
	AAGeoNamesMediaWikiClient *articlesAroundClient;
}

- (void)run;

@end
