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
#import "ARDetailIn2D.h"
#import "ARRadar.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface AR3DViewController : UIViewController{
    AVCaptureSession *captureSession;
    AVCaptureDeviceInput *deviceInput;
//    NSMutableArray *shopsArray;
    NSMutableArray *shopInRadius;
    CLLocation *userLocation ;
//    UISlider *sliderDistance;
//    UILabel *zoomLabel;
    int radiusSearch;
    ARRadar *radar;
    NSMutableArray *arrayPosition;
}
@property (nonatomic, strong)CLLocation *userLocation;
//@property(nonatomic, retain) NSMutableArray *shopsArray;
@property(nonatomic, strong) NSMutableArray *shopInRadius;
- (void)addVideoInput;
//-(void)getDatabase;
- (int)caculateDistanceToShop:(InstanceData *)positionEntity;
//- (IBAction)changeValueSlider:(id)sender;
-(void)setContentForView;
-(void)didUpdateData:(NSMutableArray *)arrayData ;

@end
