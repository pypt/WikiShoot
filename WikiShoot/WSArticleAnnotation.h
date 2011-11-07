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
