//
//  BeNCRadarViewController.m
//  ARShop
//
//  Created by Administrator on 1/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCRadar.h"
#import "BeNCShopEntity.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopInRadar.h"
#import "BeNCAR3DViewController.h"
@interface BeNCRadar ()

@end

@implementation BeNCRadar
@synthesize shopArray,userLocation,radiusSearching,shopInRadarArray;

- (id)init
{
    self = [super init];
    if (self) {
        [self getDatasebase];
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateRadius:) name:@"UpdateRadius" object:nil];

        shopInRadarArray = [[[NSMutableArray alloc]init]retain];
        self.radiusSearching = 2000;
        
        UIImageView *imageViewRadar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        UIImage *imageRadar = [UIImage imageNamed:@"Radar.png"];
        imageViewRadar.image = imageRadar;
        [self addSubview:imageViewRadar];
        [self setBackgroundColor:[UIColor clearColor]];
        [self removeShopInRadar];
        [imageViewRadar release];

            }
    return self;
}
-(void)getDatasebase
{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    self.shopArray = [[BeNCProcessDatabase sharedMyDatabase] arrayShop];
}
-(void)didUpdateRadius:(NSNotification *)notification{
    self.radiusSearching = ([[notification object]intValue] *  1000);
    [self removeShopInRadar];
}

- (void)sortShopInRadar
{
    [shopInRadarArray removeAllObjects];
    for (int i = 0; i < [shopArray count]; i ++) {
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopArray objectAtIndex:i];
        int distanceToShop = [self caculateDistanceToShop:shopEntity];
        if (distanceToShop <= self.radiusSearching) {
            BeNCShopInRadar *shopTest = [[BeNCShopInRadar alloc]initWithShop:shopEntity withRadius:self.radiusSearching];
            [self addSubview:shopTest];
            [shopInRadarArray addObject:shopTest];
            [shopTest release];
        }
    }
}
- (void)removeShopInRadar
{
    for (int i = 0; i < [shopInRadarArray count]; i ++) {
        BeNCShopInRadar *shopTest = (BeNCShopInRadar *)[shopInRadarArray objectAtIndex:i];
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
    [self removeShopInRadar];
}
- (void)dealloc
{
    [shopInRadarArray release];
    [super dealloc];
}

@end
