//
//  AAGeoNamesMediaWikiClient.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAGeoNamesMediaWikiClient.h"
#import "MW.h"
#import "JSONKit.h"


#pragma mark - Private methods

@interface AAGeoNamesMediaWikiClient (Private)

- (void)informDelegateAboutFailedSearcherWithErrorCode:(AAClientError)errorCode
											  userInfo:(NSDictionary *)userInfo;
- (void)informDelegateAboutSuccessfulSearcherWithArticles:(NSArray *)articles;

- (void)refineNearbyArticlesUsingMediaWiki;

// GeoNames (1st stage)
- (void)geoNamesLookup:(ILGeoNamesLookup *)handler
	  didFailWithError:(NSError *)error;
- (void)geoNamesLookup:(ILGeoNamesLookup *)handler
	   didFindGeoNames:(NSArray *)geoNames
			totalFound:(NSUInteger)total;

// MediaWiki (2nd stage)
- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results;
- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error;

@end

@implementation AAGeoNamesMediaWikiClient (Private)

- (void)informDelegateAboutFailedSearcherWithErrorCode:(AAClientError)errorCode
											  userInfo:(NSDictionary *)userInfo {
	
	if (delegate && [delegate respondsToSelector:@selector(aaClient:failedSearchingForNearbyArticlesForRequest:error:)]) {
		
		[delegate aaClient:self
failedSearchingForNearbyArticlesForRequest:currentRequest
					 error:[NSError errorWithDomain:kAAClientErrorDomain
											   code:errorCode
										   userInfo:userInfo]];
	}
	
}

- (void)informDelegateAboutSuccessfulSearcherWithArticles:(NSArray *)articles {
	
	if (delegate && [delegate respondsToSelector:@selector(aaClient:succeededSearchingForNearbyArticlesForRequest:articles:)]) {
		
		[delegate aaClient:self
succeededSearchingForNearbyArticlesForRequest:currentRequest
				  articles:articles];
	}
	
}

- (void)refineNearbyArticlesUsingMediaWiki {
	
	//
	// The article list fetched from GeoNames is currently stored in currentResultArticles
	//
	
	// Inform delegate
	if (delegate && [delegate respondsToSelector:@selector(aaClient:startedRefiningNearbyArticlesForRequest:)]) {
		
		[delegate aaClient:self
startedRefiningNearbyArticlesForRequest:currentRequest];
	}
	
	//for (AAClientArticle *article in articles) {
	//	MWLOG(@"%@", article);
	//}
	
	// Stop now if there are no articles to "refine"
	if ([currentResultArticles count] == 0) {
		[self informDelegateAboutSuccessfulSearcherWithArticles:[NSArray array]];
		MW_RELEASE_SAFELY(currentRequest);
		MW_RELEASE_SAFELY(currentResultArticles);
		return;
	}
	
	
	// Collect titles
	NSMutableArray *articleTitles = [NSMutableArray array];
	for (AAClientArticle *article in currentResultArticles) {
		if ([[article title] length] != 0) {
			[articleTitles addObject:[article title]];
		}
	}
	
	// Fetch articles with images
	MWAPIRequest *request = [MWAPIRequest requestWithAction:@"query"];
	[request setParameter:articleTitles forKey:@"titles"];
	[request setParameter:[NSArray arrayWithObjects:@"images", @"revisions", nil] forKey:@"prop"];
	[request setParameter:@"true" forKey:@"redirects"];
	[request setParameter:@"max" forKey:@"imlimit"];
	[request setParameter:@"content" forKey:@"rvprop"];
	
	[mwClient callAPIWithRequest:request];
}


#pragma mark ILGeoNamesLookupDelegate methods

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler
	  didFailWithError:(NSError *)error {
	
	MWLOG(@"GN didFailWithError: %@", error);
	
	[self informDelegateAboutFailedSearcherWithErrorCode:kAAClientGeoNamesRequestError
												userInfo:[error userInfo]];
	MW_RELEASE_SAFELY(currentRequest);
}

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler
	   didFindGeoNames:(NSArray *)geoNames
			totalFound:(NSUInteger)total {
	
	//MWLOG(@"GN didFindGeoNames: totalFound: %d", geoNames, total);
	
	MW_RELEASE_SAFELY(currentResultArticles);
	currentResultArticles = [[NSMutableArray alloc] init];
	
	NSString *title;
	NSString *type;
	NSString *wikipediaURL;
	double distance;
	double latitude;
	double longitude;
	NSString *language;
	NSString *countryCode;
	NSString *summary;
	
	// Move results to an array of AAClientArticle objects
	
	for (NSDictionary /* actually, it's JKDictionary */ *geoName in geoNames) {
		
		title = [geoName objectForKey:@"title"];
		type = [geoName objectForKey:@"feature"];
		wikipediaURL = [geoName objectForKey:@"wikipediaUrl"];
		distance = [[geoName objectForKey:@"distance"] doubleValue];
		latitude = [[geoName objectForKey:@"lat"] doubleValue];
		longitude = [[geoName objectForKey:@"lng"] doubleValue];
		language = [geoName objectForKey:@"lang"];
		countryCode = [geoName objectForKey:@"countryCode"];
		summary = [geoName objectForKey:@"summary"];
		
		if (wikipediaURL && [wikipediaURL length] != 0) {
			if (! ([wikipediaURL hasPrefix:@"http://"] && [wikipediaURL hasPrefix:@"https://"])) {
				wikipediaURL = [@"http://" stringByAppendingString:wikipediaURL];
			}
		}
		
		if ([title length] != 0) {
			[currentResultArticles addObject:[AAClientArticle articleWithTitle:title
																		  type:type
																  wikipediaURL:wikipediaURL
																	  distance:distance
																	  latitude:latitude
																	 longitude:longitude
																	  language:language
																   countryCode:countryCode
																	   summary:summary]];
		}
	}
	
	// Start 'refining' results via MediaWiki API
	[self refineNearbyArticlesUsingMediaWiki];
}

- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results {
	
	//MWLOG(@"mwClient: %@ didSucceedCallingAPIWithRequest: %@ results: %@", client, request, results);
	
	NSArray *articleTitlesThatDoNotHaveImages = [MWHelpers articleTitlesOfArticlesThatDoNotHaveImages:results];
	if (articleTitlesThatDoNotHaveImages == nil) {
		[self informDelegateAboutFailedSearcherWithErrorCode:kAAClientMediaWikiAPIResponseError
													userInfo:nil];
		MW_RELEASE_SAFELY(currentResultArticles);
		MW_RELEASE_SAFELY(currentRequest);
		return;
	}
	
	if ([articleTitlesThatDoNotHaveImages count] > 0) {
		// Remove articles that do not actually have *their own* images
		NSMutableArray *articlesToRemove = [NSMutableArray array];
		for (AAClientArticle *article in currentResultArticles) {
			if (! [articleTitlesThatDoNotHaveImages containsObject:[article title]]) {
				[articlesToRemove addObject:article];
			}
		}
		[currentResultArticles removeObjectsInArray:articlesToRemove];
	} else {
		[currentResultArticles removeAllObjects];
	}
	
	// Call delegate with final results
	if (delegate && [delegate respondsToSelector:@selector(aaClient:succeededSearchingForNearbyArticlesForRequest:articles:)]) {
		
		[delegate aaClient:self
succeededSearchingForNearbyArticlesForRequest:[currentRequest autorelease]
				  articles:[NSArray arrayWithArray:currentResultArticles]];
	}
	
	MW_RELEASE_SAFELY(currentRequest);
	MW_RELEASE_SAFELY(currentResultArticles);
}

- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error {
	
	MWLOG(@"mwClient: %@ didFailCallingAPIWithRequest: %@ error: %@", client, request, error);
	
	[self informDelegateAboutFailedSearcherWithErrorCode:kAAClientMediaWikiAPINetworkError
												userInfo:[error userInfo]];
	MW_RELEASE_SAFELY(currentRequest);
	MW_RELEASE_SAFELY(currentResultArticles);
}

@end



#pragma mark - Public methods

@implementation AAGeoNamesMediaWikiClient

- (id)init {
	
	if ((self = [super init])) {
		currentRequest = nil;
		currentResultArticles = nil;
		
		mwClient = [[MWClient alloc] initWithApiURL:nil
										   delegate:self];
		geocoder = [[ILGeoNamesLookup alloc] init];
		[geocoder setDelegate:self];
	}
	
	return self;
}

- (id)initWithDelegate:(id<AAClientDelegate>)initDelegate
	   mediaWikiApiURL:(NSString *)mediaWikiApiURL
	  geoNamesUsername:(NSString *)geoNamesUsername {	
	
	if ((self = [self init])) {
		[self setMediaWikiApiURL:mediaWikiApiURL];
		[self setGeoNamesUsername:geoNamesUsername];
	}
	
	return self;
}

- (void)dealloc {
	
	[mwClient cancelOngoingAPIRequest];	// if any
	[geocoder cancel];	// if any
	
	MW_RELEASE_SAFELY(mwClient);
	MW_RELEASE_SAFELY(geocoder);
	MW_RELEASE_SAFELY(currentRequest);
	MW_RELEASE_SAFELY(currentResultArticles);
	
	[super dealloc];
}

- (void)setMediaWikiApiURL:(NSString *)mediaWikiApiURL {
	[mwClient setApiURL:mediaWikiApiURL];
}

- (void)setGeoNamesUsername:(NSString *)geoNamesUsername {
	[geocoder setUserID:geoNamesUsername];
}

- (void)searchForNearbyArticlesForRequest:(AAClientRequest *)request {
	
	// Inform delegate
	if (delegate && [delegate respondsToSelector:@selector(aaClient:startedSearchingForNearbyArticlesForRequest:)]) {
		
		[delegate aaClient:self
startedSearchingForNearbyArticlesForRequest:request];
		
	}
	
	// Check parameters
	if (! request) {
		MWERR(@"Request is nil, aborting");		
		[self informDelegateAboutFailedSearcherWithErrorCode:kAAClientEmptyRequestError
													userInfo:nil];
		return;
	}
	
	currentRequest = [request retain];
	
	if (! [mwClient apiURL]) {
		MWERR(@"MediaWiki API URL was not set, aborting");
		[self informDelegateAboutFailedSearcherWithErrorCode:kAAClientEmptyMediaWikiApiURLError
													userInfo:nil];		
		return;
	}
	
	if (! [geocoder userID]) {
		MWERR(@"GeoNames user ID was not set, aborting");
		[self informDelegateAboutFailedSearcherWithErrorCode:kAAClientEmptyGeoNamesUsernameError
													userInfo:nil];		
		return;
	}
	
	[geocoder findNearbyWikipediaForLatitude:request.latitude
								   longitude:request.longitude
									 maxRows:request.maxRows
									  radius:request.radius
								languageCode:request.languageCode];
}

@end
