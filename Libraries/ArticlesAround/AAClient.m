//
//  AAClient.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAClient.h"
#import "MW.h"


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
	
	currentRequest = request;
					 
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


#pragma mark ILGeoNamesLookupDelegate methods

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler didFailWithError:(NSError *)error {
	
	MWLOG(@"GN didFailWithError: %@", error);
}

- (void)geoNamesLookup:(ILGeoNamesLookup *)handler didFindGeoNames:(NSArray *)geoNames totalFound:(NSUInteger)total {
	
	MWLOG(@"GN didFindGeoNames: %@ totalFound: %d", geoNames, total);
}

@end
