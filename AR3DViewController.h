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
#import "BeNCShopEntity.h"
#import "ARDetailIn2D.h"
#import "BeNCRadar.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface AR3DViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
//    NSMutableArray *shopsArray;
    NSMutableArray *shopInRadius;
    CLLocation *userLocation ;
    UISlider *sliderDistance;
    UILabel *zoomLabel;
    int radiusSearch;
    BeNCRadar *radar;
    NSMutableArray *arrayPosition;
}
@property (nonatomic, retain)CLLocation *userLocation;
//@property(nonatomic, retain) NSMutableArray *shopsArray;
@property(nonatomic, retain) NSMutableArray *shopInRadius;
- (void)addVideoInput;
//-(void)getDatabase;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
- (IBAction)changeValueSlider:(id)sender;
-(void)setContentForView;

@end
