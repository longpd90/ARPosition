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
@class ARDetailPositionInView;
@protocol ARDetailPositionInViewDelegate <NSObject>
- (void)didTouchesToView;
@end
@interface ARDetailPositionInView : UIView{
    UILabel *labelShopName;
    UILabel *labelDistanceToShop;
    CLLocation *userLocation ;
    InstanceData *position;
}
@property (nonatomic, retain) UIImageView *imageViewBackground;
@property (nonatomic, retain)id<ARDetailPositionInViewDelegate>delegate;
@property (nonatomic, retain)InstanceData *position;
@property(nonatomic, retain)UILabel *labelShopName;
@property(nonatomic, retain)UILabel *labelDistanceToShop;
@property(nonatomic,retain)CLLocation *userLocation ;
- (id)initWithShop:(InstanceData *)positionEntity;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
- (void)setContentDetailShop:(InstanceData *)positionEntity;
@end
