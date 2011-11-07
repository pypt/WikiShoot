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

#import "WSUploadPhotoVC.h"

@implementation WSUploadPhotoVC

- (id)init {
	
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		self.title = NSLocalizedString(@"Uploading...", @"");
		[self.tableView setDataSource:self];
		[self.tableView setDelegate:self];
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
	
	[super dealloc];
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	NSString *cellIdentifier = @"not-implemented";
	
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									   reuseIdentifier:cellIdentifier] autorelease];
    }
	
	[cell.textLabel setText:@"Not implemented."];	// FIXME
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	[cell setAccessoryType:UITableViewCellAccessoryNone];
	
    return cell;
}

@end
