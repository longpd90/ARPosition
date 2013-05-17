//
//  BeNCDetailViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCDetailViewController.h"
#import "BeNCShopEntity.h"
#import "BeNCArrow.h"
#import "BeNCWebViewController.h"
#import "LocationService.h"
#import "BeNCOneShopARViewController.h"
#import "EGOImageView.h"
#define textSize 18
#define max 1000000
@interface BeNCDetailViewController ()

@end

@implementation BeNCDetailViewController
@synthesize shop,labelDistanceToShop,userLocation,delegate;

- (id)initWithShop:(BeNCShopEntity *)shopEntity
{
    self = [super init];
    if (self) {
        userLocation = [[LocationService sharedLocation] getOldLocation];
        shop = shopEntity;
        labelDistanceToShop = [[UILabel alloc]init];
        [labelDistanceToShop setTextAlignment:UITextAlignmentCenter];
        [labelDistanceToShop setFont:[UIFont systemFontOfSize:textSize - 2]];
        labelDistanceToShop.frame = CGRectMake(410, 50, 70, 30);
        labelDistanceToShop.text = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shopEntity]];
        [self.view addSubview:labelDistanceToShop];
        
        userLocation = [[[LocationService sharedLocation]getOldLocation]retain];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil]; 
        [self setContentDetailForView:shopEntity];
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

- (void)setContentDetailForView:(BeNCShopEntity *)shopEntity
{
    EGOImageView *logoImgaeView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"images.jpg"]];
    logoImgaeView.frame = CGRectMake(5, 5, 60, 60);
    logoImgaeView.imageURL = [NSURL URLWithString:shopEntity.shop_icon_link];
    [self.view addSubview:logoImgaeView];
    [logoImgaeView release];
    UILabel *labelShopName = [[UILabel alloc]init];
    labelShopName.numberOfLines = 0;
    [labelShopName setBackgroundColor:[UIColor grayColor]];
    [labelShopName setTextColor:[UIColor whiteColor]];
    labelShopName.text = shopEntity.shop_name;
    [labelShopName setTextAlignment:UITextAlignmentCenter];
    [labelShopName setFont:[UIFont boldSystemFontOfSize:textSize +4]];
    CGSize labelShopNameSize = [shopEntity.shop_name sizeWithFont:[UIFont systemFontOfSize:textSize + 4] constrainedToSize:CGSizeMake(320, max) lineBreakMode:UILineBreakModeCharacterWrap];
    labelShopName.frame = CGRectMake(80, 5, 320, labelShopNameSize.height);
    [self.view addSubview:labelShopName];
    [labelShopName release];

    
    UILabel *labelShopAddress = [[UILabel alloc]init];
    labelShopAddress.numberOfLines = 0;
    [labelShopAddress setBackgroundColor:[UIColor grayColor]];
    [labelShopAddress setTextColor:[UIColor whiteColor]];
    labelShopAddress.text = shopEntity.shop_address;
    [labelShopAddress setTextAlignment:UITextAlignmentCenter];
    [labelShopAddress setFont:[UIFont systemFontOfSize:textSize +2 ]];
    CGSize labelShopAddressSize = [shopEntity.shop_address sizeWithFont:[UIFont systemFontOfSize:textSize +2 ] constrainedToSize:CGSizeMake(320, max) lineBreakMode:UILineBreakModeCharacterWrap];
    labelShopAddress.frame = CGRectMake(80, labelShopNameSize.height + 5, 320 ,labelShopAddressSize.height);
    [self.view addSubview:labelShopAddress];
    [labelShopAddress release];


    UILabel *labelAddressDetail = [[UILabel alloc]init];
    [labelAddressDetail setBackgroundColor:[UIColor clearColor]];
    labelAddressDetail.text = [NSString stringWithFormat:@"%@",shopEntity.shop_address_detail];
    [labelAddressDetail setFont:[UIFont systemFontOfSize:textSize ]];
    CGSize labelShopAddressDetailSize = [shopEntity.shop_address_detail sizeWithFont:[UIFont systemFontOfSize:textSize] constrainedToSize:CGSizeMake(300, max) lineBreakMode:UILineBreakModeCharacterWrap];
    labelAddressDetail.frame = CGRectMake(80, labelShopNameSize.height + labelShopAddressSize.height + 15, 300, labelShopAddressDetailSize.height);
    labelAddressDetail.numberOfLines = 0;
    [self.view addSubview:labelAddressDetail];
    [labelAddressDetail release];

    
    UILabel *labelShopDescription = [[UILabel alloc]init];
    [labelShopDescription setBackgroundColor:[UIColor clearColor]];
    labelShopDescription.text = [NSString stringWithFormat:@"%@",shopEntity.shop_description];
    [labelShopDescription setFont:[UIFont systemFontOfSize:textSize ]];
    CGSize labelShopDescriptionSize = [shopEntity.shop_description sizeWithFont:[UIFont systemFontOfSize:textSize] constrainedToSize:CGSizeMake(300, max) lineBreakMode:UILineBreakModeCharacterWrap];
    labelShopDescription.frame = CGRectMake(80, labelShopNameSize.height + labelShopAddressSize.height + labelShopAddressDetailSize.height + 15, 300, labelShopDescriptionSize.height);
    labelShopDescription.numberOfLines = 0;
    [self.view addSubview:labelShopDescription];
    [labelShopDescription release];


    
    UILabel *labelShopPhone = [[UILabel alloc]init];
    [labelShopPhone setBackgroundColor:[UIColor clearColor]];
    labelShopPhone.text = [NSString stringWithFormat:@"Tel : %@",shopEntity.shop_phone];
    [labelShopPhone setFont:[UIFont systemFontOfSize:textSize ]];
    labelShopPhone.frame = CGRectMake(80, labelShopNameSize.height + labelShopAddressSize.height + labelShopAddressDetailSize.height + labelShopDescriptionSize.height + 20, 320, 20);
    [self.view addSubview:labelShopPhone];
    [labelShopPhone release];

    
    UILabel *labelTimeOpen = [[UILabel alloc]init];
    [labelTimeOpen setBackgroundColor:[UIColor clearColor]];
    labelTimeOpen.text = [NSString stringWithFormat:@"Open time: %@ - %@",shopEntity.shop_open_time,shopEntity.shop_close_time] ;
    [labelTimeOpen setFont:[UIFont systemFontOfSize:textSize ]];
    labelTimeOpen.frame = CGRectMake(80, labelShopNameSize.height + labelShopAddressSize.height + labelShopAddressDetailSize.height + labelShopDescriptionSize.height + 45, 250, 20);
    [self.view addSubview:labelTimeOpen];
    [labelTimeOpen release];


    
    UIButton *buttonToMenuSite = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonToMenuSite.frame = CGRectMake(50,labelShopNameSize.height + labelShopAddressSize.height + labelShopAddressDetailSize.height + labelShopDescriptionSize.height + 70, 60, 40);
    [buttonToMenuSite setBackgroundImage:[UIImage imageNamed:@"menu.gif"] forState:UIControlStateNormal];
    [buttonToMenuSite addTarget:self action:@selector(goToMenuSite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonToMenuSite];
    
    UIButton *buttonToCouponSite = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonToCouponSite.frame = CGRectMake(140, labelShopNameSize.height + labelShopAddressSize.height + labelShopAddressDetailSize.height + labelShopDescriptionSize.height + 70, 60, 40);
    [buttonToCouponSite setBackgroundImage:[UIImage imageNamed:@"coupon.png"] forState:UIControlStateNormal];
    [buttonToCouponSite addTarget:self action:@selector(goToCouponSite:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonToCouponSite];
    
    BeNCArrow *arrowImage = [[BeNCArrow alloc]initWithShop:shopEntity];
    arrowImage.frame = CGRectMake(430,10,20, 30);
    [self.view addSubview:arrowImage];
    [arrowImage release];
    
    UIBarButtonItem *cameraButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"ARShop" style:UIBarButtonItemStyleBordered target:self action:@selector(goToCamera:)];//[[UIBarButtonItem alloc]initWithTitle:@"ARShop" style:UIBarButtonSystemItemCamera target:self action:@selector(goToCamera:)];
    self.navigationItem.rightBarButtonItem = cameraButtonItem;
    [cameraButtonItem release];
    
//    UIButton *buttonFindMap = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonFindMap.frame = CGRectMake(50, 250, 60, 60);

}


- (int)caculateDistanceToShop:(BeNCShopEntity *)shopEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shopEntity.shop_latitude longitude:shopEntity.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    [shoplocation release];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    labelDistanceToShop.text = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:shop]];
}


- (IBAction)goToMenuSite:(id)sender
{
    BeNCWebViewController *webView = [[BeNCWebViewController alloc]initWithNibName:@"BeNCWebViewController" bundle:nil];
    [webView loadWebView:shop.shop_menu_link];
    [self.navigationController pushViewController:webView animated:YES];
    [webView release];
}

- (IBAction)goToCouponSite:(id)sender
{
    BeNCWebViewController *webView = [[BeNCWebViewController alloc]initWithNibName:@"BeNCWebViewController" bundle:nil];
    [webView loadWebView:shop.shop_coupon_link];
    [self.navigationController pushViewController:webView animated:YES];
    [webView release];
    
}
                                         
- (IBAction)goToCamera:(id)sender
{
    BeNCOneShopARViewController *oneShopAR = [[BeNCOneShopARViewController alloc]initWithShop:shop];
    [self.navigationController pushViewController:oneShopAR animated:YES];
    [oneShopAR release];
        
}
-(void)viewWillDisappear:(BOOL)animated{
    [delegate backToMap:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}
@end
