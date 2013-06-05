//
//  BeNCRadarViewController.h
//  ARShop
//
//  Created by Administrator on 1/16/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface ARRadar:UIView{
    CLLocation *userLocation;
    int radiusSearching;
    NSMutableArray *shopInRadarArray;
    NSMutableArray *arrayPosition;
}
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong)NSMutableArray *shopInRadarArray;
@property int radiusSearching;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
- (void)sortShopInRadar;
- (id)init;
- (void)removeShopInRadar;

@end
