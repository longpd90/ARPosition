//
//  BeNCProcessDatabase.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCProcessDatabase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ARAppDelegate.h"
#import "ARUtility.h"
#import "BeNCShopEntity.h"

@implementation BeNCProcessDatabase
@synthesize arrayShop;

static BeNCProcessDatabase *shareDatabase = nil;

+(BeNCProcessDatabase*)sharedMyDatabase
{
	@synchronized([BeNCProcessDatabase class])
	{
		if (!shareDatabase)
			[[self alloc] init] ;
        
		return shareDatabase;
	}
    
	return nil;
}

+(id)alloc
{
	@synchronized([BeNCProcessDatabase class])
	{
		NSAssert(shareDatabase == nil, @"Attempted to allocate a second instance of a singleton.");
		shareDatabase = [super alloc];
		return shareDatabase;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

-(void)getDatebase {
    ARAppDelegate  *appDelegate = (ARAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *databasePath = appDelegate.databasePath;
    database = [[FMDatabase databaseWithPath:databasePath]retain];
    [self getArrayShops];
}

- (NSArray *)getArrayShops
{
    [database open];
    NSMutableArray *shops = [[NSMutableArray alloc]init];
    FMResultSet *results  = [database executeQuery:[NSString stringWithFormat:@"select *from shops"]];
    while ([results next]) {
        //NSLog(@"number of column %d",results.columnCount);
        NSMutableDictionary *shop = [[NSMutableDictionary alloc] init];
        NSNumber *shop_id = [[NSNumber alloc] initWithInt:[results intForColumn:BeNCShopProperiesShopId]];
        NSNumber *shop_type = [[NSNumber alloc] initWithInt:[results intForColumn:BeNCShopProperiesShopTye]];
        
        
        NSNumber *shop_latitude = [[NSNumber alloc] initWithFloat:(float)[results doubleForColumn:BeNCShopProperiesShopLatitude]];
        NSNumber *shop_longitude = [[NSNumber alloc] initWithFloat:(float)[results doubleForColumn:BeNCShopProperiesShopLongitude]];
        
        NSString *shop_phone = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopPhone]];

        NSString *shop_name = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopName]];
        NSString *shop_address = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopAddress]];
        NSString *shop_address_detail = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopAddressDetail]];
        NSString *shop_description = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopDescription]];
        NSString *shop_coupon_link = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopCouponLink]];

        NSString *shop_menu_link = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopMenuLink]];
        NSString *shop_open_time = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopOpenTime]];
        NSString *shop_close_time = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopCloseTime]];
        NSString *shop_icon_link = [NSString stringWithFormat:@"%@",[results stringForColumn:BeNCShopProperiesShopIcon]];


        [shop setObject:shop_id forKey:BeNCShopProperiesShopId];
        [shop setObject:shop_name forKey:BeNCShopProperiesShopName];
        [shop setObject:shop_type forKey:BeNCShopProperiesShopTye];
        [shop setObject:shop_address forKey:BeNCShopProperiesShopAddress];
        [shop setObject:shop_address_detail forKey:BeNCShopProperiesShopAddressDetail];
        [shop setObject:shop_description forKey:BeNCShopProperiesShopDescription];
        [shop setObject:shop_coupon_link forKey:BeNCShopProperiesShopCouponLink];
        [shop setObject:shop_menu_link forKey:BeNCShopProperiesShopMenuLink];
        [shop setObject:shop_phone forKey:BeNCShopProperiesShopPhone];
        [shop setObject:shop_open_time forKey:BeNCShopProperiesShopOpenTime];
        [shop setObject:shop_close_time forKey:BeNCShopProperiesShopCloseTime];
        [shop setObject:shop_latitude forKey:BeNCShopProperiesShopLatitude];
        [shop setObject:shop_longitude forKey:BeNCShopProperiesShopLongitude];
        [shop setObject:shop_icon_link forKey:BeNCShopProperiesShopIcon];
        
        BeNCShopEntity *newShop = [[BeNCShopEntity alloc]initWithDictionary:shop];
        [shop release];
        [shops addObject:newShop];
        [newShop release];
        [shop_id release];
        [shop_longitude release];
        [shop_latitude release];
        [shop_type release];
        }
    [database close];
    arrayShop = shops;
    return [NSArray arrayWithArray:shops];
}
- (void)dealloc
{
    [arrayShop release];
    [database release];
    [super dealloc];
}


@end
