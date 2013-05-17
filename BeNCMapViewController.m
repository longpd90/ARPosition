//
//  BeNCMapViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BeNCMapViewController.h"
#import "ARDetailViewController.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopEntity.h"
#import "BeNCShopAnnotation.h"
#import "ARListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BeNCAnnotationView.h"
#import "EGOImageView.h"
#define MainList 0
#define MapList 1



#define LISTVIEW_WIDTH 400
#define LISTVIEW_HEIGTH 200

@interface BeNCMapViewController ()

@end

@implementation BeNCMapViewController
@synthesize mapView;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize zoomSlider,zoomLabel;
bool firstUpdate = 1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    
}
- (void)viewDidLoad
{
    self.title = @"Map";
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    
    
    mapView=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
    [mapView setDelegate:self];
    [mapView setShowsUserLocation:YES];
    
    [self.view addSubview:mapView];
    
    UIButton *showUser = [UIButton buttonWithType:UIButtonTypeCustom];
    [showUser setBackgroundImage:[UIImage imageNamed:@"CurrentLocations.png"] forState:UIControlStateNormal];
    showUser.frame = CGRectMake(20, 255, 30, 30);
    showUser.alpha = 0.8;
    [showUser addTarget:self action:@selector(toUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showUser];
    
    
    
//    zoomSlider = [[UISlider alloc]initWithFrame:CGRectMake(-40, 120, 150, 40)] ;
//    zoomSlider.maximumValue = 10;
//    zoomSlider.value = 7;
//    zoomSlider.minimumValue = 1;
//    [zoomSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
//    
//    
//    zoomlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 60, 20)];
//    zoomlabel.text = [NSString stringWithFormat:@"1 km"];
//    zoomlabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:zoomlabel];
//    
//    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI * 0.5);
//    zoomSlider.transform = rotate;
//    [self.view addSubview:zoomSlider];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];

    [self getShopData];
    [super viewDidLoad];


}
-(void)getShopData{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
    [self addShopAnnotation];
}

-(void)addShopAnnotation{
    shopsAnnotations = [[NSMutableArray alloc]init];
    for (int i=0; i<shopsArray.count; i++) {
        
        BeNCShopEntity *shop = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
        //NSLog(@"khoi tao annotation %d la %@",i,shop.shop_name);
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude=shop.shop_latitude;
        placeCoord.longitude=shop.shop_longitute;
        
        BeNCShopAnnotation *shopAnnotation=[[BeNCShopAnnotation alloc]initWithName:shop.shop_name address:shop.shop_address coordinate:placeCoord];
        shopAnnotation.index=i;
        shopAnnotation.isGrouped = 0;
        shopAnnotation.shop = shop;
        [shopAnnotation.overideAnnotation addObject:shop];
        [shopsAnnotations addObject:shopAnnotation];
        [mapView addAnnotation:shopAnnotation];
    }
    
}
-(void)didUpdateLocation:(NSNotification *)notifi{
    
    CLLocation *newLocation = (CLLocation *)[notifi object];
    
    if (firstUpdate) {
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        MKCoordinateRegion adjustedRegion = [mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1200, 1200)];
        [mapView setRegion:adjustedRegion animated:YES];
        firstUpdate=0;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    mapView = nil;
    shopsArray = nil;
    shopsAnnotations = nil;
    selectedShops = nil;
    shopsAnnotations = nil;
    
}
-(void)dealloc{
    [super dealloc];
    [mapView release];
    [shopsArray release];
    [shopsAnnotations release];
    [selectedAnnotation release];
    [selectedShops release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
#pragma mark mapViewDelegate
-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views{
    
    //    NSLog(@"Annotation add :%d",views.count);
    
}
- (void)mapView:(MKMapView *)mv regionDidChangeAnimated:(BOOL)animated {
    [self checkOverride];
//    float span = self.mapView.region.span.latitudeDelta;
    
}    
-(void)zoomMap:(float)regionRadial{
    MKCoordinateRegion region;
    
    
    NSLog(@"Region Radial : %f",regionRadial);
    region = MKCoordinateRegionMakeWithDistance(self.mapView.centerCoordinate,regionRadial,regionRadial);
    
    [self.mapView setRegion:region animated:YES];
}
-  (void)mapView:(MKMapView *)mapview didSelectAnnotationView:(MKAnnotationView *)view
{
     if ([view.annotation isKindOfClass:[BeNCShopAnnotation class]]) {
        
        BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)view.annotation;
        selectedAnnotation = shopAnnotation;
        if (shopAnnotation.overideAnnotation.count > 1) {
            shopAnnotation.title = [NSString stringWithFormat:@"%d shop",shopAnnotation.overideAnnotation.count];
        }
        else{
            shopAnnotation.title = shopAnnotation.name;
        }
        if (selectedShops ) {
            [selectedShops release];
        }
        
        selectedShops = [[NSMutableArray alloc]initWithArray:shopAnnotation.overideAnnotation];
        BeNCShopEntity *shop = (BeNCShopEntity *)[shopAnnotation.overideAnnotation objectAtIndex:0];
        
        NSLog(@"- Select annotation %@",shop.shop_name);
        NSLog(@"  Number of shop : %d",selectedShops.count);
        NSLog(@"  Shop link icon : %@",shop.shop_icon_link);
        [self showDetail];
        
    }
    
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"Deselect annotation");
}
-(MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"annotation";   
    if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
        
        BeNCAnnotationView *annotationView = (BeNCAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[BeNCAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            annotationView.annotation = annotation;
        }
        BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;

        if (shopAnnotation.overideAnnotation.count>1) {
            annotationView.numberlb.text = [NSString stringWithFormat:@"%d",shopAnnotation.overideAnnotation.count];
            
            annotationView.numberlb.hidden =NO;
            annotationView.numberImageView.hidden = NO;
        }
        else{
            annotationView.numberlb.hidden = YES;
            annotationView.numberImageView.hidden = YES;
        }
         annotationView.enabled = YES;

        return annotationView;
    }
    else{
        
    }
    return nil;    
}
-(void)showDetail{
    if (selectedShops.count==1) {
        ARDetailViewController *detailViewController = [[ARDetailViewController alloc] initWithShop:(BeNCShopEntity *)[selectedShops objectAtIndex:0]];
        detailViewController.delegate = self;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else{
        ARListViewController *listShopViewController = [[ARListViewController alloc]initWithNibName:@"ARListViewController" bundle:nil];
        listShopViewController.delegate = self;
        UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:listShopViewController];
        [listShopViewController setListType:1];
        [listShopViewController getShopDataFromMap:selectedShops];
        [listShopViewController addDoneButton];
        CGAffineTransform scale = CGAffineTransformMakeScale(0.8, 0.8);
        navigation.view.transform = scale;
        [navigation.view.layer setShadowRadius:6];
        [navigation.view.layer setShadowOpacity:0.9];
        [navigation.view.layer setShadowColor:[UIColor blackColor].CGColor];
        
        [navigation.view setFrame:CGRectMake(220, 110, 400, 200)];
        CGAffineTransform scaleBegin = CGAffineTransformMakeScale(0.01, 0.01);
        navigation.view.transform = scaleBegin;
        [self.view addSubview:navigation.view];
        [self animationScaleOn:navigation];
        [listShopViewController release];
        
        
    }
    
    
}
-(void)animationScaleOn:(UINavigationController *)navigation{
    navigation.view.center = CGPointMake(240 , 140);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         CGAffineTransform scaleBegin = CGAffineTransformMakeScale(0.8, 0.8);
                         navigation.view.transform = scaleBegin;
                     }
                     completion:^(BOOL finished) { 
                         
                     }];
}
#pragma mark subView delegate;
-(void)showDetailInMapView:(BeNCShopEntity *)shop{
    ARDetailViewController *detailViewController = [[ARDetailViewController alloc] initWithShop:shop];
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
-(void)animationScaleOff:(UINavigationController *)listview{
    NSLog(@"Close");
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         listview.view.frame = CGRectMake(220, 110, 40, 20);
                     }
                     completion:^(BOOL finished) { 
                         [listview.view removeFromSuperview]; 
                         [self.mapView deselectAnnotation:selectedAnnotation animated:YES];
                     }];
}
-(void)backToMap:(ARDetailViewController *)detailView{
    [self.mapView deselectAnnotation:selectedAnnotation animated:YES];
}

#pragma mark utility
-(void)checkOverride{
    for( id<MKAnnotation> annotation in shopsAnnotations) {
        if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
            shopAnnotation.isChecked = 0;
            CGPoint locationInView = [mapView convertCoordinate:shopAnnotation.coordinate toPointToView:self.view];
            shopAnnotation.locationInView = locationInView;
            //NSLog(@"Shop %@ co toa do la %f %f",shopAnnotation.shop.shop_name, locationInView.x,locationInView.y);
        }
    }
    
    for( id<MKAnnotation> annotation in shopsAnnotations) {
        if ([annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            BeNCShopAnnotation *shopAnnotation = (BeNCShopAnnotation *)annotation;
            if (shopAnnotation.isChecked==0) {
                if (shopAnnotation.isGrouped == 1) {
                    [self.mapView addAnnotation:shopAnnotation];
                    
                }
                shopAnnotation.isGrouped = 0;
                [shopAnnotation.overideAnnotation removeAllObjects ];
                [shopAnnotation.overideAnnotation addObject:shopAnnotation.shop];    
                for( id<MKAnnotation> annotationCheck in shopsAnnotations) {
                    if ([annotationCheck isKindOfClass:[BeNCShopAnnotation class]]) {
                        
                        BeNCShopAnnotation *shopcheck = (BeNCShopAnnotation *)annotationCheck;
                        
                        if (shopcheck.index!=shopAnnotation.index && shopcheck.isChecked==0) {
                            
                            
                            if ([self distanceOf:shopAnnotation.locationInView andpoint:shopcheck.locationInView]<40) {
                                [shopAnnotation.overideAnnotation addObject:shopcheck.shop];
                                if (shopcheck.isGrouped == 0) {
                                    [self.mapView removeAnnotation:shopcheck];
                                }
                                shopcheck.isGrouped = 1;
                                shopcheck.isChecked = 1;
                                
                            }
                            else{
                                
                            }
                            
                        }
                        
                    }
                }
                BeNCAnnotationView *shopView = (BeNCAnnotationView *)[mapView viewForAnnotation:shopAnnotation];
                
                if (shopAnnotation.overideAnnotation.count>1) {
                    shopView.numberlb.text = [NSString stringWithFormat:@"%d",shopAnnotation.overideAnnotation.count];
                    shopView.numberImageView.hidden = NO;
                    shopView.numberlb.hidden = NO;
                }
                else{
                    shopView.numberImageView.hidden = YES;
                    shopView.numberlb.hidden = YES;
                }
                shopAnnotation.isChecked = 1;
            }
            
        }
    }
}
-(float)distanceOf:(CGPoint)point1 andpoint:(CGPoint)point2{
    CGFloat xDist = (point1.x - point2.x); 
    CGFloat yDist = (point1.y - point2.y); 
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}
-(IBAction)sliderChange:(id)sender{
    UISlider *slider = (UISlider *)sender;
    int valueInt = (int)slider.value;
//    int zoomValue = 1000;
    NSLog(@"Slider value : %d",valueInt);

}
-(IBAction)toUserLocation:(id)sender{
    
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate,2000,2000);
    
    [self.mapView setRegion:region animated:YES];
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[BeNCShopAnnotation class]]) {
            [self.mapView selectAnnotation:annotation animated:YES];
            break; 
        }
    }
}
@end
