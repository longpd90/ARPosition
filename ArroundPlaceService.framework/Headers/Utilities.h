//
//  Utilities.h
//  ArroundPlaceService
//
//  Created by Zoe on 4/9/13.
//  Copyright (c) 2013 SIG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString *) calculateDistanceBetweenLatitude1:(NSString *)latitude1
                                     longitude1:(NSString *)longitude1
                                      latitude2:(NSString *)latitude2
                                     longitude2:(NSString *)longitude2;

+(float) calculateDistanceInKilometerBetweenLatitude1:(NSString *)latitude1
                                           longitude1:(NSString *)longitude1
                                            latitude2:(NSString *)latitude2
                                           longitude2:(NSString *)longitude2;

+(int) calculateDistanceInMeterBetweenLatitude1:(NSString *)latitude1
                                     longitude1:(NSString *)longitude1
                                      latitude2:(NSString *)latitude2
                                     longitude2:(NSString *)longitude2;

@end
