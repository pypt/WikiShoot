//
//  WSArticleAnnotation.m
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-06.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
