//
//  BeNCCameraViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AR2DViewController.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopEntity.h"
#import "BeNCDetailInCamera.h"
#import "ARDetailViewController.h"
#import "ARListViewController.h"
#import "BeNCShopInRadar.h"
#import "BeNCRadar.h"
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
        [self addVideoInput];
        [self getDatabase];
        shopEntity1 = (BeNCShopEntity *)[shopsArray objectAtIndex:0];
        shopEntity2 = (BeNCShopEntity *)[shopsArray objectAtIndex:1];
        shopEntity3 = (BeNCShopEntity *)[shopsArray objectAtIndex:2];
        shopEntity4 = (BeNCShopEntity *)[shopsArray objectAtIndex:3];
        shopEntity5 = (BeNCShopEntity *)[shopsArray objectAtIndex:4];
        
        detaitlView1 = [[BeNCDetailInCamera alloc]initWithShop:shopEntity1];
        detaitlView1.delegate = self;
        [detaitlView1 setIndex:0];
        detaitlView2 = [[BeNCDetailInCamera alloc]initWithShop:shopEntity2];
        detaitlView2.delegate = self;
        [detaitlView2 setIndex:1];
        detaitlView3 = [[BeNCDetailInCamera alloc]initWithShop:shopEntity3];
        detaitlView3.delegate = self;
        [detaitlView3 setIndex:2];
        detaitlView4 = [[BeNCDetailInCamera alloc]initWithShop:shopEntity4];
        detaitlView4.delegate = self;
        [detaitlView4 setIndex:3];
        detaitlView5 = [[BeNCDetailInCamera alloc]initWithShop:shopEntity5];
        detaitlView5.delegate = self;
        [detaitlView5 setIndex:4];

        
        
        [self.view addSubview:detaitlView5];
        [self.view addSubview:detaitlView4];
        [self.view addSubview:detaitlView3];
        [self.view addSubview:detaitlView2];
        [self.view addSubview:detaitlView1];
        BeNCRadar *radar = [[BeNCRadar alloc]init];
        radar.frame = CGRectMake(380, 0, 100, 100);
        [self.view addSubview:radar];
        [radar  release];
    }
    return self;
}

- (void)viewDidLoad
{
    

    [self setTitle:@"AR"];
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


# pragma mark - get Database
- (void )getDatabase
{
    ARListViewController *listViewController = [[ARListViewController alloc]initWithNibName:@"BeNCListViewController" bundle:nil];
    shopsArray = [[[NSMutableArray alloc]initWithArray:listViewController.shopsArray]retain];
    [listViewController release];

}

- (void)getData:(float)radius withPageSize:(int)pageSize withPageIndex:(int)pageIndex withCatagory:(int)catagory  withLanguage:(NSString *)language {
    NSLog(@"user lat = %f, user lng = %f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    ArroundPlaceService * dataPlace = [[ArroundPlaceService alloc]init];
    dataPlace.delegate = self;
    [dataPlace getArroundPlaceWithLatitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] radius:radius pageSize:pageSize pageIndex:pageIndex category:catagory language:language];
}

- (void)requestDidFinish:(ArroundPlaceService *)controller withResult:(NSArray *)results
{
    
    arrayPosition = [[NSMutableArray arrayWithArray:results]retain];
    
    for (int i = 0; i < [arrayPosition count]; i ++) {
        InstanceData *instanceData = (InstanceData *)[arrayPosition objectAtIndex:i];
        NSLog(@"address : %@, lat = %f, lng = %f",instanceData.address,instanceData.latitude,instanceData.longitude);
    }
}


- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    [shoplocation release];
    return distance;
}


#pragma mark - set Content For View


//- (void)setContentForView
//{
//    [arrayShopDistance release];
//    arrayShopDistance = [[NSMutableArray alloc]init];
//    for (int i = 0; i < 5; i ++) {
//
//        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
//        BeNCDetailInCameraViewController *detailView = [[BeNCDetailInCameraViewController alloc]initWithShop:shopEntity];
//        detailView.delegate = self;
//        [detailView setIndex:i];
//        [arrayShopDistance addObject:detailView];
//
//        if (i < 3) {
//            CGRect frame = detailView.view.frame;
//            frame.origin.x =  5;
//            frame.origin.y = 85 * (i % 3) + 5;
//            detailView.view.frame = frame;
//            
//        }
//        
//        else if (i >=3 && i < 5 ) {
//            CGRect frame = detailView.view.frame;
//            frame.origin.x =  480 - frame.size.width -5;
//            frame.origin.y = 103 * (i % 3) + 35;
//            detailView.view.frame = frame;
//        }
//        [self.view addSubview:detailView.view];
//        
//    }
//}
//- (void)deleteData
//{
//    for (int i = 0; i < [arrayShopDistance count]; i ++) {
//        BeNCDetailInCameraViewController *detailView = (BeNCDetailInCameraViewController *)[arrayShopDistance objectAtIndex:i];
//        [detailView.view removeFromSuperview];
//        [detailView release];
//    }
//    [self setContentForView];
//}
//- (void)sortShopByDistance
//{
//    for (int i = 0; i < [shopsArray count]; i ++) {
//        for (int j = i + 1; j < [shopsArray count]; j ++) {
//            if ([self caculateDistanceToShop:[shopsArray objectAtIndex:i]] > [self caculateDistanceToShop:[shopsArray objectAtIndex:j]]) 
//                [shopsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
//        }
//    }
//    [self deleteData];
//}


-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow1 = [self caculateRotationAngle:shopEntity1];
    rotationAngleArrow2 = [self caculateRotationAngle:shopEntity2];
    rotationAngleArrow3 = [self caculateRotationAngle:shopEntity3];
    rotationAngleArrow4 = [self caculateRotationAngle:shopEntity4];
    rotationAngleArrow5 = [self caculateRotationAngle:shopEntity5];
}

-(void)didUpdateHeading:(NSNotification *)notification{

    
    CLHeading *newHeading = [notification object];
    double newAngleToNorth =   newHeading.magneticHeading * rotationRate ;
    float angleToHeading1 = [self caculateRotationAngleToHeading:rotationAngleArrow1 withAngleTonorth:newAngleToNorth];
    float angleToHeading2 = [self caculateRotationAngleToHeading:rotationAngleArrow2 withAngleTonorth:newAngleToNorth];
    float angleToHeading3 = [self caculateRotationAngleToHeading:rotationAngleArrow3 withAngleTonorth:newAngleToNorth];
    float angleToHeading4 = [self caculateRotationAngleToHeading:rotationAngleArrow4 withAngleTonorth:newAngleToNorth];
    float angleToHeading5 = [self caculateRotationAngleToHeading:rotationAngleArrow5 withAngleTonorth:newAngleToNorth];

    [self setNewCenterForView:angleToHeading1 withDetailView:detaitlView1];
    [self setNewCenterForView:angleToHeading2 withDetailView:detaitlView2];
    [self setNewCenterForView:angleToHeading3 withDetailView:detaitlView3];
    [self setNewCenterForView:angleToHeading4 withDetailView:detaitlView4];
    [self setNewCenterForView:angleToHeading5 withDetailView:detaitlView5];

}

- (void)setNewCenterForView:(float )angleToHeading  withDetailView:(BeNCDetailInCamera *)detailViewInCamera{
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
    detailViewInCamera.center = newCenter;
    
}

-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity{
    CLLocation *shopLocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    CLLocationDistance distance = [shopLocation distanceFromLocation:userLocation];
    CLLocation *point =  [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:userLocation.coordinate.longitude];
    CLLocationDistance distance1 = [userLocation distanceFromLocation:point];
    double rotationAngle = 0;
    [shopLocation release];
    [point release];
    
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
    BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:index];
    ARDetailViewController *detailViewController = [[ARDetailViewController alloc] initWithShop:shopEntity];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)dealloc
{
    [captureSession stopRunning];
    [captureSession release];
    [deviceInput release];
    [super dealloc];
}

@end
