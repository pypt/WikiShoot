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
