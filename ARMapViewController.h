//
//  BeNCMapViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ARListViewController.h"
#import "ARPositionAnnotation.h"
#import "ARDetailViewController.h"
#import "PositonDetailInAR.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
@interface ARMapViewController : UIViewController<MKMapViewDelegate,ListViewOnMapDelegate,DetailViewDelegate>{
    
    NSMutableArray *arrayPosition;
    MKMapView *mapViewPosition;
    NSMutableArray *shopsAnnotations;
    NSMutableArray *selectedShops;
    ARPositionAnnotation *selectedAnnotation;
    CLLocation *userLocation;
}
@property (nonatomic,retain) MKMapView *mapViewPosition;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)addShopAnnotation;
-(void)showDetail;
-(void)checkOverride;
-(float)distanceOf:(CGPoint)point1 andpoint :(CGPoint)point2;
-(IBAction)toUserLocation:(id)sender;
-(IBAction)sliderChange:(id)sender;
-(void)animationScaleOn:(UINavigationController *)navigation;
-(void)didUpdateData:(NSMutableArray *)arrayData ;

@end
