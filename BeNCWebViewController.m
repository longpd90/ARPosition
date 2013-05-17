//
//  BeNCWebViewController.m
//  ARShop
//
//  Created by Administrator on 12/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCWebViewController.h"

@interface BeNCWebViewController ()

@end

@implementation BeNCWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)loadWebView:(NSString *)stringURL
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 480, 300)];
    webView.delegate = self;
    NSURL *uRL = [NSURL URLWithString:stringURL];
    NSURLRequest *uRLRequest = [NSURLRequest requestWithURL:uRL];
    [webView loadRequest:uRLRequest];
    [self.view addSubview:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}
@end
