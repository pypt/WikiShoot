//
//  MWAPIRequest.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWDefines.h"


@interface MWAPIRequest : NSObject {
	
	@public
	NSString *action;
	NSInteger tag;
	
	@private
	
	// NSString -> (NSArray|NSString) dictionary (key -> parameter(s))
	NSMutableDictionary *parameters;
	
	// NSString -> NSString dictionary (key -> file path)
	NSMutableDictionary *attachments;
	
	// Temporary files
	NSMutableArray *temporaryFiles;
}

@property (nonatomic, retain) NSString *action;
@property (nonatomic) NSInteger tag;

+ (MWAPIRequest *)requestWithAction:(NSString *)action;

// NSDictionary-like methods for setting/getting parameters
- (NSUInteger)parameterCount;
- (id)parameterForKey:(NSString *)aKey;
- (NSEnumerator *)parameterKeyEnumerator;
- (void)setParameter:(id)parameter forKey:(NSString *)key;
- (void)removeParameterForKey:(NSString *)aKey;

// NSDictionary-like methods for setting/getting file attachments
- (NSUInteger)attachmentCount;
- (NSString *)attachmentPathForKey:(NSString *)key;
- (NSEnumerator *)attachmentKeyEnumerator;
- (void)setAttachmentPath:(NSString *)attachmentPath forKey:(NSString *)key;
- (void)setAttachmentData:(NSData *)attachmentData withBasename:(NSString *)basename forKey:(NSString *)key;
- (void)removeAttachmentForKey:(NSString *)key;

@end
