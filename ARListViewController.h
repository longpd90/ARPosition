//
//  BeNCListViewController.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
#import "ARPositionCell.h"
#import <ArroundPlaceService/ArroundPlaceService.h>

@class ARListViewController;

@protocol ListViewOnMapDelegate
@optional

-(void)animationScaleOff:(UINavigationController *)listview;
-(void)showDetailInMapView:(InstanceData *)positionEntity;

@end



@interface ARListViewController : UIViewController<ARPositionCellDelegate,UITableViewDelegate,UITableViewDataSource,ServiceControllerDelegate>{
    int listType;
    IBOutlet UITableView *listShopView;
    NSMutableArray *shopsArray;
    CLLocation *userLocation ;
    float distanceToShop;
    BOOL editing;
    UIBarButtonItem *editButton;
    UIBarButtonItem *refreshButtonItem;
    NSMutableArray *arrayButtonItem;
    UIButton *done;
    
}
@property(nonatomic,strong) id<ListViewOnMapDelegate> delegate;
@property(nonatomic, retain) NSMutableArray *shopsArray;
@property float distanceToShop;
@property(nonatomic,retain)IBOutlet UITableView *listShopView;
@property(nonatomic,retain)CLLocation *userLocation ;
@property(nonatomic) int listType;
@property (nonatomic, retain) NSMutableArray *arrayPosition;
-(void)didUpdateLocation:(NSNotification *)notifi;
-(void)getShopData;
-(int)calculeDistance:(BeNCShopEntity *)shop;
- (void)refreshData;
- (IBAction)editList:(id)sender;
-(void)getShopDataFromMap:(NSArray *)shopArray;
-(void)sortShopByDistance;
-(IBAction)closeListViewInMap:(id)sender;
-(void)addDoneButton;

@end
