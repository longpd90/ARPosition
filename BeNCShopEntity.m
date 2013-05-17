//
//  BeNCShopEntity.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCShopEntity.h"
#import "ARUtility.h"

@implementation BeNCShopEntity
@synthesize shop_address,shop_address_detail,shop_close_time,shop_coupon_link,shop_description,shop_id,shop_latitude,shop_longitute,shop_menu_link,shop_name,shop_open_time,shop_phone,shop_type;
@synthesize shopCheck,shop_icon_link;

- (id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.shop_id = [[dictionary objectForKey:BeNCShopProperiesShopId]intValue];
        self.shop_address = [dictionary objectForKey:BeNCShopProperiesShopAddress];
        self.shop_address_detail = [dictionary objectForKey:BeNCShopProperiesShopAddressDetail];
        self.shop_close_time = [dictionary objectForKey:BeNCShopProperiesShopCloseTime];
        self.shop_coupon_link = [dictionary objectForKey:BeNCShopProperiesShopCouponLink];
        self.shop_description = [dictionary objectForKey:BeNCShopProperiesShopDescription];
        self.shop_icon_link = [dictionary objectForKey:BeNCShopProperiesShopIcon];
        self.shop_latitude = [[dictionary objectForKey:BeNCShopProperiesShopLatitude]floatValue];
        self.shop_longitute = [[dictionary objectForKey:BeNCShopProperiesShopLongitude]floatValue];
        self.shop_name = [dictionary objectForKey:BeNCShopProperiesShopName];
        self.shop_open_time = [dictionary objectForKey:BeNCShopProperiesShopOpenTime];
        self.shop_menu_link = [dictionary objectForKey:BeNCShopProperiesShopMenuLink];
        self.shop_phone = [dictionary objectForKey:BeNCShopProperiesShopPhone];
        
    }
    return  self;
}
- (void)setValueForShopCheck:(BOOL )check
{
    self.shopCheck = check;
}
@end
