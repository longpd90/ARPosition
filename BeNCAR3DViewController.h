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
#import "BeNCDetailInCamera.h"
#import "BeNCRadar.h"
@interface BeNCAR3DViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
    NSMutableArray *shopsArray;
    NSMutableArray *shopInRadius;
    CLLocation *userLocation ;
    UISlider *sliderDistance;
    UILabel *zoomLabel;
    int radiusSearch;
    BeNCRadar *radar;
}
@property (nonatomic, retain)CLLocation *userLocation;
@property(nonatomic, retain) NSMutableArray *shopsArray;
@property(nonatomic, retain) NSMutableArray *shopInRadius;
- (void)addVideoInput;
-(void)getDatabase;
- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity;
- (IBAction)changeValueSlider:(id)sender;
-(void)setContentForView;

@end
