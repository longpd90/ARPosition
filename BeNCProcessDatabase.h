//
//  BeNCProcessDatabase.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface BeNCProcessDatabase : NSObject{
    FMDatabase *database;
    NSArray *arrayShop;
}
@property(nonatomic, retain)NSArray *arrayShop;
+(BeNCProcessDatabase*)sharedMyDatabase;
- (void)getDatebase;
- (NSArray *)getArrayShops;
@end
