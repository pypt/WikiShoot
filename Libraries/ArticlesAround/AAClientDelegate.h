//
//  AAClientDelegate.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class AAAbstractClient;
@class AAClientRequest;


#pragma mark Delegate protocol for status and results retrieval

@protocol AAClientDelegate

@optional

// Started searching (GeoNames request sent, waiting for reply; MediaWiki's not yet been touched)
- (void)aaClient:(AAAbstractClient *)aaClient
startedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request;

// Finished requesting GeoNames, moving on to MediaWiki's stage to find out which articles don't have pics (or some other metadata)
- (void)aaClient:(AAAbstractClient *)aaClient
startedRefiningNearbyArticlesForRequest:(AAClientRequest *)request;

// Successfully finished searching for nearby articles (GeoNames' and MediaWiki's stages are both done)
- (void)aaClient:(AAAbstractClient *)aaClient
succeededSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		articles:(NSArray *)articles /* array of AAClientArticle items */;

// Failed searching for nearby articles (at the GeoNames stage, or at the MediaWiki's stage)
- (void)aaClient:(AAAbstractClient *)aaClient
failedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		   error:(NSError *)error;

@end
