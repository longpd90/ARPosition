//
//  LocationService.m
//  ARShop
//
//  Created by Applehouse on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService
@synthesize locationManager,userLocation;

-(id)init{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        self.locationManager.headingFilter = kCLHeadingFilterNone;
        [self.locationManager setDistanceFilter:3];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];        
        userLocation = [[CLLocation alloc]init];        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"init" object:nil];
    }
    return self;
}

+(id)sharedLocation{
    LocationService *service = nil;
    service = [[LocationService alloc]init];
    
    return service;
}
+(id)userLocation{
     return self.userLocation;
}
-(void)startUpdate{

    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    
     [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateHeading" object:newHeading];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if (userLocation) {
        [userLocation release];
    }
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setFloat:userLocation.coordinate.latitude forKey:@"userLatitude"];
    [userDefault setFloat:userLocation.coordinate.longitude forKey:@"userLongitude"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateLocation" object:newLocation];
}
-(CLLocation *)getOldLocation{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    float latitude = (float)[userDefault floatForKey:@"userLatitude"];
    float longitude = (float)[userDefault floatForKey:@"userLongitude"];

    CLLocation *oldLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    return oldLocation;
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Update location fail");
}


-(void)dealloc{
    
    [super dealloc];
}
@end
