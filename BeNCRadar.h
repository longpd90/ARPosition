//
//  BeNCRadarViewController.h
//  ARShop
//
//  Created by Administrator on 1/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"

@interface BeNCRadar:UIView{
    NSArray *shopArray;
    CLLocation *userLocation;
    int radiusSearching;
    NSMutableArray *shopInRadarArray;

}
@property (nonatomic, retain) CLLocation *userLocation;
@property (nonatomic, retain)NSMutableArray *shopInRadarArray;
@property int radiusSearching;
@property (nonatomic, retain)NSArray *shopArray;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
- (void)sortShopInRadar;
-(void)getDatasebase;
- (id)init;
- (void)removeShopInRadar;

@end
