//
//  BeNCDetailInAR3D.h
//  ARShop
//
//  Created by Administrator on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ARDetailIn2D.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface ARDetailIn3D : ARDetailIn2D{
    double angleRotation;
    CGRect frame;
    float distanceShop;
    int radiusSearching;
    
}
@property int radiusSearching;
- (id)initWithShop:(InstanceData *)positionEntity;
-(double)caculateRotationAngle:(InstanceData * )positionEntity;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
-(void)setFrameForView:(float )angleToHeading;
- (float)caculateDistanceShop:(InstanceData *)positionEntity;
- (void)scaleViewWithDistace;

@end
