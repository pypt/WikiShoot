//
//  AAGeoNamesMediaWikiClient.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAAbstractClient.h"
#import "MWClientDelegate.h"
#import "ILGeoNamesLookup.h"

@class MWClient;
@class ILGeoNamesLookup;

@interface AAGeoNamesMediaWikiClient : AAAbstractClient <MWClientDelegate, ILGeoNamesLookupDelegate> {
	
	@private
		
	// MediaWiki client
	MWClient *mwClient;
	
	// GeoNames client
	ILGeoNamesLookup *geocoder;
	
	// Currently processed request
	AAClientRequest *currentRequest;
	
	// Current temporary results (array of AAClientArticle objects to be refined later)
	NSMutableArray *currentResultArticles;
	
}

- (void)setMediaWikiApiURL:(NSString *)mediaWikiApiURL;
- (void)setGeoNamesUsername:(NSString *)geoNamesUsername;

// Initializer
- (id)initWithDelegate:(id<AAClientDelegate>)initDelegate
	   mediaWikiApiURL:(NSString *)mediaWikiApiURL
	  geoNamesUsername:(NSString *)geoNamesUsername;

@end
