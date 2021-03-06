//
//  BeNCAR3DViewController.h
//  ARShop
//
//  Created by Administrator on 1/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ARRadar.h"
#import "ARDetailIn3D.h"
#import "ARCamera.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface AR3DViewController : UIViewController<ARDetailIn2DDelegate>{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray *shopInRadius;
    CLLocation *userLocation ;
    int radiusSearch;
    ARRadar *radar;
    NSMutableArray *arrayPosition;
    NSMutableArray *arrayShopDistance;
    ARCamera *aRCamera;
}
@property (nonatomic, strong)     NSMutableArray *arrayPosition;
@property (nonatomic, strong)CLLocation *userLocation;
@property(nonatomic, strong) NSMutableArray *shopInRadius;
- (void)addVideoInput;
- (void)deleteData;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
-(void)setContentForView;
-(void)didUpdateData:(NSMutableArray *)arrayData ;

@end
