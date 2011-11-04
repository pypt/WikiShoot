//
//  AppDelegate.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (id)init {
	
	if ((self = [super init])) {
		[self run];
	}
	
	return self;
}

- (void)run {
	
	articlesAroundClient = [[AAClient alloc] init];
	[articlesAroundClient setDelegate:self];
	[articlesAroundClient setMediaWikiApiURL:@"http://en.wikipedia.org/w/api.php"];
	[articlesAroundClient setGeoNamesUsername:@"wikishoot"];
	
	AAClientRequest *request = [AAClientRequest requestWithLatitude:47
														  longitude:9
															maxRows:50
															 radius:20
													   languageCode:@"en"];
	
	[articlesAroundClient searchForNearbyArticlesForRequest:request];
	
}

@end
