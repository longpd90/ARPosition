//
//  BeNCDetailInCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInCamera.h"
#import "BeNCShopEntity.h"
#import "BeNCArrow.h"
#import "BeNCDetailShopInCamera.h"
#import "BeNCArrow.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationService.h"
#define widthFrame 30
#define heightFrame 45
#define textSize 18
#define max 100000


@interface BeNCDetailInCamera ()

@end

@implementation BeNCDetailInCamera
@synthesize shop,delegate,index,userLocation;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shopEntity]];
        [self setContentForView:shopEntity];
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchesToView)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}


- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    float sizeWith = [self calculateSizeFrame:shopEntity];
    self.frame = CGRectMake(0, 0, sizeWith, 110);
    
    detailShop = [[BeNCDetailShopInCamera alloc]initWithShop:shopEntity];
    detailShop.delegate = self;
    detailShop.frame = CGRectMake(0, 30, sizeWith, 30);
    [self addSubview:detailShop];
    
    arrowImage = [[BeNCArrow alloc]initWithShop:shopEntity];
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
-(float)calculateSizeFrame:(BeNCShopEntity *)shopEntity
{
    CGSize labelShopNameSize = [shopEntity.shop_name sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    CGSize labelShopAddressSize = [shopEntity.shop_address sizeWithFont:[UIFont systemFontOfSize:textSize - 6] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = MAX(labelShopNameSize.width, labelShopAddressSize.width);      
    CGSize toShopSize = [distanceToShop sizeWithFont:[UIFont systemFontOfSize:textSize - 4] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float sizeWidth = originLabelDistance + toShopSize.width + 7;
    return sizeWidth;

}

- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    distanceToShop = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shop]];
}


- (void)dealloc
{
    [motionManager release];
    [shop release];
    [arrowImage release];
    [distanceToShop release];
    [detailShop release];
    [userLocation release];
    [super dealloc];
}


@end
