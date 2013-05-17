//
//  BeNCDetailInAR3D.m
//  ARShop
//
//  Created by Administrator on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInAR3D.h"
#import "LocationService.h"
#import "BeNCAR3DViewController.h"
#define rotationRate 0.0174532925


@implementation BeNCDetailInAR3D
@synthesize radiusSearching;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        radiusSearching = 2000;
        shop = shopEntity;
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateRadius:) name:@"UpdateRadius" object:nil];
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shopEntity]];
        distanceShop = [self caculateDistanceShop:shopEntity];
        angleRotation = [self caculateRotationAngle:shopEntity];
        [self scaleViewWithDistace];
        [self setContentForView:shopEntity];
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchesToView)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        
    }
    return self;
}
-(void)didUpdateRadius:(NSNotification *)notification{
    self.radiusSearching = ([[notification object]intValue] *  1000);
    distanceShop = [self caculateDistanceShop:shop];

}
- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    float sizeWith = [self calculateSizeFrame:shopEntity];
    self.frame = CGRectMake(0, 0, sizeWith, 30);
    
    detailShop = [[BeNCDetailShopInCamera alloc]initWithShop:shopEntity];
    detailShop.delegate = self;
    detailShop.frame = CGRectMake(0, 0, sizeWith, 30);
    [self addSubview:detailShop];
}

- (void)scaleViewWithDistace
{
    float scaleShop = (235 - distanceShop)/235;
    if (scaleShop < 0.5) {
        scaleShop = 0.5;
    }
    self.transform = CGAffineTransformMakeScale(scaleShop  ,scaleShop );
}
-(void)setFrameForView:(float )angleToHeading
{
    float a = tanf(angleToHeading);
    float b = 235 - 240 * a;
    float newCenterX;
    float newCenterY;
    if (0 <= angleToHeading && angleToHeading <= M_PI) {
        newCenterY = 235 - distanceShop - 33;
    }
    else {
        newCenterY = 250 + distanceShop + 200;
    }
    newCenterX = (newCenterY - b)/a ;
    self.center = CGPointMake(newCenterX, newCenterY);

}

-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle = 0;
    [shopLocation release];
    [point release];
    
    double angle=acos(distance1/distance);
    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
        }
    }
    else{
        if (userLocation.coordinate.longitude<shopEntity.shop_longitute) {
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
- (float)caculateDistanceShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    float distance = (float)[shoplocation distanceFromLocation: self.userLocation];
    float tiLe = 250.0/radiusSearching;
    return distance * tiLe;

}

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    double newAngleToNorth =   newHeading.magneticHeading * rotationRate ;
    float angleToHeading = [self caculateRotationAngleToHeading:angleRotation withAngleTonorth:newAngleToNorth];
    [self setFrameForView:angleToHeading];
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shop]];
    distanceShop = [self caculateDistanceShop:shop];
    angleRotation = [self caculateRotationAngle:shop];
    [self scaleViewWithDistace];

}
@end
