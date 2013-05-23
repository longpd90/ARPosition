//
//  BeNCArrow.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARArrow.h"
#import "LocationService.h"
#import <math.h>
#define rotationRate 0.0174532925


@implementation ARArrow
@synthesize postion;

- (id)initWithShop:(InstanceData *)positionEntity
{
    self = [super init];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];
        position = positionEntity;
        rotationAngleArrow = [self caculateRotationAngle:positionEntity];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        UIImage *imageBackgroud = [UIImage imageNamed:@"cricle.png"];
        UIImageView *imageViewBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        imageViewBackground.image = imageBackgroud;
        [self addSubview:imageViewBackground];

        UIImage *arrowImage = [UIImage imageNamed:@"arrow.png"];
        arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 20, 45)];
        arrowImageView.image = arrowImage;
        [self addSubview:arrowImageView];
        self.frame = CGRectMake(0,0,60, 60);
    }
    return self;
}

-(double)caculateRotationAngle:(InstanceData * )positionEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    [shopLocation release];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    [point release];
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

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    arrowImageView.transform = CGAffineTransformMakeRotation( - newHeading.magneticHeading * rotationRate - M_PI_2 +rotationAngleArrow);
}
-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow = [self caculateRotationAngle:position];
}

- (void)dealloc
{
    [postion release];
    [userLocation release];
    [super dealloc];
}
@end
