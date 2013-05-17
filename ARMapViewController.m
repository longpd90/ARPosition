//
//  BeNCMapViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARMapViewController.h"
#import "ARDetailViewController.h"
#import "LocationService.h"
#import "BeNCProcessDatabase.h"
#import "ARPositionAnnotation.h"
#import "ARListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ARPositionAnnotationView.h"
#import "EGOImageView.h"
#define MainList 0
#define MapList 1



#define LISTVIEW_WIDTH 400
#define LISTVIEW_HEIGTH 200

@interface ARMapViewController ()

@end

@implementation ARMapViewController
@synthesize mapViewPosition;
@synthesize selectedAnnotationView = _selectedAnnotationView;
bool firstUpdate = 1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateData:) name:@"Updata" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];

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
    
    mapViewPosition=[[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 480, 320)];
    [mapViewPosition setDelegate:self];
    [mapViewPosition setShowsUserLocation:YES];
    
    [self.view addSubview:mapViewPosition];
    
    UIButton *showUser = [UIButton buttonWithType:UIButtonTypeCustom];
    [showUser setBackgroundImage:[UIImage imageNamed:@"CurrentLocations.png"] forState:UIControlStateNormal];
    showUser.frame = CGRectMake(20, 255, 30, 30);
    showUser.alpha = 0.8;
    [showUser addTarget:self action:@selector(toUserLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showUser];
    [super viewDidLoad];


}

-(void)didUpdateData:(NSNotification *)notification {
    arrayPosition = (NSMutableArray *)[notification object];
    [self addShopAnnotation];
}

-(void)addShopAnnotation{
    NSLog(@"so phat tu cua shop :%d",[arrayPosition count]);
    shopsAnnotations = [[NSMutableArray alloc]init];
    for (int i=0; i<arrayPosition.count; i++) {
        InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:i];
        NSLog(@"khoi tao annotation %d la %@",i, positionEntity.label);
        
        CLLocationCoordinate2D placeCoord;
        
        placeCoord.latitude = positionEntity.latitude;
        placeCoord.longitude = positionEntity.longitude;
        
        ARPositionAnnotation *shopAnnotation=[[ARPositionAnnotation alloc]initWithName:positionEntity.label address:positionEntity.address coordinate:placeCoord];
        shopAnnotation.index=i;
        shopAnnotation.isGrouped = 0;
        shopAnnotation.position = positionEntity;
        [shopAnnotation.overideAnnotation addObject:positionEntity];
        [shopsAnnotations addObject:shopAnnotation];
        [mapViewPosition addAnnotation:shopAnnotation];
    }
    
}
-(void)didUpdateLocation:(NSNotification *)notifi{
    
    CLLocation *newLocation = (CLLocation *)[notifi object];
    
    if (firstUpdate) {
        CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        MKCoordinateRegion adjustedRegion = [mapViewPosition regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 1200, 1200)];
        [mapViewPosition setRegion:adjustedRegion animated:YES];
        firstUpdate=0;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    mapViewPosition = nil;
    shopsAnnotations = nil;
    selectedShops = nil;
    shopsAnnotations = nil;
    
}
-(void)dealloc{
    [super dealloc];
    [mapViewPosition release];
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

-  (void)mapView:(MKMapView *)mapview didSelectAnnotationView:(MKAnnotationView *)view
{
     if ([view.annotation isKindOfClass:[ARPositionAnnotation class]]) {

        ARPositionAnnotation *shopAnnotation = (ARPositionAnnotation *)view.annotation;
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
        InstanceData *positionEntity = (InstanceData *)[shopAnnotation.overideAnnotation objectAtIndex:0];
        
        NSLog(@"- Select annotation %@",positionEntity.label);
        NSLog(@"  Number of shop : %d",selectedShops.count);
        NSLog(@"  Shop link icon : %@",positionEntity.imageUrl);
        [self showDetail];
        
    }
    
}
-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"Deselect annotation");
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"annotation";   
    if ([annotation isKindOfClass:[ARPositionAnnotation class]]) {
        ARPositionAnnotationView *annotationView = (ARPositionAnnotationView *) [mapViewPosition dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[ARPositionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
        } else {
            annotationView.annotation = annotation;
        }
        ARPositionAnnotation *shopAnnotation = (ARPositionAnnotation *)annotation;

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
        ARDetailViewController *detailViewController = [[ARDetailViewController alloc] initWithShop:(InstanceData *)[selectedShops objectAtIndex:0]];
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
-(void)showDetailInMapView:(InstanceData *)positionEntity{
    ARDetailViewController *detailViewController = [[ARDetailViewController alloc] initWithShop:positionEntity];
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
                         [self.mapViewPosition deselectAnnotation:selectedAnnotation animated:YES];
                     }];
}
-(void)backToMap:(ARDetailViewController *)detailView{
    [self.mapViewPosition deselectAnnotation:selectedAnnotation animated:YES];
}

#pragma mark utility
-(void)checkOverride{
    for( id<MKAnnotation> annotation in shopsAnnotations) {
        if ([annotation isKindOfClass:[ARPositionAnnotation class]]) {
            ARPositionAnnotation *shopAnnotation = (ARPositionAnnotation *)annotation;
            shopAnnotation.isChecked = 0;
            CGPoint locationInView = [mapViewPosition convertCoordinate:shopAnnotation.coordinate toPointToView:self.view];
            shopAnnotation.locationInView = locationInView;
            //NSLog(@"Shop %@ co toa do la %f %f",shopAnnotation.shop.shop_name, locationInView.x,locationInView.y);
        }
    }
    
    for( id<MKAnnotation> annotation in shopsAnnotations) {
        if ([annotation isKindOfClass:[ARPositionAnnotation class]]) {
            ARPositionAnnotation *shopAnnotation = (ARPositionAnnotation *)annotation;
            if (shopAnnotation.isChecked==0) {
                if (shopAnnotation.isGrouped == 1) {
                    [self.mapViewPosition addAnnotation:shopAnnotation];
                    
                }
                shopAnnotation.isGrouped = 0;
                [shopAnnotation.overideAnnotation removeAllObjects ];
                [shopAnnotation.overideAnnotation addObject:shopAnnotation.position];
                for( id<MKAnnotation> annotationCheck in shopsAnnotations) {
                    if ([annotationCheck isKindOfClass:[ARPositionAnnotation class]]) {
                        
                        ARPositionAnnotation *shopcheck = (ARPositionAnnotation *)annotationCheck;
                        
                        if (shopcheck.index!=shopAnnotation.index && shopcheck.isChecked==0) {
                            
                            
                            if ([self distanceOf:shopAnnotation.locationInView andpoint:shopcheck.locationInView]<40) {
                                [shopAnnotation.overideAnnotation addObject:shopcheck.position];
                                if (shopcheck.isGrouped == 0) {
                                    [self.mapViewPosition removeAnnotation:shopcheck];
                                }
                                shopcheck.isGrouped = 1;
                                shopcheck.isChecked = 1;
                                
                            }
                            else{
                                
                            }
                            
                        }
                        
                    }
                }
                ARPositionAnnotationView *shopView = (ARPositionAnnotationView *)[mapViewPosition viewForAnnotation:shopAnnotation];
                
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
    region = MKCoordinateRegionMakeWithDistance(self.mapViewPosition.userLocation.coordinate,2000,2000);
    
    [self.mapViewPosition setRegion:region animated:YES];
    for (id<MKAnnotation> annotation in self.mapViewPosition.annotations) {
        if (![annotation isKindOfClass:[ARPositionAnnotation class]]) {
            [self.mapViewPosition selectAnnotation:annotation animated:YES];
            break; 
        }
    }
}
@end
