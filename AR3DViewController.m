//
//  BeNCAR3DViewController.m
//  ARShop
//
//  Created by Administrator on 1/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AR3DViewController.h"
#import "LocationService.h"
#import "ARDetailIn2D.h"
#import "ARRadar.h"
#import "ARAPositionViewController.h"
#define rotationRate 0.0174532925

@interface AR3DViewController ()

@end

@implementation AR3DViewController
@synthesize userLocation,shopInRadius;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateData:) name:@"Updata" object:nil];
//        radar = [[ARRadar alloc]init];
//        radar.frame = CGRectMake(380, 0, 100, 100);
//        [self.view addSubview:radar];
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateNewData:) name:@"UpdateData" object:nil];
    arrayShopDistance = [[NSMutableArray alloc]init];
    shopInRadius = [[NSMutableArray alloc]init];
    self.view.bounds = CGRectMake(0, 0, 480, 320);        
    [self addVideoInput];
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
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



-(void)didUpdateData:(NSMutableArray *)arrayData {
    arrayPosition = arrayData;
    [self deleteData];
}

-(void)didUpdateNewData:(NSNotification *)notification {
    [arrayPosition removeAllObjects];
    arrayPosition = nil;
    arrayPosition = (NSMutableArray *)[notification object];
    [self deleteData];
}
- (void)deleteData
{
    for (int i = 0; i < [arrayShopDistance count]; i ++) {
        ARDetailIn3D *detailView = (ARDetailIn3D *)[arrayShopDistance objectAtIndex:i];
        [detailView removeFromSuperview];
        detailView = nil;
    }
    [arrayShopDistance removeAllObjects];
    arrayShopDistance = nil;
    [self setContentForView];
}

-(void)setContentForView
{
    arrayShopDistance = nil;
    for (int i = 0; i < [arrayPosition count]; i ++) {
        InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:i];
        
        ARDetailIn3D *testView = [[ARDetailIn3D alloc]initWithShop:positionEntity];
        [arrayShopDistance addObject:testView];
        
        testView.delegate = self;
        [testView setIndex:i];
        [self.view addSubview:testView];
        
    }
}

- (int)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}


- (void)didSeclectView:(int)index
{
    InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:index];
    ARAPositionViewController *detailViewController = [[ARAPositionViewController alloc] initWithShop:positionEntity];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
