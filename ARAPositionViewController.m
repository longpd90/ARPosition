//
//  BeNCOneShopARViewController.m
//  ARShop
//
//  Created by Administrator on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ARAPositionViewController.h"
#import "ARDetailIn2D.h"
#import "LocationService.h"
#import "ARCamera.h"
#import <math.h>
#define rotationRate 0.0174532925
#define frameRadius 60

@interface ARAPositionViewController ()

@end

@implementation ARAPositionViewController
@synthesize userLocation,position,rotationAngleArrow;

- (id)initWithShop:(InstanceData *)positionEntity
{
    self = [super init];
    if (self) {
        position = positionEntity;
        self.userLocation = [[LocationService sharedLocation]getOldLocation]; 

        rotationAngleArrow = [self caculateRotationAngle:positionEntity];
        [self setContentForView:positionEntity];

        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateHeading:) name:@"UpdateHeading" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [self addVideoInput];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateLocation" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UpdateHeading" object:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)addVideoInput {
    ARCamera *aRCamera = [[ARCamera alloc]init];
    [aRCamera addVideoInput:self];
}
- (void)setContentForView:(InstanceData *)positionEntity
{
    arrowView = [[ARArrow alloc]initWithShop:positionEntity];
    [self.view addSubview:arrowView];
    PositonDetailInAR *detailViewInAR = [[PositonDetailInAR alloc]initWithShop:positionEntity];
    [self.view addSubview:detailViewInAR];
    CGPoint pointCenter;
    pointCenter.x = 240;
    pointCenter.y = 150;
    detailViewInAR.center = pointCenter;
}
- (void)setNewCenterForView:(float )angleToHeading{
    float originX = arrowView.frame.size.width/2;
    float originY = arrowView.frame.size.height/2;
    float angle1 = atanf(150.0/240.0);
    float angle2 = M_PI - angle1;
    float a = tan(angleToHeading);
    float b = 150 - 240 * a ;
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
    arrowView.center = newCenter;

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
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    rotationAngleArrow = [self caculateRotationAngle:position];
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


@end
