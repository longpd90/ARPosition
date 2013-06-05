//
//  BeNCAppDelegate.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "LocationService.h"
#import "ARAppDelegate.h"
#import "MenuViewController.h"
#import "ARTabbarItem.h"
#import "ARListViewController.h"
#import "AR2DViewController.h"
#import "ARMapViewController.h"
#import "AR3DViewController.h"
#import "ARSettingViewController.h"

@implementation ARAppDelegate
@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize arrayPosition;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[LocationService sharedLocation]startUpdate];
    userLocation = [[LocationService sharedLocation]getOldLocation];
    [self getData:10 withPageSize:8 withPageIndex:1 withCatagory:-1 withLanguage:@"vn"];
    return YES;
}

- (void) setViewConnectSuccess
{
    
    ARTabbarItem *tabItem1 = [[ARTabbarItem alloc] initWithFrame:CGRectMake(2, 0, 50, 50) normalState:@"ListButton.png" toggledState:@"ListButton.png"];
	ARTabbarItem *tabItem2 = [[ARTabbarItem alloc] initWithFrame:CGRectMake(54, 0, 50, 50) normalState:@"CameraButton.png" toggledState:@"CameraButton.png"];
	ARTabbarItem *tabItem3 = [[ARTabbarItem alloc] initWithFrame:CGRectMake(106, 0, 50, 50) normalState:@"AR3DIcon.png" toggledState:@"AR3DIcon.png"];
    ARTabbarItem *tabItem4 = [[ARTabbarItem alloc] initWithFrame:CGRectMake(158, 0, 50, 50) normalState:@"MapButton.png" toggledState:@"MapButton.png"];
    ARTabbarItem *tabItem5 = [[ARTabbarItem alloc] initWithFrame:CGRectMake(210, 0, 50, 50) normalState:@"SettingIcon.png" toggledState:@"SettingIcon.png"];
    
    
    ARListViewController *listViewController = [[ARListViewController alloc]initWithNibName:@"ARListViewController" bundle:nil];
    [listViewController didUpdateData:arrayPosition];
    [listViewController setListType:0];
    AR2DViewController *cameraViewController = [[AR2DViewController alloc]initWithNibName:@"AR2DViewController" bundle:nil];
    [cameraViewController didUpdateData:arrayPosition];
    AR3DViewController *aR3DViewController = [[AR3DViewController alloc]initWithNibName:@"AR3DViewController" bundle:nil];
    [aR3DViewController didUpdateData:arrayPosition];
    ARMapViewController *mapViewController = [[ARMapViewController alloc]initWithNibName:@"ARMapViewController" bundle:nil];
    [mapViewController didUpdateData:arrayPosition];
    ARSettingViewController *aRSettingViewController = [[ARSettingViewController alloc]initWithNibName:@"ARSettingViewController" bundle:nil];
    
    
    NSMutableArray *viewControllersArray = [[NSMutableArray alloc] init];
    UINavigationController *listNavigation = [[UINavigationController alloc]initWithRootViewController:listViewController];
    UINavigationController *cameraNavigation = [[UINavigationController alloc]initWithRootViewController:cameraViewController];
    UINavigationController *aR3DNavigation = [[UINavigationController alloc]initWithRootViewController:aR3DViewController];
    UINavigationController *mapNavigation = [[UINavigationController alloc]initWithRootViewController:mapViewController];
    UINavigationController *settingNavigation = [[UINavigationController alloc]initWithRootViewController:aRSettingViewController];

    
    [listNavigation.view setFrame:CGRectMake(0, -20, 480, 320)];
    [cameraNavigation.view setFrame:CGRectMake(0, -20, 480, 320)];
    [aR3DNavigation.view setFrame:CGRectMake(0, -20, 480, 320)];
    [mapNavigation.view setFrame:CGRectMake(0, -20, 480, 320)];
    [settingNavigation.view setFrame:CGRectMake(0, -20, 480, 320)];
    
	[viewControllersArray addObject:listNavigation];
    [viewControllersArray addObject:cameraNavigation];
    [viewControllersArray addObject:aR3DNavigation];
	[viewControllersArray addObject:mapNavigation];
    [viewControllersArray addObject:settingNavigation];
    
    
	
	NSMutableArray *tabItemsArray = [[NSMutableArray alloc] init];
	[tabItemsArray addObject:tabItem1];
	[tabItemsArray addObject:tabItem2];
	[tabItemsArray addObject:tabItem3];
    [tabItemsArray addObject:tabItem4];
    [tabItemsArray addObject:tabItem5];
    //
    //
    
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[MenuViewController alloc]initWithTabViewControllers:viewControllersArray tabItems:tabItemsArray initialTab:0];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

}

- (void)setViewConnectFail
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *viewctrl = [[UIViewController alloc]init];
    [viewctrl.view setBackgroundColor:[UIColor blueColor]];
    self.window.rootViewController = viewctrl;
    [self.window makeKeyAndVisible];
}

- (void)getData:(float)radius withPageSize:(int)pageSize withPageIndex:(int)pageIndex withCatagory:(int)catagory  withLanguage:(NSString *)language {
    ArroundPlaceService * dataPlace = [[ArroundPlaceService alloc]init];
    dataPlace.delegate = self;
    [dataPlace getArroundPlaceWithLatitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] radius:radius pageSize:pageSize pageIndex:pageIndex category:catagory language:language];
}


- (void)requestDidFinish:(ArroundPlaceService *)controller withResult:(NSArray *)results
{
    arrayPosition = [NSMutableArray arrayWithArray:results];
    if (arrayPosition.count > 0) {
        [self sortShopByDistance];
        [self setViewConnectSuccess];
    }
    else{
        [self setViewConnectFail];
    }
}

- (void)requestDidFail:(ArroundPlaceService *)controller withError:(NSError *)error
{
    NSLog(@"error : %@",error);
    [self setViewConnectFail];
}

- (void)sortShopByDistance
{
    for (int i = 0; i < [arrayPosition count]; i ++) {
        for (int j = i + 1; j < [arrayPosition count]; j ++) {
            if ([self calculeDistance:[arrayPosition objectAtIndex:i]] > [self calculeDistance:[arrayPosition objectAtIndex:j]])
                [arrayPosition exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
}
- (float)calculeDistance:(InstanceData *)positionEntity{
    
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    float distance = [shoplocation distanceFromLocation: userLocation];
    return distance;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
