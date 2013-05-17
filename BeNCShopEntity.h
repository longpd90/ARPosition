//
//  BeNCShopEntity.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeNCShopEntity : NSObject{
    int shop_id;
    NSString *shop_name;
    int shop_type;
    NSString *shop_address;
    NSString *shop_address_detail;
    NSString *shop_description;
    NSString *shop_coupon_link;
    NSString *shop_menu_link;
    NSString *shop_phone;
    NSString *shop_open_time;
    NSString *shop_close_time;
    NSString *shop_icon_link;
    float shop_latitude;
    float shop_longitute;
    BOOL shopCheck;
    
}
@property BOOL shopCheck;
@property int shop_id;
@property int shop_type;
@property float shop_latitude;
@property float shop_longitute;
@property (nonatomic, retain)NSString *shop_name;
@property (nonatomic, retain)NSString *shop_address;
@property (nonatomic, retain)NSString *shop_address_detail;
@property (nonatomic, retain)NSString *shop_description;
@property (nonatomic, retain)NSString *shop_coupon_link;
@property (nonatomic, retain)NSString *shop_menu_link;
@property (nonatomic, retain)NSString *shop_phone;
@property (nonatomic, retain)NSString *shop_open_time;
@property (nonatomic, retain)NSString *shop_close_time;
@property (nonatomic, retain)NSString *shop_icon_link;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
