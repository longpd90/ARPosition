//
//  BeNCShopInRadar.m
//  ARShop
//
//  Created by Administrator on 1/17/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ARShopInRadar.h"
#import "LocationService.h"
#import "AR3DViewController.h"
#import <math.h>
#define rotationRate 0.0174532925


@implementation ARShopInRadar
@synthesize userLocation,position,radiusSearching;
- (id)initWithShop:(InstanceData *)positionEntity withRadius:(int )radius
{
    self = [super init];
    if (self) {
        position = positionEntity;
        radiusSearching = radius;
        frame.size.width = 5;
        frame.size.height = 5;
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        distanceToShop = [self caculateDistanceToShop:positionEntity];
        angleRotation = [self caculateRotationAngle:positionEntity];
        UIImage *arrowImage = [UIImage imageNamed:@"ShopInRadar.png"];
        self.image = arrowImage;
           }
    return self;
}
 
-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    double newAngleToNorth =   newHeading.magneticHeading * rotationRate ;
    float angleToHeading = [self caculateRotationAngleToHeading:angleRotation withAngleTonorth:newAngleToNorth];
    [self setFrameForView:angleToHeading withScaleDistance:distanceToShop];
}
//-(void)didUpdateLocation:(NSNotification *)notification {
//    CLLocation *newLocation = (CLLocation *)[notification object];
//    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    distanceToShop = [self caculateDistanceToShop:position];
//    angleRotation = [self caculateRotationAngle:position];
//}

-(void)setFrameForView:(float )angleToHeading withScaleDistance:(float)scaleDistace
{
    float a = tanf(angleToHeading);
    float b = 50 - 50 * a;
    float indexA = (1 + a * a);
    float indexB = (2 * a * b - 100 - 100 * a);
    float indexC = (5000 - 100 * b + b * b - scaleDistace * scaleDistace );
    float originX = [self giaiPhuongTrinhB2:indexA withIndexB:indexB withIndexC:indexC withAngle:angleToHeading];
    float originY = a * originX + b;
    frame.origin.x = originX;
    frame.origin.y = originY;
    self.frame = frame;
}

- (float)giaiPhuongTrinhB2:(float )a withIndexB:(float)b withIndexC:(float )c withAngle:(float)angle
{
    float x;
    float delta = (b * b) - ( 4 * a * c );
    float x1;
    float x2;
    x1 = (- b +  (sqrtf(delta))) / (2 * a);
    x2 = (- b -  (sqrtf(delta))) / (2 * a);
    if ((M_PI_2 <= angle && angle <= M_PI ) || (-M_PI <= angle && angle <= -M_PI_2)) {
         x = MAX(x1, x2);
    }
    else {
        x = MIN(x1, x2);
    }
    return x;

}
- (float)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    float distance = (float)[shoplocation distanceFromLocation:self.userLocation];
    float tiLe = 50.0/radiusSearching;
    return distance * tiLe;
}

-(double)caculateRotationAngle:(InstanceData * )positionEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle;
    
    double angle=acos(distance1/distance);
    if (userLocation.coordinate.latitude <= positionEntity.latitude) {
        if (userLocation.coordinate.longitude <= positionEntity.longitude) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
        }
    }
    else{
        if (userLocation.coordinate.longitude < positionEntity.longitude) {
            rotationAngle = M_PI - angle;
        }
        else{
            rotationAngle = -(M_PI - angle);
        }
    }
    return rotationAngle;
}

-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth
{
    float angleToHeading = 0;
    if (angleToShop >= 0) {
        angleToHeading = angleToShop - angleToNorth;
        if (angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI - (angleToNorth - angleToShop);
        }
    }
    else if (angleToShop < 0){
        angleToHeading =  angleToShop - angleToNorth;
        
        if ( angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI + angleToHeading;
        }
    }
    return angleToHeading;
}


@end
