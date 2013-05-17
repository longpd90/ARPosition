//
//  BeNCDetailViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
@class BeNCDetailViewController;
@protocol  DetailViewDelegate
-(void)backToMap:(BeNCDetailViewController *)detailView;
@end
@interface BeNCDetailViewController : UIViewController{
    CLLocation *userLocation;
    BeNCShopEntity *shop;
    UILabel *labelDistanceToShop;
}
@property(nonatomic,strong) id<DetailViewDelegate> delegate;
@property(nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain)BeNCShopEntity *shop;
@property(nonatomic, retain)UILabel *labelDistanceToShop;
- (IBAction)goToMenuSite:(id)sender;
- (IBAction)goToCouponSite:(id)sender;
- (IBAction)goToCamera:(id)sender;
- (void)setContentDetailForView:(BeNCShopEntity *)shopEntity;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;

@end
