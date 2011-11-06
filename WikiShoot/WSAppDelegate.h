//
//  WSAppDelegate.h
//  WikiShoot
//
//  Created by Linas Valiukas on 2011-10-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WSMainVC;


@interface WSAppDelegate : UIResponder <UIApplicationDelegate> {
	
	@public
	UIWindow *window;
	UINavigationController *mainNC;
	WSMainVC *mainVC;

}

@property (nonatomic, retain) UIWindow *window;

@end
