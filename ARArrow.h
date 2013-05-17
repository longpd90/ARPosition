//
//  BeNCArrow.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
#include <CoreLocation/CoreLocation.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface ARArrow : UIImageView<CLLocationManagerDelegate>{
    CLLocation *userLocation;
//    BeNCShopEntity *shop ;
    InstanceData *position;
    double rotationAngleArrow;
}
//@property(nonatomic, retain)BeNCShopEntity *shop;
@property (nonatomic, retain)InstanceData *postion;
- (id)initWithShop:(InstanceData *)positionEntity;
-(double)caculateRotationAngle:(InstanceData * )positionEntity;
@end
