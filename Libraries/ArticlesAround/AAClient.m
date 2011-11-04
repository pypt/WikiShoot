//
//  AAClient.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAClient.h"
#import "MW.h"
#import "JSONKit.h"


NSString *const kAAClientErrorDomain = @"lt.pypt.aaclient";


@implementation AAClientRequest

@synthesize latitude;
@synthesize longitude;
@synthesize maxRows;
@synthesize radius;
@synthesize languageCode;


- (id)init {
	
	if ((self = [super init])) {
		latitude = 0;
		longitude = 0;
		maxRows = 0;
		radius = 0;
		languageCode = nil;
	}
	
	return self;
}

+ (AAClientRequest *)requestWithLatitude:(double)latitude
							   longitude:(double)longitude
								 maxRows:(unsigned short)maxRows
								  radius:(double)radius
							languageCode:(NSString *)languageCode {
	
	AAClientRequest *request = [[[AAClientRequest alloc] init] autorelease];
	[request setLatitude:latitude];
	[request setLongitude:longitude];
	[request setMaxRows:maxRows];
	[request setRadius:radius];
	[request setLanguageCode:languageCode];
	
	return request;
}

@end



#pragma mark - AAClient private methods

@interface AAClient (Private)

- (void)informDelegateAboutFailedSearcherWithErrorCode:(AAClientError)errorCode
											  userInfo:(NSDictionary *)userInfo;
- (void)informDelegateAboutSuccessfulSearcherWithArticles:(NSArray *)articles;

- (void)refineNearbyArticlesUsingMediaWikiWithArticles:(NSArray *)articles;

// GeoNames
- (void)geoNamesLookup:(ILGeoNamesLookup *)handler
	  didFailWithError:(NSError *)error;
- (void)geoNamesLookup:(ILGeoNamesLookup *)handler
	   didFindGeoNames:(NSArray *)geoNames
			totalFound:(NSUInteger)total;

// MediaWiki
- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results;
- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error;

@end

@implementation AAClient (Private)

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

- (void)refineNearbyArticlesUsingMediaWikiWithArticles:(NSArray *)articles {
	
	// Inform delegate
	if (delegate && [delegate respondsToSelector:@selector(aaClient:startedRefiningNearbyArticlesForRequest:)]) {
		
		[delegate aaClient:self
startedRefiningNearbyArticlesForRequest:currentRequest];
	}
	
	//for (AAClientArticle *article in articles) {
	//	MWLOG(@"%@", article);
	//}
	
	// Stop now if there are no articles to "refine"
	if ([articles count] == 0) {
		[self informDelegateAboutSuccessfulSearcherWithArticles:[NSArray array]];
		MW_RELEASE_SAFELY(currentRequest);
		return;
	}
	
	
	//
	// Normally, we could fetch lists of articles' images using the following API query:
	//
	//  http://en.wikipedia.org/w/api.php?action=query&titles=A|B|C&prop=images&redirects&imlimit=max
	//
	// ...and then sort out the articles that *don't* have images based on the list of articles
	// that do.
	// 
	// The problem is that some (most?) articles contain images that do not represent the actual
	// article's subject but are there for some sort of technical purpose, e.g.: stub articles,
	// belonging to projects, links to WikiQuote, etc.
	// 
	// For example, the article http://en.wikipedia.org/wiki/Lietuvos_rytas does not have a
	// photo (as of Nov 4, 2011), but the API:
	// 
	//   http://en.wikipedia.org/w/api.php?action=query&titles=Lietuvos_rytas&prop=images&redirects&imlimit=max
	//
	// ... reports that the article contains two images, "File:Flag of Lithuania.svg" and
	// "File:Newspaper.svg". Both of them are used in a stub template that is included in the
	// article.
	//
	// So, we cheat and do this:
	//
	// 1) Do an API request for image list and the content of latest revision:
	//   
	//   http://en.wikipedia.org/w/api.php?action=query&titles=Lietuvos_rytas&prop=images|revisions&redirects&imlimit=max&rvprop=content
	//
	// 2) Search for the filename of the image in the wikitext and see if it's there. If it is,
	//    assume that the image belongs to an article and that the article actually is illustrated
	//    (thus, nothing to do here). If the image's filename is not in the wikitext, this means
	//    that the image came here from some sort of a template and should not be taken as an
	//    article's image
	//
	
	
	// Collect titles
	NSMutableArray *articleTitles = [NSMutableArray array];
	for (AAClientArticle *article in articles) {
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
	
	MWLOG(@"GN didFindGeoNames: totalFound: %d", geoNames, total);
	
	NSMutableArray *resultNames = [NSMutableArray array];
	
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
			[resultNames addObject:[AAClientArticle articleWithTitle:title
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
	[self refineNearbyArticlesUsingMediaWikiWithArticles:resultNames];
}

- (void)mwClient:(MWClient *)client
didSucceedCallingAPIWithRequest:(MWAPIRequest *)request
		 results:(NSDictionary *)results {
	
	MWLOG(@"mwClient: %@ didSucceedCallingAPIWithRequest: %@ results: %@", client, request, results);
}

- (void)mwClient:(MWClient *)client
didFailCallingAPIWithRequest:(MWAPIRequest *)request
		   error:(NSError *)error {
	
	MWLOG(@"mwClient: %@ didFailCallingAPIWithRequest: %@ error: %@", client, request, error);
}

@end


#pragma mark - AAClient public methods


@implementation AAClient

@synthesize delegate;


- (id)init {
	
	if ((self = [super init])) {
		delegate = nil;
		currentRequest = nil;
		
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
