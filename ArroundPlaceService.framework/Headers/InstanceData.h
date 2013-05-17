//
//  InstanceData.h
//  ArroundPlaceService
//
//  Created by Zoe on 4/9/13.
//  Copyright (c) 2013 SIG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstanceData : NSObject

@property (copy, nonatomic) NSString *uri;
@property (copy, nonatomic) NSString *label;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *imageUrl;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (copy, nonatomic) NSString *abstract;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *type;
@property (nonatomic) int rating;
@property (copy, nonatomic) NSString *style;
@property (copy, nonatomic) NSString *topic;
@property (nonatomic) BOOL isWellKnown;
@property (nonatomic) float distance;

-(id) initWithUri:(NSString *)theUri
            label:(NSString *)theLabel
          address:(NSString *)theAdd
         imageUrl:(NSString *)theImageUrl
         latitude:(double)theLatitude
        longitude:(double)theLongitude
         abstract:(NSString *)theAbstract
            phone:(NSString *)thePhone
             type:(NSString *)theType
           rating:(int)theRating
            style:(NSString *)theStyle
            topic:(NSString *)theTopic
      isWellKnown:(BOOL)theIsWellKnown;

@end
