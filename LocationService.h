//
//  LocationService.h
//  ARShop
//
//  Created by Applehouse on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LocationService : NSObject<CLLocationManagerDelegate>{
    CLLocation *userLocation ;
    CLLocationManager *locationManager;
    
    
}
@property(nonatomic,retain) CLLocation *userLocation ;
@property(nonatomic,retain) CLLocationManager *locationManager;

+(id)sharedLocation;
+(id)userLocation;
-(id)init;
-(void)startUpdate;
-(CLLocation *)getOldLocation;
@end
