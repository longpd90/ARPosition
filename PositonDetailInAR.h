//
//  PositonDetailInAR.h
//  ARPosition
//
//  Created by Duc Long on 5/23/13.
//
//

#import <UIKit/UIKit.h>
#import "ARDetailPositionInView.h"
#import "LocationService.h"
#import <QuartzCore/QuartzCore.h>
#import <ArroundPlaceService/ArroundPlaceService.h>
#import "RatingView.h"
@interface PositonDetailInAR : UIView<RatingViewDelegate>{
    UILabel *labelShopName;
    UILabel *labelDistanceToShop;
    
    CLLocation *userLocation ;
    InstanceData *position;
    EGOImageView *icon;
    RatingView *starView;
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
