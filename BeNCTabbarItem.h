//
//  BeNCTabbarItem.h
//  ARShop
//
//  Created by Administrator on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeNCTabbarItem;
@protocol BeNCTabbarItemDelegate <NSObject> 
- (void)selectedItem:(BeNCTabbarItem *)button;
@end

@interface BeNCTabbarItem : UIButton{
    BOOL _on;
}
@property (nonatomic, assign) id <BeNCTabbarItemDelegate> delegate;
@property (nonatomic) BOOL _on;
-(id)initWithFrame:(CGRect)frame normalState:(NSString*)n toggledState:(NSString *)t;            
-(BOOL)isOn;
-(void)toggleOn:(BOOL)state;

@end
