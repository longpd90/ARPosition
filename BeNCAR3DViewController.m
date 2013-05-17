//
//  BeNCAR3DViewController.m
//  ARShop
//
//  Created by Administrator on 1/18/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCAR3DViewController.h"
#import "LocationService.h"
#import "BeNCShopEntity.h"
#import "BeNCProcessDatabase.h"
#import "BeNCDetailInCamera.h"
#import "BeNCDetailInAR3D.h"
#import "BeNCRadar.h"
#define rotationRate 0.0174532925

@interface BeNCAR3DViewController ()

@end

@implementation BeNCAR3DViewController
@synthesize shopsArray,userLocation,shopInRadius;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self getDatabase];
        radar = [[BeNCRadar alloc]init];
        radar.frame = CGRectMake(380, 0, 100, 100);
        [self.view addSubview:radar];

    }
    return self;
}

- (void)viewDidLoad
{
    shopInRadius = [[NSMutableArray alloc]init];
    [self setTitle:@"AR 3D"];
    self.view.bounds = CGRectMake(0, 0, 480, 320);        
    [self addVideoInput];
    sliderDistance = [[UISlider alloc]initWithFrame:CGRectMake(-40, 120, 150, 20)];
    sliderDistance.maximumValue = 10;
    sliderDistance.value = 2;
    sliderDistance.minimumValue = 1;
    [sliderDistance addTarget:self action:@selector(changeValueSlider:) forControlEvents:UIControlEventValueChanged];
    sliderDistance.transform = CGAffineTransformMakeRotation(- M_PI_2);
    [self.view addSubview:sliderDistance];
    zoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, 60, 20)];
    zoomLabel.text = [NSString stringWithFormat:@"2km"];
    zoomLabel.textColor = [UIColor whiteColor];
    zoomLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:zoomLabel];
    
    [self setContentForView];
    [super viewDidLoad];
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
-(void)getDatabase{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
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
-(void)setContentForView
{
    for (int i = 0; i < [shopsArray count]; i ++) {
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        BeNCDetailInAR3D *testView = [[BeNCDetailInAR3D alloc]initWithShop:shopEntity];
        [self.view addSubview:testView];
        [testView release];
        
    }
}

//- (void)deleteData
//{
//    for (int i = 0; i < [shopInRadius count]; i ++) {
//        BeNCDetailInAR3D *detailView = (BeNCDetailInAR3D *)[shopInRadius objectAtIndex:i];
//        [detailView removeFromSuperview];
//        [detailView release];
//    }
////    [self setContentForView];
//}
//
//
//-(void)setContentForView
//{
//    
//}

- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute]autorelease];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

- (IBAction)changeValueSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int valueInt = (int)slider.value;
    zoomLabel.text = [NSString stringWithFormat:@"%dkm",valueInt];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateRadius" object:[NSNumber numberWithInt:valueInt]];

}

- (void)dealloc
{
    [radar release];
    [super dealloc];
}
@end
