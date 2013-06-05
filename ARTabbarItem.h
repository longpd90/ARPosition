//
//  BeNCTabbarItem.h
//  ARShop
//
//  Created by Administrator on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ARTabbarItem;
@protocol ARTabbarItemDelegate <NSObject>
- (void)selectedItem:(ARTabbarItem *)button;
@end

@interface ARTabbarItem : UIButton{
    BOOL _on;
}
@property (nonatomic, strong) id <ARTabbarItemDelegate> delegate;
@property (nonatomic) BOOL _on;
-(id)initWithFrame:(CGRect)frame normalState:(NSString*)n toggledState:(NSString *)t;            
-(BOOL)isOn;
-(void)toggleOn:(BOOL)state;

@end
