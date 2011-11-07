//
//  WSArticleAnnotation.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@class AAClientArticle;


@interface WSArticleAnnotation : NSObject <MKAnnotation> {
	
	@public
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
	
	AAClientArticle *article;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) AAClientArticle *article;

- (BOOL)isEqual:(id)anObject;

@end
