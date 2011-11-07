//
//  WSMainVC.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AAGeoNamesMediaWikiClient.h"


@interface WSMainVC : UIViewController <MKMapViewDelegate, AAClientDelegate> {
	
	@private
	
	// Toolbar at the bottom
	UIToolbar *objectTypesToolbar;
	
	// Elements of that toolbar
	UIBarButtonItem *userLocationBarButton;
	UIBarButtonItem *flexSpaceLeftBarButton;
	UISegmentedControl *objectTypesSegControl;
	UIBarButtonItem *objectTypesSegControlBarButton;
	UIBarButtonItem *flexSpaceRightBarButton;
	UIBarButtonItem *mapTypeBarButton;
	
	// Activity indicator for searches
	UIActivityIndicatorView *searchingActIndView;
	UIBarButtonItem *searchingActIndViewBarButton;
	
	// Map of places
	MKMapView *placesMapView;
	
	// On the user location start, zoom to the first found location
	BOOL firstUserLocationZoomed;
	
	// "Articles around" searcher
	AAGeoNamesMediaWikiClient *aaClient;
}

- (void)userLocationBarButtonTapped:(id)sender;
- (void)objectTypesSegControlChanged:(id)sender;
- (void)mapTypeBarButtonTapped:(id)sender;

@end
