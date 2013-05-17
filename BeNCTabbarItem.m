//
//  BeNCTabbarItem.m
//  ARShop
//
//  Created by Administrator on 12/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCTabbarItem.h"

@implementation BeNCTabbarItem
@synthesize delegate,_on;

-(BOOL)isOn {
	return _on;
}	
- (id)initWithFrame:(CGRect)frame normalState:(NSString*)n toggledState:(NSString *)t;   
{
	if (self = [super initWithFrame:frame]) 
	{
		[self setBackgroundImage:[UIImage imageNamed:n] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:t] forState:UIControlStateSelected];
		_on = NO;
		[self addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)toggleOn:(BOOL)state {
	_on = state;
	[self setSelected:_on];
}

-(void)toggle {
	[self setSelected:_on];
}

- (void)buttonPressed:(id)target
{
	//send notification of the button that was currently pressed
	[self.delegate selectedItem:target];
}
- (void)dealloc {
    [super dealloc];
}


@end
