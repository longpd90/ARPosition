//
//  BeNCDetailShopInCamera.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
#import "EGOImageView.h"
#import "RatingView.h"
@class ARDetailPositionInView;
@protocol ARDetailPositionInViewDelegate <NSObject>
- (void)didTouchesToView;
@end
@interface ARDetailPositionInView : UIView<RatingViewDelegate>{
    RatingView *starView;
    UILabel *labelShopName;
    UILabel *labelDistanceToShop;
    CLLocation *userLocation ;
    InstanceData *position;
    EGOImageView *icon;
}
@property (nonatomic, strong) RatingView *starView;
@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong)id<ARDetailPositionInViewDelegate>delegate;
@property (nonatomic, strong)InstanceData *position;
@property(nonatomic, strong)UILabel *labelShopName;
@property(nonatomic, strong)UILabel *labelDistanceToShop;
@property(nonatomic,strong)CLLocation *userLocation ;
- (id)initWithShop:(InstanceData *)positionEntity;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
- (void)setContentDetailShop:(InstanceData *)positionEntity;
@end
