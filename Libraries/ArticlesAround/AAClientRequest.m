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
