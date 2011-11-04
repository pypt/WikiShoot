//
//  AAClientArticle.m
//  ArticlesAround
//
//  Created by Linas Valiukas on 2011-11-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AAClientArticle.h"

@implementation AAClientArticle

@synthesize title;
@synthesize type;
@synthesize wikipediaURL;
@synthesize distance;
@synthesize latitude;
@synthesize longitude;
@synthesize language;
@synthesize countryCode;
@synthesize summary;


+ (AAClientArticle *)articleWithTitle:(NSString *)title
								 type:(NSString *)type
						 wikipediaURL:(NSString *)wikipediaURL
							 distance:(double)distance
							 latitude:(double)latitude
							longitude:(double)longitude
							 language:(NSString *)language
						  countryCode:(NSString *)countryCode
							  summary:(NSString *)summary {
	
	AAClientArticle *article = [[[AAClientArticle alloc] init] autorelease];
	[article setTitle:title];
	[article setType:type];
	[article setWikipediaURL:wikipediaURL];
	[article setDistance:distance];
	[article setLatitude:latitude];
	[article setLongitude:longitude];
	[article setLanguage:language];
	[article setCountryCode:countryCode];
	[article setSummary:summary];
	
	return article;
}

// For debugging
- (NSString *)description {
	
	return [NSString stringWithFormat:@"{\n"
			"\ttitle = '%@',\n"
			"\ttype = '%@',\n"
			"\twikipediaURL = '%@',\n"
			"\tdistance = %f,\n"
			"\tlatitude = %f,\n"
			"\tlongitude = %f,\n"
			"\tlanguage = '%@',\n"
			"\tcountryCode = '%@',\n"
			"\tsummary = '%@'\n"
			"}\n",
			
			title,
			type,
			wikipediaURL,
			distance,
			latitude,
			longitude,
			language,
			countryCode,
			summary];
}

@end
