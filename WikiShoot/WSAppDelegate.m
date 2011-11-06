//
//  WSAppDelegate.m
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
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
