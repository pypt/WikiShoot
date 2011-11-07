//
// Copyright 2011 Linas Valiukas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
