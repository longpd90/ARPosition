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
@interface BeNCArrow : UIImageView<CLLocationManagerDelegate>{
    CLLocation *userLocation;
    BeNCShopEntity *shop ;
    double rotationAngleArrow;
}
@property(nonatomic, retain)BeNCShopEntity *shop;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
@end
