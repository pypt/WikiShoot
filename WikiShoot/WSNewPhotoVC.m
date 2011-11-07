//
//  WSNewPhotoVC.m
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-11-07.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WSNewPhotoVC.h"
#import "MWAPIRequest.h"
#import "WSConfiguration.h"
#import "WSPreUploadPhotoVC.h"
#import <MobileCoreServices/MobileCoreServices.h>


// Table sections, cells and identifiers
NSUInteger const kWSNewPhotoVCPreviewSection = 0;
NSUInteger const kWSNewPhotoVCPreviewSectionPreviewCell = 0;
NSString  *const kWSNewPhotoVCPreviewSectionPreviewCellIdentifier = @"kWSNewPhotoVCPreviewSectionPreviewCell";

NSUInteger const kWSNewPhotoVCTakePhotoSection = 1;
NSUInteger const kWSNewPhotoVCTakePhotoSectionTakePhotoCell = 0;
NSString  *const kWSNewPhotoVCTakePhotoSectionTakePhotoCellIdentifier = @"kWSNewPhotoVCTakePhotoSectionTakePhotoCell";

NSUInteger const kWSNewPhotoVCMiscActionsSection = 2;
NSUInteger const kWSNewPhotoVCMiscActionsSectionOpenWikipediaArticleCell = 0;
NSString  *const kWSNewPhotoVCMiscActionsSectionOpenWikipediaArticleCellIdentifier = @"kWSNewPhotoVCMiscActionsSectionOpenWikipediaArticleCell";
NSUInteger const kWSNewPhotoVCMiscActionsSectionThisIsNotAPlaceCell = 1;
NSString  *const kWSNewPhotoVCMiscActionsSectionThisIsNotAPlaceCellIdentifier = @"kWSNewPhotoVCMiscActionsSectionThisIsNotAPlaceCell";

// Photo source action sheet tag
NSInteger const kWSNewPhotoVCPhotoSourceActionSheetTag = 5;

// Photo source action sheet buttons
NSUInteger const kWSNewPhotoVCPhotoSourceActionSheetNewPhotoButton = 0;
NSUInteger const kWSNewPhotoVCPhotoSourceActionSheetChooseFromLibraryButton = 1;



#pragma mark - Private methods

@interface WSNewPhotoVC (Private)

// Cells
- (UITableViewCell *)articlePreviewCell;
- (UITableViewCell *)takePhotoCell;
- (UITableViewCell *)openWikipediaArticleCell;
- (UITableViewCell *)thisIsNotAPlaceCell;

// Cell actions
- (void)takePhotoChooseSource;
- (void)takePhotoFromSourceType:(UIImagePickerControllerSourceType)sourceType;
- (void)openWikipediaArticle;
- (void)thisIsNotAPlace;

@end

@implementation WSNewPhotoVC (Private)

- (UITableViewCell *)articlePreviewCell {
	
	NSString *cellIdentifier = kWSNewPhotoVCPreviewSectionPreviewCellIdentifier;
	
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cellIdentifier] autorelease];
    }
	
	//[cell.textLabel setText:NSLocalizedString(@"Preview", @"")];
	[cell.textLabel setText:articleTitle];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
    return cell;
}

- (UITableViewCell *)takePhotoCell {

	NSString *cellIdentifier = kWSNewPhotoVCTakePhotoSectionTakePhotoCellIdentifier;
	
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cellIdentifier] autorelease];
    }
	
	[cell.textLabel setText:NSLocalizedString(@"Take a photo", @"")];
	[cell.textLabel setTextAlignment:UITextAlignmentCenter];
	[cell.imageView setImage:[UIImage imageNamed:@"camera"]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
    return cell;
}

- (UITableViewCell *)openWikipediaArticleCell {
	
	NSString *cellIdentifier = kWSNewPhotoVCMiscActionsSectionOpenWikipediaArticleCellIdentifier;
	
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cellIdentifier] autorelease];
    }
	
	[cell.textLabel setText:NSLocalizedString(@"Open Wikipedia article", @"")];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

- (UITableViewCell *)thisIsNotAPlaceCell {

	NSString *cellIdentifier = kWSNewPhotoVCMiscActionsSectionThisIsNotAPlaceCellIdentifier;
	
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cellIdentifier] autorelease];
    }
	
	[cell.textLabel setText:NSLocalizedString(@"This is not a place", @"")];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

- (void)takePhotoChooseSource {
	
	// Not checking for camera, because the requirement for it is already set in
	// Info.plist, and the app would not be useful at all without the camera anyway.
	
	UIActionSheet *as = [[UIActionSheet alloc]
						 initWithTitle:NSLocalizedString(@"Choose photo:", @"")
						 delegate:self
						 cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
						 destructiveButtonTitle:nil
						 otherButtonTitles:
						  NSLocalizedString(@"New photo", @""),	// 0 - kWSNewPhotoVCPhotoSourceActionSheetNewPhotoButton
						  NSLocalizedString(@"Choose from library", @""),	// 1 - kWSNewPhotoVCPhotoSourceActionSheetChooseFromLibraryButton
						 nil];
	[as setTag:kWSNewPhotoVCPhotoSourceActionSheetTag];
	[as showInView:self.view];
	MW_RELEASE_SAFELY(as);
}

- (void)takePhotoFromSourceType:(UIImagePickerControllerSourceType)sourceType {
	
	if (! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
		// Something went wrong because the user shouldn't have been able to run
		// the application at all because of the camera requirement set in Info.plist
		MWERR(@"Selected source type is not available");
		return;
	}
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	// default "media types" is a single image, so no need to change
	[picker setDelegate:self];
	[picker setSourceType:sourceType];
	if (sourceType == UIImagePickerControllerSourceTypeCamera && [picker respondsToSelector:@selector(setShowsCameraControls:)]) {
		[picker setShowsCameraControls:YES];
	}
	if ([picker respondsToSelector:@selector(setAllowsImageEditing:)]) {
		[picker setAllowsImageEditing:NO];
	}
	if ([picker respondsToSelector:@selector(setAllowsEditing:)]) {
		[picker setAllowsEditing:NO];
	}
	
	[self presentModalViewController:picker animated:YES];
	MW_RELEASE_SAFELY(picker);
}

- (void)openWikipediaArticle {
	// FIXME
}

- (void)thisIsNotAPlace {
	// FIXME
}

@end


#pragma mark - Public methods

@implementation WSNewPhotoVC

- (id)init {
	
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		self.title = NSLocalizedString(@"New photo", @"");
		[self.tableView setDataSource:self];
		[self.tableView setDelegate:self];
	}
	
	return self;
}

- (id)initWithArticleTitle:(NSString *)initArticleTitle
			  mediaWikiURL:(NSString *)initMediaWikiURL {
	
	if ((self = [self init])) {
		articleTitle = [initArticleTitle retain];
		mediaWikiURL = [initMediaWikiURL retain];
	}
	
	return self;
}

- (void)dealloc {
	
	MW_RELEASE_SAFELY(articleTitle);
	MW_RELEASE_SAFELY(mediaWikiURL);
	
	[super dealloc];
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3; // preview + "Take photo" + misc. actions
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		
	switch (section) {
		case kWSNewPhotoVCPreviewSection:
			return 1;	// Preview
			break;
			
		case kWSNewPhotoVCTakePhotoSection:
			return 1;	// "Take photo" cell
			break;
		
		case kWSNewPhotoVCMiscActionsSection:
			return 2;	// "Open Wikipedia article", "This is not a place"
			break;
			
		default:
			MWERR(@"Unknown section %d", section);
			return 0;
			break;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

	if (section == kWSNewPhotoVCPreviewSection) {
		NSString *footer = NSLocalizedString(@"Wikipedia's article on '%@' does not have a photo and needs one!", @"");
		footer = [NSString stringWithFormat:footer, articleTitle];
		return footer;
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		
		case kWSNewPhotoVCPreviewSection:
			
			switch (indexPath.row) {
				case kWSNewPhotoVCPreviewSectionPreviewCell:		return [self articlePreviewCell];	break;
			}
			
			break;
		
		case kWSNewPhotoVCTakePhotoSection:

			switch (indexPath.row) {
				case kWSNewPhotoVCTakePhotoSectionTakePhotoCell:	return [self takePhotoCell];	break;
			}

			break;
			
		
		case kWSNewPhotoVCMiscActionsSection:

			switch (indexPath.row) {
				case kWSNewPhotoVCMiscActionsSectionOpenWikipediaArticleCell:	return [self openWikipediaArticleCell];	break;
				case kWSNewPhotoVCMiscActionsSectionThisIsNotAPlaceCell:		return [self thisIsNotAPlaceCell];		break;
			}

			break;
	}
	
	MWERR(@"Unkown section/row: %@", indexPath);
	return nil;
}


#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		case kWSNewPhotoVCPreviewSection:
			
			switch (indexPath.row) {
				case kWSNewPhotoVCPreviewSectionPreviewCell:
					
					[cell setBackgroundColor:[UIColor clearColor]];
					[cell.contentView setBackgroundColor:[UIColor clearColor]];
					
					break;
					
				default:
					break;
			}
			
			break;
	}
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
			
		case kWSNewPhotoVCPreviewSection:
			// Do nothing.
			break;
			
		case kWSNewPhotoVCTakePhotoSection:
			
			switch (indexPath.row) {
				case kWSNewPhotoVCTakePhotoSectionTakePhotoCell:	[self takePhotoChooseSource];	break;
			}
			
			break;
			
			
		case kWSNewPhotoVCMiscActionsSection:
			
			switch (indexPath.row) {
				case kWSNewPhotoVCMiscActionsSectionOpenWikipediaArticleCell:	[self openWikipediaArticle];	break;
				case kWSNewPhotoVCMiscActionsSectionThisIsNotAPlaceCell:		[self thisIsNotAPlace];			break;
			}
			
			break;
	}

}


#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (actionSheet.tag) {
		case kWSNewPhotoVCPhotoSourceActionSheetTag:
			
			switch (buttonIndex) {
				case kWSNewPhotoVCPhotoSourceActionSheetNewPhotoButton:
					[self takePhotoFromSourceType:UIImagePickerControllerSourceTypeCamera];
					break;
					
				case kWSNewPhotoVCPhotoSourceActionSheetChooseFromLibraryButton:
					[self takePhotoFromSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
					break;
					
				default:
					break;
			}
			
			break;
	}
	
}


#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	// Save photo
	UIImage *image = nil;
	image = [info objectForKey:UIImagePickerControllerEditedImage];
	if (! image) {
		image = [info objectForKey:UIImagePickerControllerOriginalImage];
	}
	
	// Store to temp. location
	NSData *imageData = UIImageJPEGRepresentation(image, WS_JPEG_COMPRESSION_QUALITY);
	if (! imageData) {
		MWERR(@"Unable to convert image to JPEG");
		return;
	}
	
	NSString *tempFilename = [MWAPIRequest temporaryFilenameForImageWithBasename:@"image"];
	if (! [imageData writeToFile:tempFilename
					  atomically:YES]) {
		MWERR(@"Unable to store image to temp. file '%@'", tempFilename);
		return;
	}
	
	[picker dismissModalViewControllerAnimated:YES];
	
	// Show pre-upload screen
	WSPreUploadPhotoVC *preUploadPhotoVC = [[WSPreUploadPhotoVC alloc] initWithArticleTitle:articleTitle
																			   mediaWikiURL:mediaWikiURL
																				  imagePath:tempFilename];
	[self.navigationController pushViewController:preUploadPhotoVC animated:YES];
	[preUploadPhotoVC release];
}

@end
