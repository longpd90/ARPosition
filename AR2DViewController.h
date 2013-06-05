//
//  BeNCCameraViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARDetailIn2D.h"
#import "ARAPositionViewController.h"
#import <ArroundPlaceService/ArroundPlaceService.h>

@interface AR2DViewController : UIViewController<CLLocationManagerDelegate,ARDetailIn2DDelegate>{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    CLLocation *userLocation ;
    NSMutableArray *arrayShopDistance;
    double rotationAngleArrow1;
    double rotationAngleArrow2;
    double rotationAngleArrow3;
    double rotationAngleArrow4;
    double rotationAngleArrow5;
    InstanceData *positionEntity1;
    InstanceData *positionEntity2;
    InstanceData *positionEntity3;
    InstanceData *positionEntity4;
    InstanceData *positionEntity5;

    ARDetailIn2D *detaitlView1;
    ARDetailIn2D *detaitlView2;
    ARDetailIn2D *detaitlView3;
    ARDetailIn2D *detaitlView4;
    ARDetailIn2D *detaitlView5;
}
@property (nonatomic, strong) NSMutableArray *arrayPosition;
- (void)addVideoInput;
//- (void )getDatabase;
-(double)caculateRotationAngle:(InstanceData * )positionEntity;
- (void)setNewCenterForView:(float )angleToHeading  withDetailView:(ARDetailIn2D *)detailViewInCamera;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
-(void)didUpdateData:(NSMutableArray *)arrayData ;

@end
