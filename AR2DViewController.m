//
//  BeNCCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AR2DViewController.h"
#import "LocationService.h"
#import "ARDetailIn2D.h"
#import "ARDetailViewController.h"
#import "ARListViewController.h"
#import "ARShopInRadar.h"
#import "ARRadar.h"
#define rotationRate 0.0174532925

@interface AR2DViewController ()

@end

@implementation AR2DViewController
@synthesize arrayPosition;

#pragma mark - View Cycle Life
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userLocation = [[LocationService sharedLocation] getOldLocation];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateData:) name:@"Updata" object:nil];

        [self addVideoInput];
//        [self getDatabase];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewDidLoad
{
    self.view.bounds = CGRectMake(0, 0, 480, 320);
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


# pragma mark - add Video to App
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



#pragma mark - set Content For View

-(void)didUpdateData:(NSMutableArray *)arrayData {
    arrayPosition = arrayData;
    [self setContentForView];
}

- (void)setContentForView
{
    arrayShopDistance = nil;
    for (int i = 0; i < 5; i ++) {

        InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:i];
        ARDetailIn2D *detailView = [[ARDetailIn2D alloc]initWithShop:positionEntity];
        detailView.delegate = self;
        [detailView setIndex:i];
        [arrayShopDistance addObject:detailView];

        if (i < 3) {
            CGRect frame = detailView.frame;
            frame.origin.x =  5;
            frame.origin.y = 85 * (i % 3) + 5;
            detailView.frame = frame;
        }
        
        else if (i >=3 && i < 5 ) {
            NSLog(@"x = %f, y = %f",detailView.frame.size.width,detailView.frame.size.height);
            CGRect frame = detailView.frame;
            frame.origin.x =  480 - frame.size.width - 2;
            frame.origin.y = 103 * (i % 3) + 35;
            detailView.frame = frame;
        }
        [self.view addSubview:detailView];
        
    }
}
- (void)deleteData
{
    for (int i = 0; i < [arrayShopDistance count]; i ++) {
        AR2DViewController *detailView = (AR2DViewController *)[arrayShopDistance objectAtIndex:i];
        [detailView.view removeFromSuperview];
        detailView = nil;
        [arrayShopDistance removeAllObjects];
    }
    [self setContentForView];
}


-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
//    rotationAngleArrow1 = [self caculateRotationAngle:positionEntity1];
//    rotationAngleArrow2 = [self caculateRotationAngle:positionEntity2];
//    rotationAngleArrow3 = [self caculateRotationAngle:positionEntity3];
//    rotationAngleArrow4 = [self caculateRotationAngle:positionEntity4];
//    rotationAngleArrow5 = [self caculateRotationAngle:positionEntity5];
}

-(void)didUpdateHeading:(NSNotification *)notification{

    
    CLHeading *newHeading = [notification object];
//    double newAngleToNorth =   newHeading.magneticHeading * rotationRate ;
//    float angleToHeading1 = [self caculateRotationAngleToHeading:rotationAngleArrow1 withAngleTonorth:newAngleToNorth];
//    float angleToHeading2 = [self caculateRotationAngleToHeading:rotationAngleArrow2 withAngleTonorth:newAngleToNorth];
//    float angleToHeading3 = [self caculateRotationAngleToHeading:rotationAngleArrow3 withAngleTonorth:newAngleToNorth];
//    float angleToHeading4 = [self caculateRotationAngleToHeading:rotationAngleArrow4 withAngleTonorth:newAngleToNorth];
//    float angleToHeading5 = [self caculateRotationAngleToHeading:rotationAngleArrow5 withAngleTonorth:newAngleToNorth];
//
//    [self setNewCenterForView:angleToHeading1 withDetailView:detaitlView1];
//    [self setNewCenterForView:angleToHeading2 withDetailView:detaitlView2];
//    [self setNewCenterForView:angleToHeading3 withDetailView:detaitlView3];
//    [self setNewCenterForView:angleToHeading4 withDetailView:detaitlView4];
//    [self setNewCenterForView:angleToHeading5 withDetailView:detaitlView5];

}

- (void) setupContentView
{
    positionEntity1 = (InstanceData *)[arrayPosition objectAtIndex:0];
    positionEntity2 = (InstanceData *)[arrayPosition objectAtIndex:1];
    positionEntity3 = (InstanceData *)[arrayPosition objectAtIndex:2];
    positionEntity4 = (InstanceData *)[arrayPosition objectAtIndex:3];
    positionEntity5 = (InstanceData *)[arrayPosition objectAtIndex:4];
    
    
    
    detaitlView1 = [[ARDetailIn2D alloc]initWithShop:positionEntity1];
    detaitlView1.delegate = self;
    [detaitlView1 setIndex:0];
    detaitlView2 = [[ARDetailIn2D alloc]initWithShop:positionEntity2];
    detaitlView2.delegate = self;
    [detaitlView2 setIndex:1];
    detaitlView3 = [[ARDetailIn2D alloc]initWithShop:positionEntity3];
    detaitlView3.delegate = self;
    [detaitlView3 setIndex:2];
    detaitlView4 = [[ARDetailIn2D alloc]initWithShop:positionEntity4];
    detaitlView4.delegate = self;
    [detaitlView4 setIndex:3];
    detaitlView5 = [[ARDetailIn2D alloc]initWithShop:positionEntity5];
    detaitlView5.delegate = self;
    [detaitlView5 setIndex:4];
    
    
    
    [self.view addSubview:detaitlView5];
    [self.view addSubview:detaitlView4];
    [self.view addSubview:detaitlView3];
    [self.view addSubview:detaitlView2];
    [self.view addSubview:detaitlView1];
    //    ARRadar *radar = [[ARRadar alloc]init];
    //    radar.frame = CGRectMake(380, 0, 100, 100);
    //    [self.view addSubview:radar];
    //    [radar  release];
}
- (void)setNewCenterForView:(float )angleToHeading  withDetailView:(ARDetailIn2D *)detailViewInCamera{
    float originX = detailViewInCamera.frame.size.width/2;
    float originY = detailViewInCamera.frame.size.height/2;
    float angle1 = atanf(125.0/240.0);
    float angle2 = M_PI - angle1;
    float a = tan(angleToHeading);
    float b = 125 - 240 * a ;
    float valueX = 0;
    float valueY = 0;
    if ((0 <= angleToHeading && angleToHeading < angle1 )||( - angle1 <= angleToHeading && angleToHeading < 0)) {
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
        valueY = 300 - originY;
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
    if (valueY > 300 - originY ) {
        valueY = 300 - originY;
    }
    CGPoint newCenter = CGPointMake(valueX, valueY);
    detailViewInCamera.center = newCenter;
    
}

-(double)caculateRotationAngle:(InstanceData * )positionEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle;
    
    double angle=acos(distance1/distance);
    if (userLocation.coordinate.latitude <= positionEntity.latitude) {
        if (userLocation.coordinate.longitude <= positionEntity.longitude) {
            rotationAngle = angle;
        }
        else{
            rotationAngle = - angle;
        }
    }
    else{
        if (userLocation.coordinate.longitude < positionEntity.longitude) {
            rotationAngle = M_PI - angle;
        }
        else{
            rotationAngle = -(M_PI - angle);
        }
    }
    return rotationAngle;
}

-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth
{
    float angleToHeading = 0;
    if (angleToShop >= 0) {
        angleToHeading = angleToShop - angleToNorth;
        if (angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI - (angleToNorth - angleToShop);
        }
    }
    else if (angleToShop < 0){
        angleToHeading =  angleToShop - angleToNorth;
        
        if ( angleToHeading < - M_PI) {
            angleToHeading = 2 * M_PI + angleToHeading;
        }
    }
    return angleToHeading;

}

- (void)didSeclectView:(int)index
{
    InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:index];
     ARAPositionViewController *detailViewController = [[ARAPositionViewController alloc] initWithShop:positionEntity];
    [self.navigationController pushViewController:detailViewController animated:YES];
}



@end
