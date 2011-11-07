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
