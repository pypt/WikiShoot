//
//  WSNewPhotoVC.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface WSNewPhotoVC : UITableViewController <UITableViewDataSource, UITableViewDelegate,
	UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	
	@private
	
	NSString *articleTitle;
	NSString *mediaWikiURL;
}

- (id)initWithArticleTitle:(NSString *)initArticleTitle
			  mediaWikiURL:(NSString *)initMediaWikiURL;

@end
