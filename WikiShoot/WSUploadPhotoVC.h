//
//  WSUploadPhotoVC.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface WSUploadPhotoVC : UITableViewController {
	
@private
	
	NSString *articleTitle;
	NSString *mediaWikiURL;
	NSString *imagePath;
}

- (id)initWithArticleTitle:(NSString *)initArticleTitle
			  mediaWikiURL:(NSString *)initMediaWikiURL
				 imagePath:(NSString *)initImagePath;

@end
