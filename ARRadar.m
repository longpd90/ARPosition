//
//  BeNCRadarViewController.m
//  ARShop
//
//  Created by Administrator on 1/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ARRadar.h"
#import "LocationService.h"
#import "ARShopInRadar.h"
#import "AR3DViewController.h"
@interface ARRadar ()

@end

@implementation ARRadar
@synthesize userLocation,radiusSearching,shopInRadarArray;

- (id)init
{
    self = [super init];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateRadius:) name:@"UpdateRadius" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateData:) name:@"Updata" object:nil];

        shopInRadarArray = [[NSMutableArray alloc]init];
        self.radiusSearching = 2000;
        
        UIImageView *imageViewRadar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        UIImage *imageRadar = [UIImage imageNamed:@"Radar.png"];
        imageViewRadar.image = imageRadar;
        [self addSubview:imageViewRadar];
        [self setBackgroundColor:[UIColor clearColor]];
        [self removeShopInRadar];

            }
    return self;
}
-(void)didUpdateData:(NSNotification *)notification {
    arrayPosition = (NSMutableArray *)[notification object];
}

-(void)didUpdateRadius:(NSNotification *)notification{
    self.radiusSearching = ([[notification object]intValue] *  1000);
    [self removeShopInRadar];
}

- (void)sortShopInRadar
{
    [arrayPosition removeAllObjects];
    for (int i = 0; i < [arrayPosition count]; i ++) {
        InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:i];
        int distanceToShop = [self caculateDistanceToShop:positionEntity];
        if (distanceToShop <= self.radiusSearching) {
            ARShopInRadar *shopTest = [[ARShopInRadar alloc]initWithShop:positionEntity withRadius:self.radiusSearching];
            [self addSubview:shopTest];
            [shopInRadarArray addObject:shopTest];
        }
    }
}
- (void)removeShopInRadar
{
    for (int i = 0; i < [shopInRadarArray count]; i ++) {
        ARShopInRadar *shopTest = (ARShopInRadar *)[shopInRadarArray objectAtIndex:i];
        [shopTest removeFromSuperview];
    }
    [self sortShopInRadar];
}


//-(void)setcontentForView
//{
//    for (int i = 0; i < [shopInRadarArray count]; i ++) {
//        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopArray objectAtIndex:i];
//        BeNCShopInRadar *shopTest = [[BeNCShopInRadar alloc]initWithShop:shopEntity];
//        [self addSubview:shopTest];
//    }
//}

- (int)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self removeShopInRadar];
}

@end
