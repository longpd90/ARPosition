//
//  BeNCAppDelegate.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MenuViewController;

@interface ARAppDelegate : UIResponder <UIApplicationDelegate>{
    NSString *databasePath;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MenuViewController *viewController;

@property (nonatomic,retain)NSString *databasePath;
- (void)checkDatabase;

@end
