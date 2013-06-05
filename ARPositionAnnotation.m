//
//  BeNCShopAnnotation.m
//  ARShop
//
//  Created by Applehouse on 12/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARPositionAnnotation.h"

@implementation ARPositionAnnotation
@synthesize name=_name,address=_address,coordinate=_coordinate,title,subtitle,index,isChecked,isGrouped,locationInView,overideAnnotation,position = _position;
-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate{
    
    if (self=[super init]) {
        _name=name;
        _address=address;
        self.title=name;
        self.subtitle=address;
        _coordinate=coordinate;
        self.index=0;
        self.isChecked=NO;
        self.locationInView =CGPointMake(0, 0);
        self.overideAnnotation = [[NSMutableArray alloc]init];
    }
    return self;
    
}


@end
