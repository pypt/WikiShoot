//
//  AAClientRequest.h
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

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
