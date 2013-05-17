//
//  BeNCDetailShopInCamera.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailShopInCamera.h"
#import "BeNCShopEntity.h"
#import "LocationService.h"
#import <QuartzCore/QuartzCore.h>
#define textSize 18
#define max 100000

@implementation BeNCDetailShopInCamera
@synthesize labelDistanceToShop,labelShopName,labelShopAddress,shop;
@synthesize userLocation;
@synthesize delegate;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        labelShopName = [[UILabel alloc]init];
        [labelShopName setBackgroundColor:[UIColor clearColor]];
        labelShopAddress = [[UILabel alloc]init];
        [labelShopAddress setBackgroundColor:[UIColor clearColor]];
        labelDistanceToShop = [[UILabel alloc]init];
        [labelDistanceToShop setBackgroundColor:[UIColor clearColor]];
        labelDistanceToShop.text = [NSString stringWithFormat:@"%d m",[self caculateDistanceToShop:shop]];

        [self addSubview:labelShopName];
        [self addSubview:labelShopAddress];
        [self addSubview:labelDistanceToShop];
        [self.layer setCornerRadius:8];
//        self.alpha = 0.5; 
        [self setContentDetailShop:shopEntity];

        // Initialization code
    }
    return self;
}

//- (void)updateContentDetailShop:(BeNCShopEntity *)shopEntity
//{
//    labelShopName.text = shopEntity.shop_name;
//    [labelShopName setFont:[UIFont boldSystemFontOfSize:textSize]];
//    [labelShopName setTextAlignment:UITextAlignmentCenter];
//    labelShopAddress.text = shopEntity.shop_address;
//    [labelShopAddress setFont:[UIFont systemFontOfSize:textSize-4]];
//    [labelShopAddress setTextAlignment:UITextAlignmentCenter];
//    CGSize labelShopNameSize = [shopEntity.shop_name sizeWithFont:[UIFont boldSystemFontOfSize:textSize] constrainedToSize:CGSizeMake(max, 40) lineBreakMode:UILineBreakModeCharacterWrap];
//    CGSize labelShopAddressSize = [shopEntity.shop_address sizeWithFont:[UIFont systemFontOfSize:textSize - 4] constrainedToSize:CGSizeMake(max, 30) lineBreakMode:UILineBreakModeCharacterWrap];
//    float originLabelDistance = [self caculateMax:labelShopNameSize.width withNumberB:labelShopAddressSize.width];
//    
//    labelShopName.frame = CGRectMake(50, 0,originLabelDistance,25 );
//    labelShopAddress.frame = CGRectMake(50, 20,originLabelDistance,25);
//    labelDistanceToShop.frame = CGRectMake(originLabelDistance + 60, 0, 65, 45);
//    self.frame = CGRectMake(0, 0,originLabelDistance + 125 ,50 );
//    [self setBackgroundColor:[UIColor whiteColor]];
//    
//}

- (void)setContentDetailShop:(BeNCShopEntity *)shopEntity
{
    [labelDistanceToShop setFont:[UIFont systemFontOfSize:textSize - 4]];
    labelShopName.text = shopEntity.shop_name;
    [labelShopName setFont:[UIFont boldSystemFontOfSize:textSize - 2]];
    [labelShopName setTextAlignment:UITextAlignmentCenter];
    labelShopAddress.text = shopEntity.shop_address;
    [labelShopAddress setFont:[UIFont systemFontOfSize:textSize-6]];
    [labelShopAddress setTextAlignment:UITextAlignmentCenter];
    CGSize labelShopNameSize = [shopEntity.shop_name sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    CGSize labelShopAddressSize = [shopEntity.shop_address sizeWithFont:[UIFont systemFontOfSize:textSize - 6] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    float originLabelDistance = MAX(labelShopNameSize.width, labelShopAddressSize.width);     
    CGSize labelToShopSize = [labelDistanceToShop.text sizeWithFont:[UIFont systemFontOfSize:textSize - 4] constrainedToSize:CGSizeMake(max, 15) lineBreakMode:UILineBreakModeCharacterWrap];
    
    labelShopName.frame = CGRectMake(3, 0,originLabelDistance,15 );
    labelShopAddress.frame = CGRectMake(3, 15,originLabelDistance,15);
    labelDistanceToShop.frame = CGRectMake(originLabelDistance + 5, 12,labelToShopSize.width, 15);
//    self.frame = CGRectMake(0, 30,originLabelDistance + labelToShopSize.width + 8 ,30 );
    [self setBackgroundColor:[UIColor whiteColor]];
    
}

- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    labelDistanceToShop.text = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shop]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchesToView)]) {
        [self.delegate didTouchesToView];
    }
}
- (void)dealloc
{
    [shop release];
    [labelShopName release];
    [labelShopAddress release];
    [labelDistanceToShop release];
    [userLocation release];
    [super dealloc];
}
@end
