//
//  BeNCDetailShopInCamera.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARDetailPositionInView.h"
#import "LocationService.h"
#import <QuartzCore/QuartzCore.h>
#define textSize 18
#define max 100000

@implementation ARDetailPositionInView
@synthesize labelDistanceToShop,labelShopName;
@synthesize userLocation;
@synthesize delegate,position;

- (id)initWithShop:(InstanceData *)positionEntity
{
    self = [super init];
    if (self) {
        position = positionEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        labelShopName = [[UILabel alloc]init];
        [labelShopName setBackgroundColor:[UIColor clearColor]];
        labelDistanceToShop = [[UILabel alloc]init];
        [labelDistanceToShop setBackgroundColor:[UIColor clearColor]];
        [labelDistanceToShop setTextAlignment:NSTextAlignmentCenter];
        labelDistanceToShop.text = [NSString stringWithFormat:@"%d m",[self caculateDistanceToShop:positionEntity]];

        [self addSubview:labelShopName];
        [self addSubview:labelDistanceToShop];
        [self.layer setCornerRadius:8];
        [self setContentDetailShop:positionEntity];
    }
    return self;
}


- (void)setContentDetailShop:(InstanceData *)positionEntity
{
    [labelDistanceToShop setFont:[UIFont systemFontOfSize:textSize - 4]];
    labelShopName.text = positionEntity.label;
    [labelShopName setFont:[UIFont boldSystemFontOfSize:textSize - 2]];
    [labelShopName setTextAlignment:UITextAlignmentCenter];
    CGSize labelShopNameSize = [positionEntity.label sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = labelShopNameSize.width;     
    
    labelShopName.frame = CGRectMake(3, 0,originLabelDistance,15 );
    labelDistanceToShop.frame = CGRectMake(3, 15,originLabelDistance, 15);
    [self setBackgroundColor:[UIColor whiteColor]];
    
}

- (int)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    labelDistanceToShop.text = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:position]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchesToView)]) {
        [self.delegate didTouchesToView];
    }
}
- (void)dealloc
{
    [position release];
    [labelShopName release];
    [labelDistanceToShop release];
    [userLocation release];
    [super dealloc];
}
@end
