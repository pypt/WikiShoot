//
//  AAClient.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAClientDelegate.h"
#import "AAClientRequest.h"
#import "AAClientArticle.h"


#pragma mark Error domain

typedef enum AAClientError {
	kAAClientEmptyRequestError = 1,
	kAAClientEmptyMediaWikiApiURLError = 2,
	kAAClientEmptyGeoNamesUsernameError = 3,
	kAAClientGeoNamesRequestError = 4,
	kAAClientMediaWikiAPINetworkError = 5,
	kAAClientMediaWikiAPIResponseError = 6,
} AAClientError;

extern NSString *const kAAClientErrorDomain;


#pragma mark Abstract "Articles around" client

/*
 * Abstract "articles around" client class.
 *
 * Do not use directly.
 *
 * This class is a base of subclasses designed to find articles
 * "around" the given lat/lon (WGS 84) coordinate. AAAbstractClient subclasses
 * receive an AAClientRequest object as a "request", and then fulfill the
 * given request by reporting to the delegate object (if any) which follows
 * the AAClientDelegate protocol.
 *
 * Current implementations:
 * 
 * 1. AAGeoNamesMediaWikiClient. Asks GeoNames (www.geonames.org) API for the
 *    nearby Wikipedia articles, fetches a list of those. Then, requests an
 *    MediaWiki's API for the image list and content of each of the articles
 *    in order to find out which of those articles (reported by GeoNames) have
 *    images and which do not.
 *    Pros: both backends (GN and MW) are clear and consise on the privacy
 *          policy; more 'official' way than the others (maybe).
 *    Cons: makes two whole HTTP requests to get the final data; fetches
 *          wikitext content of a bunch (20-50 -- depends on the user) articles
 *          so uses quite a lot of data.
 *
 * Possible implementations:
 * 
 * 1. The one based on the tool by Kolossos:
 *    http://toolserver.org/~kolossos/openlayers/kml-on-ol.php?photo=no&lang=en&zoom=12&lat=54.6722378&lon=25.2808201
 * 
 * 2. The one based on the tool by Magnus Manske:
 *    http://toolserver.org/~magnus/wikishootme/index.html
 *    http://toolserver.org/~magnus/wikishootme/umkreis.php?lat=52.202544&lng=0.131236&lang=en&radius=20&limit=250&callback=jsonp1320407206982
 *    http://toolserver.org/~magnus/wikishootme/quick_fist.php?doit=1&language=en&project=wikipedia&data=The+Perse+School&datatype=articles&params%5Boutput_format%5D=out_json&params%5Bforarticles%5D=all&params%5Bjpeg%5D=1
 * 
 */

@interface AAAbstractClient : NSObject {
	
	@public
	
	id<AAClientDelegate> delegate;
}

@property (nonatomic, assign) id<AAClientDelegate> delegate;

// Initializer
- (id)initWithDelegate:(id<AAClientDelegate>)initDelegate;

// Main searcher
- (id)searchForNearbyArticlesForRequest:(AAClientRequest *)request;

@end
