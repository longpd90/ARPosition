//
//  BeNCShopInRadar.h
//  ARShop
//
//  Created by Administrator on 1/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface ARShopInRadar : UIImageView{
    CLLocation *userLocation;
    InstanceData *position;
    float distanceToShop;
    double angleRotation;
    CGRect frame;
    int radiusSearching;
}
@property int radiusSearching;
@property(nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain)InstanceData *position;
- (id)initWithShop:(InstanceData *)positionEntity withRadius:(int )radius;
- (float)caculateDistanceToShop:(InstanceData *)positionEntity;
-(double)caculateRotationAngle:(InstanceData * )positionEntity;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle;
//-(void)setFrameForView:(float )angleToHeading;
-(void)setFrameForView:(float )angleToHeading withScaleDistance:(float)scaleDistace;
@end
