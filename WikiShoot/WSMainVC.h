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
