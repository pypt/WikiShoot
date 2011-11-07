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

#import "WSPreUploadPhotoVC.h"
#import "WSUploadPhotoVC.h"


// Table sections, cells and identifiers
NSUInteger const kWSPreUploadPhotoVCUploadSection = 0;
NSUInteger const kWSPreUploadPhotoVCUploadSectionUploadCell = 0;
NSString  *const kWSPreUploadPhotoVCUploadSectionUploadCellIdentifier = @"kWSPreUploadPhotoVCUploadSectionUploadCell";


#pragma mark - Private methods

@interface WSPreUploadPhotoVC (Private)

- (UITableViewCell *)uploadCell;
- (void)uploadPhoto;

- (void)loadImagePreviewViewIfNeeded;

@end

@implementation WSPreUploadPhotoVC (Private)

- (UITableViewCell *)uploadCell {
	
	NSString *cellIdentifier = kWSPreUploadPhotoVCUploadSectionUploadCellIdentifier;
	
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cellIdentifier] autorelease];
    }
	
	[cell.textLabel setText:NSLocalizedString(@"Upload photo", @"")];
	[cell.textLabel setTextAlignment:UITextAlignmentCenter];
	[cell.imageView setImage:[UIImage imageNamed:@"camera-upload"]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
    return cell;
}

- (void)uploadPhoto {
	
	// Start the uploader
	WSUploadPhotoVC *uploadPhotoVC = [[WSUploadPhotoVC alloc] initWithArticleTitle:articleTitle
																	  mediaWikiURL:mediaWikiURL
																		 imagePath:imagePath];
	[self.navigationController pushViewController:uploadPhotoVC animated:YES];
	MW_RELEASE_SAFELY(uploadPhotoVC);
}

- (void)loadImagePreviewViewIfNeeded {
	
	if (! previewImageView) {
		UIImage *previewImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
		if (! previewImage) {
			MWERR(@"Unable to load image '%@'", imagePath);
			return;
		}
		
		previewImageView = [[UIImageView alloc] initWithImage:previewImage];
		if (! previewImageView) {
			MWERR(@"Unable to load image view for image '%@'", imagePath);
			MW_RELEASE_SAFELY(previewImage);
			return;
		}
		
		[previewImageView sizeToFit];
		
		// Resize if too big
		CGFloat preferredWidth = self.view.frame.size.width - 20.0;
		if (previewImageView.frame.size.width > preferredWidth) {
			CGRect frame = previewImageView.frame;
			CGFloat factor = preferredWidth / previewImageView.frame.size.width;
			
			frame.size.width = preferredWidth;
			frame.size.height = frame.size.height * factor;
			
			[previewImageView setFrame:frame];
		}
		
		MW_RELEASE_SAFELY(previewImage);
	}
}

@end


#pragma mark - Public methods

@implementation WSPreUploadPhotoVC

- (id)init {
	
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		self.title = NSLocalizedString(@"Upload photo", @"");
		[self.tableView setDataSource:self];
		[self.tableView setDelegate:self];
		previewImageView = nil;
	}
	
	return self;
}

- (id)initWithArticleTitle:(NSString *)initArticleTitle
			  mediaWikiURL:(NSString *)initMediaWikiURL
				 imagePath:(NSString *)initImagePath {
	
	if ((self = [self init])) {
		articleTitle = [initArticleTitle retain];
		mediaWikiURL = [initMediaWikiURL retain];
		imagePath = [initImagePath retain];
	}
	
	return self;
}

- (void)dealloc {
	
	MW_RELEASE_SAFELY(articleTitle);
	MW_RELEASE_SAFELY(mediaWikiURL);
	MW_RELEASE_SAFELY(imagePath);
	MW_RELEASE_SAFELY(previewImageView);
	
	[super dealloc];
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1; // "Upload photo"
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	switch (section) {
		case kWSPreUploadPhotoVCUploadSection:
			return 1;	// "Upload photo"
			break;
			
		default:
			MWERR(@"Unknown section %d", section);
			return 0;
			break;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if (section == kWSPreUploadPhotoVCUploadSection) {
		return NSLocalizedString(@"Happy with the shot? Upload it to Wikimedia Commons so wikipedians can use it!", @"");
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

	if (section == kWSPreUploadPhotoVCUploadSection) {
		return NSLocalizedString(@"Your photo:", @"");
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
			
		case kWSPreUploadPhotoVCUploadSection:
			
			switch (indexPath.row) {
				case kWSPreUploadPhotoVCUploadSectionUploadCell:		return [self uploadCell];	break;
			}
			
			break;			
	}
	
	MWERR(@"Unkown section/row: %@", indexPath);
	return nil;
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		
		case kWSPreUploadPhotoVCUploadSection:
			
			switch (indexPath.row) {
				case kWSPreUploadPhotoVCUploadSectionUploadCell:	[self uploadPhoto];	break;
			}
			
			break;
	}
	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	if (section == kWSPreUploadPhotoVCUploadSection) {
		[self loadImagePreviewViewIfNeeded];
		
		return previewImageView;
	}
	
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	
	if (section == kWSPreUploadPhotoVCUploadSection) {
		[self loadImagePreviewViewIfNeeded];
		
		return previewImageView.frame.size.height;
	}

	return 0;
}

@end
