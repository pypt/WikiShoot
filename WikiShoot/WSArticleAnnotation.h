//
//  WSArticleAnnotation.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface WSArticleAnnotation : NSObject <MKAnnotation> {
	
	@public
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (BOOL)isEqual:(id)anObject;

@end
