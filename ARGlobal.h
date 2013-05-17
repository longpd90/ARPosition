//
//  BeNCGlobal.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationService.h"

@interface ARGlobal : NSObject{
    CLLocation *userLocation;
}
-(double)caculateRotationAngle:(float )lat withLng:(float)lng;
@end
