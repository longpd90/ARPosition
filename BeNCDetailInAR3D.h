//
//  BeNCDetailInAR3D.h
//  ARShop
//
//  Created by Administrator on 1/23/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailInCamera.h"
@interface BeNCDetailInAR3D : BeNCDetailInCamera{
    double angleRotation;
    CGRect frame;
    float distanceShop;
    int radiusSearching;
}
@property int radiusSearching;
- (id)initWithShop:(BeNCShopEntity *)shopEntity;
-(double)caculateRotationAngle:(BeNCShopEntity * )shopEntity;
-(double)caculateRotationAngleToHeading:(double)angleToShop withAngleTonorth:(double )angleToNorth;
-(void)setFrameForView:(float )angleToHeading;
- (float)caculateDistanceShop:(BeNCShopEntity *)shopEntity;
- (void)scaleViewWithDistace;

@end
