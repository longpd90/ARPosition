//
//  BeNCDetailInCameraViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARArrow.h"
#import "ARDetailPositionInView.h"
#import <CoreLocation/CoreLocation.h>

@class ARDetailIn2D;
@protocol ARDetailIn2DDelegate <NSObject>
- (void)didSeclectView:(int )index;
@end
@interface ARDetailIn2D : UIView<ARDetailPositionInViewDelegate,UIGestureRecognizerDelegate>{
    ARArrow *arrowImage;
    ARDetailPositionInView *detailShop;
    CLLocation *userLocation;
    int index;
    NSString *distanceToShop;
    InstanceData *position;
}
@property int index;
@property(nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain)id<ARDetailIn2DDelegate>delegate;
- (id)initWithShop:(InstanceData *)positionEntity;
- (void)setContentForView:(InstanceData *)positionEntity;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
-(float)calculateSizeFrame:(InstanceData *)positionEntity;

@end
