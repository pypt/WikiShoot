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

#import "WSArticleAnnotation.h"

@implementation WSArticleAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize article;


- (BOOL)isEqual:(id)anObject {
	
	if ([anObject isKindOfClass:[WSArticleAnnotation class]]) {
		if ([title isEqualToString:[anObject title]]) {
			return YES;
		}
	}
	
	return NO;
}

@end
