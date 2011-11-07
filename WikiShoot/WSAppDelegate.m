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

#import "WSAppDelegate.h"
#import "WSConfiguration.h"
#import "WSMainVC.h"


#pragma mark - Private methods

@interface WSAppDelegate (Private)

+ (void)registerUserDefaults;

@end

@implementation WSAppDelegate (Private)

+ (void)registerUserDefaults {
	
	NSString *userDefaultsPath = [[NSBundle mainBundle]
								  pathForResource:WS_USERDEFAULTS_INITIAL_CONFIGURATION_PLIST
								  ofType:@"plist"];
	NSDictionary *defaultsOfDefaults = [NSDictionary
										dictionaryWithContentsOfFile:userDefaultsPath];

	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsOfDefaults];
}

@end



#pragma mark - Public methods

@implementation WSAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[WSAppDelegate registerUserDefaults];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	mainVC = [[WSMainVC alloc] init];
	mainNC = [[UINavigationController alloc] initWithRootViewController:mainVC];
	[mainNC.view setAutoresizesSubviews:YES];
	
	[window addSubview:mainNC.view];
	[window makeKeyAndVisible];
	return YES;
}

- (void)dealloc {
	
	MW_RELEASE_SAFELY(mainVC);
	MW_RELEASE_SAFELY(mainNC);
	MW_RELEASE_SAFELY(window);
	
	[super dealloc];
}

@end
