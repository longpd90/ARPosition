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
#import "BeNCDetailInCamera.h"

@interface BeNCCameraViewController : UIViewController<CLLocationManagerDelegate,BeNCDetailInCameraDelegate>{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    NSMutableArray *arrayShopDistance;
    double rotationAngleArrow1;
    double rotationAngleArrow2;
    double rotationAngleArrow3;
    double rotationAngleArrow4;
    double rotationAngleArrow5;
    BeNCShopEntity *shopEntity1;
    BeNCShopEntity *shopEntity2;
    BeNCShopEntity *shopEntity3;
    BeNCShopEntity *shopEntity4;
    BeNCShopEntity *shopEntity5;
    BeNCDetailInCamera *detaitlView1;
    BeNCDetailInCamera *detaitlView2;
    BeNCDetailInCamera *detaitlView3;
    BeNCDetailInCamera *detaitlView4;
    BeNCDetailInCamera *detaitlView5;
}
- (void)addVideoInput;
- (void )getDatabase;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
- (void)setNewCenterForView:(float )angleToHeading  withDetailView:(BeNCDetailInCamera *)detailViewInCamera;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
@end
