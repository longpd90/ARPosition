//
//  BeNCOneShopARViewController.m
//  ARShop
//
//  Created by Administrator on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCOneShopARViewController.h"
#import "BeNCShopEntity.h"
#import "BeNCDetailInCamera.h"
#import "LocationService.h"
#import <math.h>
#define rotationRate 0.0174532925
#define frameRadius 60

@interface BeNCOneShopARViewController ()

@end

@implementation BeNCOneShopARViewController
@synthesize userLocation,shop,rotationAngleArrow;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        shop = shopEntity;
        self.userLocation = [[LocationService sharedLocation]getOldLocation]; 
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        rotationAngleArrow = [self caculateRotationAngle:shop];
        [self setContentForView:shopEntity];

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [self addVideoInput];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)addVideoInput {
    captureSession = [[AVCaptureSession alloc]init];
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.frame = CGRectMake(0, 0, 480, 320);
    [previewLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer addSublayer:previewLayer];
    NSError *error = nil;
    AVCaptureDevice * camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    if ([captureSession canAddInput:deviceInput])
        [captureSession addInput:deviceInput];
    [captureSession startRunning];    
}
- (void)setContentForView:(BeNCShopEntity *)shopEntity
{
    detailView = [[BeNCDetailInCamera alloc]initWithShop:shopEntity];
    [self.view addSubview:detailView];
}
- (void)setNewCenterForView:(float )angleToHeading{
    float originX = detailView.frame.size.width/2;
    float originY = detailView.frame.size.height/2;
    float angle1 = atanf(125.0/240.0);
    float angle2 = M_PI - angle1;
    float a = tan(angleToHeading);
    float b = 125 - 240 * a ;
    float valueX = 0;
    float valueY = 0;
    if ((0 <= angleToHeading && angleToHeading < angle1 )||( angleToHeading < 0 &&   -angle1 < angleToHeading)) {
        valueX = originX;
        valueY =  b;
       }
    else if (angle1 <= angleToHeading && angleToHeading< angle2){
            valueX =   - b / a ;
            valueY = originY;
    }
    else if ((angle2 <= angleToHeading && angleToHeading < M_PI) || (- M_PI <= angleToHeading && angleToHeading < - angle2)) {
            valueX = 480 - originX;
            valueY = 480 * a + b;
    }
    else if (- angle2 <= angleToHeading && angleToHeading <  - angle1) {
            valueX = ( 250 -b )/a;
            valueY = 288 - originY;
    }
    if (valueX <= originX) {
        valueX = originX;
    }
    if (valueX > 480 - originX ) {
        valueX = 480 - originX ;
    }
    if (valueY <= originY) {
        valueY = originY;
    }
    if (valueY > 288 - originY ) {
        valueY = 288 - originY;
    }
    CGPoint newCenter = CGPointMake(valueX, valueY);
    detailView.center = newCenter;

}

-(void)didUpdateHeading:(NSNotification *)notification{
    CLHeading *newHeading = [notification object];
    float angleToHeading = 0.0;
    double angleToNorth =   newHeading.magneticHeading * rotationRate ;
    if (rotationAngleArrow >= 0) {
        angleToHeading = rotationAngleArrow - angleToNorth;
        if (angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI - (angleToNorth - rotationAngleArrow);
        }
    }
    else if (rotationAngleArrow < 0){
        angleToHeading =  rotationAngleArrow - angleToNorth;
        
        if ( angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI + angleToHeading;
        }
        
    }
    [self setNewCenterForView:angleToHeading];

}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow = [self caculateRotationAngle:shop];
}
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle;
    
    double angle=acos(distance1/distance);
    if (userLocation.coordinate.latitude<=shopEntity.shop_latitude) {
        if (userLocation.coordinate.longitude<=shopEntity.shop_longitute) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
        }
    }
    else{
        if (userLocation.coordinate.longitude<shopEntity.shop_longitute) {
            rotationAngle = M_PI - angle;
        }
        else{
            rotationAngle = -(M_PI - angle);
        }
    }
    return rotationAngle;
}


@end
