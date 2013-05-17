//
//  BeNCWebViewController.h
//  ARShop
//
//  Created by Administrator on 12/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeNCWebViewController : UIViewController<UIWebViewDelegate>{
     UIWebView *webView;
}
- (void)loadWebView:(NSString *)stringURL;

@end
