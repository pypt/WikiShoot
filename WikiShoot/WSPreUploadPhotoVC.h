//
//  WSPreUploadPhotoVC.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-08.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface WSPreUploadPhotoVC : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	
	@private
	
	NSString *articleTitle;
	NSString *mediaWikiURL;
	NSString *imagePath;
	
	// Loaded on demand
	UIImageView *previewImageView;
}

- (id)initWithArticleTitle:(NSString *)initArticleTitle
			  mediaWikiURL:(NSString *)initMediaWikiURL
				 imagePath:(NSString *)initImagePath;

@end
