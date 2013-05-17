//
//  ArroundPlaceService.h
//  ArroundPlaceService
//
//  Created by Zoe on 4/9/13.
//  Copyright (c) 2013 SIG. All rights reserved.
//

#define PLACE -1
#define BANK_RESOURCE 0
#define TOURIST_RESOURCE 1
#define ACCOMODATION 2
#define DINNING_SERVICE 3

#import <Foundation/Foundation.h>
#import "InstanceData.h"
#import "Utilities.h"

@protocol ServiceControllerDelegate;

@interface ArroundPlaceService : NSObject <NSURLConnectionDelegate, NSXMLParserDelegate>

@property (weak, nonatomic) id <ServiceControllerDelegate> delegate;

-(void) getArroundPlaceWithLatitude:(NSString *)latitude
                          longitude:(NSString *)longitude
                             radius:(float)radius
                           pageSize:(int)thePageSize
                          pageIndex:(int)thePageIndex
                           category:(int)category
                           language:(NSString *)lang;

@end

@protocol ServiceControllerDelegate <NSObject>

//-(void) getAllInstanceOfClassDidFinish:(ServiceController *)controller withResult:(NSArray *)results;
- (void)requestDidFinish:(ArroundPlaceService *)controller withResult:(NSArray *)results;

//@optional
- (void)requestDidFail:(ArroundPlaceService *)controller withError:(NSError *)error;

@end
