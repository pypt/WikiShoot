//
//  AAClientRequest.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAClientRequest.h"


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
