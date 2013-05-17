//
//  BeNCDetailInCameraViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeNCShopEntity.h"
#include <CoreMotion/CoreMotion.h>
#import "BeNCArrow.h"
#import "BeNCDetailShopInCamera.h"
#import <CoreLocation/CoreLocation.h>

@class BeNCDetailInCamera;
@protocol BeNCDetailInCameraDelegate <NSObject>
- (void)didSeclectView:(int )index;
@end
@interface BeNCDetailInCamera : UIView<BeNCDetailShopDelegate,UIGestureRecognizerDelegate>{
    CMMotionManager *motionManager;
    BeNCArrow *arrowImage;
    BeNCDetailShopInCamera *detailShop;
    CLLocation *userLocation;
    BeNCShopEntity *shop;
    int index;
    NSString *distanceToShop;
}
@property int index;
@property(nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain)id<BeNCDetailInCameraDelegate>delegate;
@property(nonatomic, retain)BeNCShopEntity *shop;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
- (void)setContentForView:(BeNCShopEntity *)shopEntity;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
-(float)calculateSizeFrame:(BeNCShopEntity *)shopEntity;

@end
