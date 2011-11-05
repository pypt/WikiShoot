//
//  AAClient.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAClientArticle.h"
#import "MWClientDelegate.h"
#import "ILGeoNamesLookup.h"


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


#pragma mark Delegate protocol for status and results retrieval

@class AAClient;
@class AAClientRequest;


@protocol AAClientDelegate

@optional

// Started searching (GeoNames request sent, waiting for reply; MediaWiki's not yet been touched)
- (void)aaClient:(AAClient *)aaClient
startedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request;

// Finished requesting GeoNames, moving on to MediaWiki's stage to find out which articles don't have pics (or some other metadata)
- (void)aaClient:(AAClient *)aaClient
startedRefiningNearbyArticlesForRequest:(AAClientRequest *)request;

// Successfully finished searching for nearby articles (GeoNames' and MediaWiki's stages are both done)
- (void)aaClient:(AAClient *)aaClient
succeededSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		articles:(NSArray *)articles /* array of AAClientArticle items */;

// Failed searching for nearby articles (at the GeoNames stage, or at the MediaWiki's stage)
- (void)aaClient:(AAClient *)aaClient
failedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		   error:(NSError *)error;

@end


#pragma mark Search request with coordinates

// Similar to iPhone's CLLocationCoordinate2D
@interface AAClientRequest : NSObject {
	
	@public
	
	double latitude;
	double longitude;
	unsigned short maxRows;
	double radius;
	NSString *languageCode;
}

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) unsigned short maxRows;
@property (nonatomic) double radius;
@property (nonatomic, retain) NSString *languageCode;

+ (AAClientRequest *)requestWithLatitude:(double)latitude
							   longitude:(double)longitude
								 maxRows:(unsigned short)maxRows
								  radius:(double)radius
							languageCode:(NSString *)languageCode;

@end


#pragma mark "Articles around" client

@class MWClient;
@class ILGeoNamesLookup;


@interface AAClient : NSObject <MWClientDelegate, ILGeoNamesLookupDelegate> {
	
	@public
	
	id<AAClientDelegate> delegate;
	
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

@property (nonatomic, assign) id<AAClientDelegate> delegate;

- (void)setMediaWikiApiURL:(NSString *)mediaWikiApiURL;
- (void)setGeoNamesUsername:(NSString *)geoNamesUsername;

- (id)initWithDelegate:(id<AAClientDelegate>)initDelegate
	   mediaWikiApiURL:(NSString *)mediaWikiApiURL
	  geoNamesUsername:(NSString *)geoNamesUsername;

- (id)searchForNearbyArticlesForRequest:(AAClientRequest *)request;

@end
