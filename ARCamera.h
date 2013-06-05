//
//  ARCamera.h
//  ARPosition
//
//  Created by Duc Long on 5/14/13.
//  Copyright (c) 2013 Duc Long. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ARCamera : AVCaptureSession
{
    CLLocation *userLocation;
    AVCaptureDeviceInput *deviceInput;
}
@property (nonatomic, strong)AVCaptureSession *captureSession;
@property (nonatomic, strong)AVCaptureDeviceInput *deviceInput;
- (void)addVideoInput :(UIViewController *)viewController;

@end
