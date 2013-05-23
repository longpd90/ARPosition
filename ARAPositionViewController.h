//
//  BeNCOneShopARViewController.h
//  ARShop
//
//  Created by Administrator on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARDetailIn2D.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
#import "ARArrow.h"
#import "PositonDetailInAR.h"
@interface ARAPositionViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    CLLocation *userLocation ;
    double rotationAngleArrow;
    InstanceData *position;
//    ARDetailIn2D *detailView;
    ARArrow *arrowView;
    
    float centerX;
    float centerY;
}
@property(nonatomic, retain)InstanceData *position;
@property double rotationAngleArrow;
@property(nonatomic, retain) CLLocation *userLocation;
- (void)addVideoInput;
- (void)setContentForView:(InstanceData *)positionEntity;
- (id)initWithShop:(InstanceData *)positionEntity;
-(double)caculateRotationAngle:(InstanceData * )positionEntity;
@end
