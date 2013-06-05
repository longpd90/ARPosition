//
//  BeNCGlobal.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARGlobal.h"

@implementation ARGlobal

- (id)init
{
    self = [super init];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
    }
    return self;
}

-(double)caculateRotationAngle:(float )lat withLng:(float)lng{
    CLLocation *positionLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    CLLocationDistance distance = [positionLocation distanceFromLocation:userLocation];
    CLLocation *pointTemp =  [[CLLocation alloc]initWithLatitude:lat longitude:userLocation.coordinate.longitude];
    CLLocationDistance distanceToTemp = [userLocation distanceFromLocation:pointTemp];
    double rotationAngle;
    
    double angle=acos(distanceToTemp/distance);
    if (userLocation.coordinate.latitude<=lat) {
        if (userLocation.coordinate.longitude<=lng) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
        }
    }
    else{
        if (userLocation.coordinate.longitude<lng) {
            rotationAngle = M_PI - angle;
        }
        else{
            rotationAngle = -(M_PI - angle);
        }
    }
    return rotationAngle;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
}
@end
