//
//  WSMainVC.m
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WSMainVC.h"
#import "WSConfiguration.h"
#import "WSArticleAnnotation.h"


// Object type UISegmentedControl segments
NSUInteger const kWSMainVCObjectTypesPlacesSegment = 0;
NSUInteger const kWSMainVCObjectTypesThingsSegment = 1;

// Width of a single object type segment
CGFloat const kWSMainVCObjectTypesSegmentWidth = 65.0;

// Width of a square-ish toolbar/navbar button
CGFloat const kWSMainVCToolbarButtonWidth = 30.0;

// View tags (for checking if it has been added to the hierarchy)
NSInteger const kWSMainVCToolbarViewTag = 1;
NSInteger const kWSMainVCMapViewTag = 2;

// Map view article pin identifier
NSString *const kKWMainVCMapArticlePinIdentifier = @"lt.pypt.wikishoot.articlepin";


#pragma mark - Private methods

@interface WSMainVC (Private)

// Possible navbar titles
+ (NSString *)navbarTitleWhenPickingAPlace;
+ (NSString *)navbarTitleWhenPickingAThing;

// (Re)draw toolbar for a selected segment
- (void)redrawToolbarForSelectedSegment:(NSUInteger)selectedSegment;

// Prepare screen for two different types of object picking
- (void)prepareForChoosingAPlace;
- (void)prepareForChoosingAThing;

@end

@implementation WSMainVC (Private)

+ (NSString *)navbarTitleWhenPickingAPlace {
	return NSLocalizedString(@"Pick a place", @"");
}

+ (NSString *)navbarTitleWhenPickingAThing {
	return NSLocalizedString(@"Pick a thing", @"");
}

- (void)redrawToolbarForSelectedSegment:(NSUInteger)selectedSegment {
	
	// "Locate me" toolbar button
	if (! userLocationBarButton) {
		userLocationBarButton = [[UIBarButtonItem alloc]
								 initWithImage:[UIImage imageNamed:@"user-location-arrow"]
								 style:UIBarButtonItemStyleBordered
								 target:self
								 action:@selector(userLocationBarButtonTapped:)];
		[userLocationBarButton setWidth:kWSMainVCToolbarButtonWidth];
	}
	
	// Object types segmented control
	if (! objectTypesSegControl) {
		objectTypesSegControl = [[UISegmentedControl alloc] initWithItems:
								 [NSArray arrayWithObjects:
								  NSLocalizedString(@"Places", @""),
								  NSLocalizedString(@"Things", @""),
								  nil]];
		[objectTypesSegControl setSegmentedControlStyle:UISegmentedControlStyleBar];
		[objectTypesSegControl setSelectedSegmentIndex:selectedSegment];
		[objectTypesSegControl setWidth:kWSMainVCObjectTypesSegmentWidth
					  forSegmentAtIndex:kWSMainVCObjectTypesPlacesSegment];
		[objectTypesSegControl setWidth:kWSMainVCObjectTypesSegmentWidth
					  forSegmentAtIndex:kWSMainVCObjectTypesThingsSegment];
		[objectTypesSegControl addTarget:self
								  action:@selector(objectTypesSegControlChanged:)
						forControlEvents:UIControlEventValueChanged];
	}
	if (! objectTypesSegControlBarButton) {
		objectTypesSegControlBarButton = [[UIBarButtonItem alloc] initWithCustomView:objectTypesSegControl];
	}
	
	// Map type toolbar button
	if (! mapTypeBarButton) {
		mapTypeBarButton = [[UIBarButtonItem alloc]
							initWithImage:[UIImage imageNamed:@"page-curl"]
							style:UIBarButtonItemStyleBordered
							target:self
							action:@selector(mapTypeBarButtonTapped:)];
		[mapTypeBarButton setWidth:kWSMainVCToolbarButtonWidth];
	}
	
	// The toolbar at the bottom
	if (! objectTypesToolbar) {
		objectTypesToolbar = [[UIToolbar alloc] init];
		[objectTypesToolbar setTag:kWSMainVCToolbarViewTag];
		
		[objectTypesToolbar sizeToFit];	// for the toolbar to figure out it's height
		CGRect objectTypesToolbarFrame;
		objectTypesToolbarFrame.origin.x = 0;
		objectTypesToolbarFrame.origin.y = self.view.frame.size.height - objectTypesToolbar.frame.size.height;
		objectTypesToolbarFrame.size.width = self.view.frame.size.width;
		objectTypesToolbarFrame.size.height = objectTypesToolbar.frame.size.height;
		[objectTypesToolbar setFrame:objectTypesToolbarFrame];
		[objectTypesToolbar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	}
	
	// Flexible space on the left and right
	if (! flexSpaceLeftBarButton) {
		flexSpaceLeftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	}
	if (! flexSpaceRightBarButton) {
		flexSpaceRightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	}
	
	// Toolbar items
	NSArray *toolbarItems = nil;
	
	switch (selectedSegment) {
		case kWSMainVCObjectTypesPlacesSegment:
			toolbarItems = [NSArray arrayWithObjects:
							userLocationBarButton,
							flexSpaceLeftBarButton,
							objectTypesSegControlBarButton,
							flexSpaceRightBarButton,
							mapTypeBarButton,
							nil];
			break;
			
		case kWSMainVCObjectTypesThingsSegment:
			toolbarItems = [NSArray arrayWithObjects:
							/* userLocationBarButton, */
							flexSpaceLeftBarButton,
							objectTypesSegControlBarButton,
							flexSpaceRightBarButton,
							/* mapTypeBarButton, */
							nil];			
			break;
	}

	[objectTypesToolbar setItems:toolbarItems];
	
	if (! [self.view viewWithTag:kWSMainVCToolbarViewTag]) {
		[self.view addSubview:objectTypesToolbar];
	}
}

- (void)prepareForChoosingAPlace {

	self.title = [WSMainVC navbarTitleWhenPickingAPlace];
	[self redrawToolbarForSelectedSegment:kWSMainVCObjectTypesPlacesSegment];

	// Map view
	if (! placesMapView) {
		
		placesMapView = [[MKMapView alloc] init];
		[placesMapView setTag:kWSMainVCMapViewTag];
		
		CGRect placesMapViewFrame;
		placesMapViewFrame.origin.x = 0;
		placesMapViewFrame.origin.y = 0;
		placesMapViewFrame.size.width = self.view.frame.size.width;
		placesMapViewFrame.size.height = self.view.frame.size.height - objectTypesToolbar.frame.size.height;
		[placesMapView setFrame:placesMapViewFrame];
		
		[placesMapView setDelegate:self];
		[placesMapView setZoomEnabled:YES];
		[placesMapView setScrollEnabled:YES];
		[placesMapView setShowsUserLocation:NO];
		
		double initialLat = [[NSUserDefaults standardUserDefaults]
							 doubleForKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LAT_KEY];
		double initialLon = [[NSUserDefaults standardUserDefaults]
							 doubleForKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LON_KEY];
		double initialLatDelta = [[NSUserDefaults standardUserDefaults]
								  doubleForKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LATDELTA_KEY];
		double initialLonDelta = [[NSUserDefaults standardUserDefaults]
								  doubleForKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LONDELTA_KEY];
		
		MKCoordinateRegion region = { { 0, 0 }, { 0, 0 } };
		region.center.latitude = initialLat;
		region.center.longitude = initialLon;
		region.span.latitudeDelta = initialLatDelta;
		region.span.longitudeDelta = initialLonDelta;
		[placesMapView setRegion:region animated:NO];
		
		NSString *strInitialMapType = [[NSUserDefaults standardUserDefaults] stringForKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_MAPTYPE_KEY];
		MKMapType initialMapType;
		if ([strInitialMapType isEqualToString:@"Standard"]) {
			initialMapType = MKMapTypeStandard;
		} else if ([strInitialMapType isEqualToString:@"Satellite"]) {
			initialMapType = MKMapTypeSatellite;
		} else if ([strInitialMapType isEqualToString:@"Hybrid"]) {
			initialMapType = MKMapTypeHybrid;
		} else {
			initialMapType = MKMapTypeStandard;
		}
		[placesMapView setMapType:initialMapType];
	}
	
	if (! [self.view viewWithTag:kWSMainVCMapViewTag]) {
		[self.view addSubview:placesMapView];
	}
	
}

- (void)prepareForChoosingAThing {
	
	self.title = [WSMainVC navbarTitleWhenPickingAThing];
	[self redrawToolbarForSelectedSegment:kWSMainVCObjectTypesThingsSegment];

}

@end


#pragma mark - Public methods

@implementation WSMainVC

- (id)init {
	
	if ((self = [super init])) {
		// Default is place
		self.title = [WSMainVC navbarTitleWhenPickingAPlace];
		
		aaClient = [[AAGeoNamesMediaWikiClient alloc] init];
		[aaClient setDelegate:self];
		[aaClient setMediaWikiApiURL:WS_MEDIAWIKI_URL];
		[aaClient setGeoNamesUsername:WS_GEONAMES_USERNAME];
	}
	
	return self;
}

- (void)dealloc {

	MW_RELEASE_SAFELY(objectTypesToolbar);
	MW_RELEASE_SAFELY(userLocationBarButton);
	MW_RELEASE_SAFELY(flexSpaceLeftBarButton);
	MW_RELEASE_SAFELY(objectTypesSegControl);
	MW_RELEASE_SAFELY(objectTypesSegControlBarButton);
	MW_RELEASE_SAFELY(flexSpaceRightBarButton);
	MW_RELEASE_SAFELY(mapTypeBarButton);
	MW_RELEASE_SAFELY(searchingActIndView);
	MW_RELEASE_SAFELY(searchingActIndViewBarButton);
	MW_RELEASE_SAFELY(placesMapView);
	MW_RELEASE_SAFELY(aaClient);
	
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
		
	// Subtract the navbar height from the view
	CGRect frame = self.view.frame;
	frame.size.height -= self.navigationController.navigationBar.frame.size.height;
	[self.view setFrame:frame];
	
	// Add a activity view for indicating when we're searching
	searchingActIndView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[searchingActIndView setHidesWhenStopped:YES];
	[searchingActIndView stopAnimating];
	searchingActIndViewBarButton = [[UIBarButtonItem alloc] initWithCustomView:searchingActIndView];
	[searchingActIndViewBarButton setWidth:kWSMainVCToolbarButtonWidth];
	[self.navigationItem setRightBarButtonItem:searchingActIndViewBarButton];

	 // Choose a place from a map by default
	[self prepareForChoosingAPlace];
}


#pragma mark Toolbar actions

- (void)userLocationBarButtonTapped:(id)sender {
	
	[placesMapView setShowsUserLocation:(!placesMapView.showsUserLocation)];
	
	if (placesMapView.showsUserLocation) {
		[userLocationBarButton setStyle:UIBarButtonItemStyleDone];
		firstUserLocationZoomed = NO;
	} else {
		[userLocationBarButton setStyle:UIBarButtonItemStylePlain];
	}
}

- (void)objectTypesSegControlChanged:(id)sender {
	
	switch (objectTypesSegControl.selectedSegmentIndex) {
			
		case kWSMainVCObjectTypesPlacesSegment:
			[self prepareForChoosingAPlace];
			break;
			
		case kWSMainVCObjectTypesThingsSegment:
			[self prepareForChoosingAThing];
			break;
			
		default:
			MWERR(@"Unknown segment");
			return;
			break;
	}
	
}

- (void)mapTypeBarButtonTapped:(id)sender {
	
}


#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	
	if (! firstUserLocationZoomed) {
		
		MKCoordinateSpan span;
		span.latitudeDelta = placesMapView.region.span.latitudeDelta;
		span.longitudeDelta = placesMapView.region.span.longitudeDelta;
		
		CLLocationCoordinate2D location = userLocation.coordinate;
		
		MKCoordinateRegion region;
		region.span = span;
		region.center = location;
		
		[placesMapView setRegion:region
						animated:YES];
		[placesMapView regionThatFits:region];
		
		firstUserLocationZoomed = YES;
	}
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	
	// Zoom to user location
	for (MKAnnotationView *annotationView in views) {
		if (annotationView.annotation == placesMapView.userLocation) {
			
			if (! firstUserLocationZoomed) {
				MKCoordinateSpan span;
				span.latitudeDelta = placesMapView.region.span.latitudeDelta;
				span.longitudeDelta = placesMapView.region.span.longitudeDelta;

				CLLocationCoordinate2D location = placesMapView.userLocation.coordinate;

				MKCoordinateRegion region;
				region.span = span;
				region.center = location;

				[placesMapView setRegion:region
								animated:YES];
				[placesMapView regionThatFits:region];
				
				firstUserLocationZoomed = YES;
			}
		}
    }
}

// Do not search for locations when the zoom is too big because it doesn't make sense
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
		
	// Store to user defaults
	[[NSUserDefaults standardUserDefaults]
	 setDouble:placesMapView.region.center.latitude
	 forKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LAT_KEY];
	[[NSUserDefaults standardUserDefaults]
	 setDouble:placesMapView.region.center.longitude
	 forKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LON_KEY];
	[[NSUserDefaults standardUserDefaults]
	 setDouble:placesMapView.region.span.latitudeDelta
	 forKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LATDELTA_KEY];
	[[NSUserDefaults standardUserDefaults]
	 setDouble:placesMapView.region.span.longitudeDelta
	 forKey:WS_USERDEFAULTS_PLACE_MAP_DEFAULT_LONDELTA_KEY];
	
	// Start searching for articles around
	[searchingActIndView startAnimating];
	
	AAClientRequest *request = [AAClientRequest
								requestWithLatitude:placesMapView.region.center.latitude
								longitude:placesMapView.region.center.longitude
								maxRows:WS_ARTICLES_TO_FIND_AROUND_MAX
								radius:WS_ARTICLES_TO_FIND_AROUND_RADIUS
								languageCode:WS_ARTICLES_TO_FIND_AROUND_LANGUAGE_CODE];
	
	[aaClient searchForNearbyArticlesForRequest:request];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	
	if (annotation == placesMapView.userLocation) {
		return nil;
	}
	
	MKPinAnnotationView *pinView = nil; 
	pinView = (MKPinAnnotationView *)[placesMapView dequeueReusableAnnotationViewWithIdentifier:kKWMainVCMapArticlePinIdentifier];
	if (! pinView) {
		pinView = [[[MKPinAnnotationView alloc]
					initWithAnnotation:annotation
					reuseIdentifier:kKWMainVCMapArticlePinIdentifier] autorelease];
	}

	[pinView setPinColor:MKPinAnnotationColorRed];
	[pinView setCanShowCallout:YES];
	[pinView setAnimatesDrop:YES];
	[pinView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];

	return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	
	MWLOG(@"map accessory tapped: %@", control);
	
}


#pragma mark AAClientDelegate methods

- (void)aaClient:(AAAbstractClient *)aaClient
startedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request {
	
	//MWLOG(@"aaClient: %@ startedSearchingForNearbyArticlesForRequest: %@", aaClient, request);
}

- (void)aaClient:(AAAbstractClient *)aaClient
startedRefiningNearbyArticlesForRequest:(AAClientRequest *)request {
	
	//MWLOG(@"aaClient: %@ startedRefiningNearbyArticlesForRequest: %@", aaClient, request);
}

- (void)aaClient:(AAAbstractClient *)aaClient
succeededSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		articles:(NSArray *)articles /* array of AAClientArticle items */ {
	
	//MWLOG(@"aaClient: %@ succeededSearchingForNearbyArticlesForRequest: %@ articles: %@", aaClient, request, articles);
	
	[searchingActIndView stopAnimating];
	
	// Create new annotations
	NSMutableArray *annotationsToAdd = [NSMutableArray array];
	for (AAClientArticle *article in articles) {
		WSArticleAnnotation *annotation = [[[WSArticleAnnotation alloc] init] autorelease];
		[annotation setTitle:article.title];
		[annotation setSubtitle:article.type];
		CLLocationCoordinate2D annotationCoordinate;
		annotationCoordinate.latitude = article.latitude;
		annotationCoordinate.longitude = article.longitude;
		[annotation setCoordinate:annotationCoordinate];
		
		[annotationsToAdd addObject:annotation];
	}
	
	// Remove old annotations (leave the ones that are already shown)
	NSMutableArray *annotationsToRemove = [NSMutableArray array];
	for (NSObject<MKAnnotation> *annotation in placesMapView.annotations) {
		if (annotation != placesMapView.userLocation) {
			
			if ([annotationsToAdd containsObject:annotation]) {
				[annotationsToAdd removeObject:annotation];
			} else {
				
				// Don't touch the selected annotations
				if (! [[placesMapView selectedAnnotations] containsObject:annotation]) {
					[annotationsToRemove addObject:annotation];
				}
			}
			
		}
	}
	
	// Commit changes
	[placesMapView removeAnnotations:annotationsToRemove];
	[placesMapView addAnnotations:annotationsToAdd];
	
}

- (void)aaClient:(AAAbstractClient *)aaClient
failedSearchingForNearbyArticlesForRequest:(AAClientRequest *)request
		   error:(NSError *)error {
	
	// FIXME handle error somehow
	
	//MWLOG(@"aaClient: %@ failedSearchingForNearbyArticlesForRequest: %@ error: %@", aaClient, request, error);
	
	[searchingActIndView stopAnimating];

}


@end
