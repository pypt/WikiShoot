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

#import <Foundation/Foundation.h>


#pragma mark Single article object

@interface AAClientArticle : NSObject {
	
	@public
		
	NSString *title;		// e.g. "Glärnisch"
	NSString *type;			// e.g. "mountain"
	NSString *wikipediaURL;	// e.g. "http://en.wikipedia.org/wiki/Gl%C3%A4rnisch"
	double distance;		// e.g. 0.1869
	double latitude;		// e.g. 46.998611
	double longitude;		// e.g. 8.998611
	NSString *language;		// e.g. "en"
	NSString *countryCode;	// e.g. "CH"
	NSString *summary;		// e.g. "The Glärnisch is a mountain of the Glarus Alps, overlooking the valley of the Linth in the canton of Glarus. It consists of several summits of which the highest (2,914 metres) is distinguished by the name Bächistock, followed by the Vrenelisgärtli (2,904 metres) and the Ruchen (2,901 metres)."
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *wikipediaURL;
@property (nonatomic) double distance;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSString *summary;

+ (AAClientArticle *)articleWithTitle:(NSString *)title
								 type:(NSString *)type
						 wikipediaURL:(NSString *)wikipediaURL
							 distance:(double)distance
							 latitude:(double)latitude
							longitude:(double)longitude
							 language:(NSString *)language
						  countryCode:(NSString *)countryCode
							  summary:(NSString *)summary;

@end
