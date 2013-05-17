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
#import "ARArrow.h"
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
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchesToView)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}


- (void)setContentForView:(InstanceData *)positionEntity
{
    float sizeWith = [self calculateSizeFrame:positionEntity];
    self.frame = CGRectMake(0, 0, sizeWith, 110);
    
    detailShop = [[ARDetailPositionInView alloc]initWithShop:positionEntity];
    detailShop.delegate = self;
    detailShop.frame = CGRectMake(0, 30, sizeWith, 30);
    [self addSubview:detailShop];
    
    arrowImage = [[ARArrow alloc]initWithShop:positionEntity];
    float tdoX = sizeWith/2 - 15;
    arrowImage.frame = CGRectMake(tdoX , 0 , 20, 30);
    [self addSubview:arrowImage];
    
    [self setBackgroundColor:[UIColor clearColor]];
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
-(float)calculateSizeFrame:(InstanceData *)positionEntity
{
    CGSize labelShopNameSize = [positionEntity.label sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    CGSize labelShopAddressSize = [positionEntity.address sizeWithFont:[UIFont systemFontOfSize:textSize - 6] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = MAX(labelShopNameSize.width, labelShopAddressSize.width);      
    CGSize toShopSize = [distanceToShop sizeWithFont:[UIFont systemFontOfSize:textSize - 4] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float sizeWidth = originLabelDistance + toShopSize.width + 7;
    return sizeWidth;

}

- (int)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:position]];
}


- (void)dealloc
{
    [motionManager release];
    [arrowImage release];
    [distanceToShop release];
    [detailShop release];
    [userLocation release];
    [super dealloc];
}


@end
