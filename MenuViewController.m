//
//  BeNCMenuViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#define kSelectedTab	@"SelectedTAB"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize tabViewControllers,tabBarHolder,delegate,initTab,tabItemsArray;
@synthesize selectedTab;
bool backToRootView;

- (id)initWithTabViewControllers:(NSMutableArray *)tbControllers tabItems:(NSMutableArray *)tbItems initialTab:(int)iTab {
	if ((self = [super init])) {
		self.view.frame = [UIScreen mainScreen].bounds;
		initTab = iTab;
		backToRootView = 0;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		if ([defaults integerForKey:kSelectedTab]) {
			initTab = [defaults integerForKey:kSelectedTab];
		}
        self.selectedTab = initTab;
		tabViewControllers = [[NSMutableArray alloc] initWithCapacity:[tbControllers count]];
		tabViewControllers = tbControllers;
		tabItemsArray = [[NSMutableArray alloc] initWithCapacity:[tbItems count]];
		tabItemsArray = tbItems;
	}
    return self;
}

- (void)viewDidLoad
{
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
   ;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)initialTab:(int)tabIndex {
	[self activateController:tabIndex];
	[self activateTabItem:tabIndex];
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//Create a view holder to store the tabbar items
	tabBarHolder = [[UIView alloc] initWithFrame:CGRectMake(110, 270, 370, 30)];
	tabBarHolder.backgroundColor = [UIColor grayColor];
    
	//add it as a subview
	[self.view addSubview:tabBarHolder];
    
	//loop thru all the view controllers and add their views to self
	for (int i = [tabViewControllers count]-1; i >= 0; i--) {
		[self.view addSubview:[[tabViewControllers objectAtIndex:i] view]];
	}
	
	//loop thru all the tabbar items and add them to the tabBarHolder
	
	for (int i = [tabItemsArray count]-1; i >= 0; i--) {
		[[tabItemsArray objectAtIndex:i] setDelegate:self];
		[self.tabBarHolder addSubview:[tabItemsArray objectAtIndex:i]];
		//initTab is the index of the tabbar and viewcontroller that you decide to start the app with
		if (i == initTab) {
			[[tabItemsArray objectAtIndex:i] toggleOn:YES];
		}
	}
	[self.view bringSubviewToFront:tabBarHolder];
	//show/hide tabbars and controllers with a particular index
	[self initialTab:initTab];
}
//loop thru all tab bar items and set their toogle State to YES/NO
-(void)activateTabItem:(int)index {
	for (int i = [tabItemsArray count]; i < [tabItemsArray count]; i++) {
		if (i == index) {
			[[tabItemsArray objectAtIndex:i] toggleOn:YES];
            [[tabItemsArray objectAtIndex:i] setAlpha:1.0];
		} else {
			[[tabItemsArray objectAtIndex:i] toggleOn:NO];
            [[tabItemsArray objectAtIndex:i] setAlpha:0.5];
		}
	}
}
//loop thru all UIViewControllers items and set their toogle State to YES/NO
-(void)activateController:(int)index {
	for (int i = 0; i < [tabViewControllers count]; i++) {
		if (i == index) {
			[[tabViewControllers objectAtIndex:i] view].hidden = NO;
            
            
            if (backToRootView) {
                UINavigationController *navigation = (UINavigationController *)[tabViewControllers objectAtIndex:i];
                if (navigation.viewControllers.count>1) {
                    [navigation popToRootViewControllerAnimated:YES];
                }
                backToRootView =0;
            }
            
             		} else {
			[[tabViewControllers objectAtIndex:i] view].hidden = YES;
		}
	}
}
//protocol used to communicate between the buttons and the tabbar
#pragma mark -
#pragma mark GTabTabItemDelegate action
- (void)selectedItem:(ARTabbarItem *)button {
	int indexC = 0;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger tabIndex;
	for (ARTabbarItem *tb in tabItemsArray) {		
		if (tb == button) {
			[tb toggleOn:YES];
			
            tabIndex = indexC;
			[defaults setInteger:tabIndex forKey:kSelectedTab];
            if (tabIndex ==  selectedTab) {
                backToRootView = 1;
            }
            [self activateController:indexC];
            self.selectedTab = tabIndex;
		} else {
			[tb toggleOn:NO];
		}
		indexC++;
	}	 
}

- (void)dealloc
{
    [tabBarHolder release];
	[tabViewControllers release];
	[tabItemsArray release];
    [super dealloc];
}


@end
