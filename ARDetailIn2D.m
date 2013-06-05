//
//  BeNCDetailInCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARDetailIn2D.h"
#import "ARArrow.h"
#import "ARDetailPositionInView.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationService.h"
#define widthFrame 30
#define heightFrame 45
#define textSize 18
#define max 100000


@interface ARDetailIn2D ()

@end

@implementation ARDetailIn2D
@synthesize delegate,index,userLocation;

- (id)initWithShop:(InstanceData *)positionEntity
{
    self = [super init];
    if (self) {

        position = positionEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:positionEntity]];
        [self setContentForView:positionEntity];
    }
    return self;
}


- (void)setContentForView:(InstanceData *)positionEntity
{
    float sizeWith = [self calculateSizeFrame:positionEntity];
    self.frame = CGRectMake(0, 0, sizeWith + 50, 50);
    
    detailShop = [[ARDetailPositionInView alloc]initWithShop:positionEntity];
    detailShop.delegate = self;
    detailShop.frame = CGRectMake(0, 0, sizeWith + 53, 50);
    [self addSubview:detailShop];
    
//    arrowImage = [[ARArrow alloc]initWithShop:positionEntity];
//    float tdoX = sizeWith/2 - 15;
//    arrowImage.frame = CGRectMake(tdoX , 0 , 60, 60);
//    [self addSubview:arrowImage];
    
    [self setBackgroundColor:[UIColor blueColor]];
}

-(float)calculateSizeFrame:(InstanceData *)positionEntity
{
    CGSize labelShopNameSize = [positionEntity.label sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(max, 25) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = MAX(labelShopNameSize.width, 190);
    float sizeWidth = originLabelDistance + 7;
    return sizeWidth;
}

-(void)setIndexForView:(int )aIndex
{
    index = aIndex;
}
- (void)didTouchesToView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeclectView:)]) {
        [self.delegate didSeclectView:self.index];
    }
}

- (int)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:position]];
}




@end
