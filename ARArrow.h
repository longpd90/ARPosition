//
//  BeNCArrow.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include <CoreLocation/CoreLocation.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface ARArrow : UIView<CLLocationManagerDelegate>{
    CLLocation *userLocation;
    InstanceData *position;
    double rotationAngleArrow;
    UIImageView *arrowImageView;
}
@property (nonatomic, retain)InstanceData *postion;
- (id)initWithShop:(InstanceData *)positionEntity;
-(double)caculateRotationAngle:(InstanceData * )positionEntity;
@end
