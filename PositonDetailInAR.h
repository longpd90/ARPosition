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
@interface PositonDetailInAR : UIView{
    UILabel *labelShopName;
    UILabel *labelDistanceToShop;
    
    CLLocation *userLocation ;
    InstanceData *position;
    EGOImageView *icon;
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
