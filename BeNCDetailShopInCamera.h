//
//  BeNCDetailShopInCamera.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeNCShopEntity.h"
#import <CoreLocation/CoreLocation.h>
@class BeNCDetailShopInCamera;
@protocol BeNCDetailShopDelegate <NSObject>
- (void)didTouchesToView;
@end
@interface BeNCDetailShopInCamera : UIView{
    UILabel *labelShopName;
    UILabel *labelShopAddress;
    UILabel *labelDistanceToShop;
    CLLocation *userLocation ;
    BeNCShopEntity *shop;
}
@property (nonatomic, retain)id<BeNCDetailShopDelegate>delegate;
@property(nonatomic, retain)BeNCShopEntity *shop;
@property(nonatomic, retain)UILabel *labelShopName;
@property(nonatomic, retain)UILabel *labelShopAddress;
@property(nonatomic, retain)UILabel *labelDistanceToShop;
@property(nonatomic,retain)CLLocation *userLocation ;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
//- (float)caculateMax:(float )numberA withNumberB:(float )numberB;
- (void)setContentDetailShop:(BeNCShopEntity *)shopEntity;
@end
