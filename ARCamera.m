//
//  ARCamera.m
//  ARPosition
//
//  Created by Duc Long on 5/14/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import "ARCamera.h"

@implementation ARCamera
@synthesize deviceInput;
- (void)addVideoInput :(UIViewController *)viewController{
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self];
    previewLayer.frame = CGRectMake(0, 0, 480, 320);
    [previewLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[viewController.view.layer addSublayer:previewLayer];
//    [viewController.view sendSubviewToBack:previewLayer];
    NSError *error = nil;
    AVCaptureDevice * camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    if ([self canAddInput:deviceInput])
        [self addInput:deviceInput];
        [self startRunning];

    }

- (void)dealloc
{
    [self stopRunning];
}
@end
