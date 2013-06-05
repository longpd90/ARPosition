//
//  BeNCMenuViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARTabbarItem.h"

@protocol MenuViewControllerDelegate
- (void)addController:(id)controller;
@end

@interface MenuViewController : UIViewController<ARTabbarItemDelegate>
{
    UIView *tabBarHolder;
	NSMutableArray *tabViewControllers;
	NSMutableArray *tabItemsArray;
	int initTab; 
    int selectedTab;
    BOOL hiddenMenu;
    UIButton *buttonShowMenu;
    UIImage *imagePlus;
    UIImage *imageClose;

}

@property int initTab;

@property (nonatomic, strong) UIView *tabBarHolder;
@property (nonatomic, strong) id <MenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tabViewControllers;
@property (nonatomic, strong) NSMutableArray *tabItemsArray;
@property (nonatomic) int selectedTab;
//actions
- (id)initWithTabViewControllers:(NSMutableArray *)tbControllers tabItems:(NSMutableArray *)tbItems initialTab:(int)iTab;
-(void)initialTab:(int)tabIndex;
-(void)activateController:(int)index;
-(void)activateTabItem:(int)index;
- (IBAction)showHiddenMenu:(id)sender;
@end
