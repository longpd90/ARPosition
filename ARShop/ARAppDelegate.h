//
//  BeNCAppDelegate.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
#import <CoreLocation/CoreLocation.h>


@class MenuViewController;

@interface ARAppDelegate : UIResponder <UIApplicationDelegate,ServiceControllerDelegate>{
    NSString *databasePath;
    CLLocation *userLocation ;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MenuViewController *viewController;

@property (nonatomic, retain) NSMutableArray *arrayPosition;

@end
