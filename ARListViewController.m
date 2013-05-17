//
//  BeNCListViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARListViewController.h"
#import "LocationService.h"
#import "ARDetailViewController.h"
#import "ARUtility.h"
#import "BeNCProcessDatabase.h"
#import "BeNCShopEntity.h"
#import "ARPositionCell.h"
#import "BeNCOneShopARViewController.h"
#import "EGOImageView.h"
#import "BeNCShopInRadar.h"
#define MainList 0
#define MapList 1

@interface ARListViewController ()

@end

@implementation ARListViewController
@synthesize listShopView,userLocation,distanceToShop,shopsArray;
@synthesize listType,delegate,arrayPosition;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [self getShopData];
        [self sortShopByDistance];
        [self getData:100 withPageSize:8 withPageIndex:1 withCatagory:2 withLanguage:@"vn"];

    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    refreshButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshData)];
    
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editList:)];
    arrayButtonItem =  [[NSMutableArray arrayWithObjects:editButton,refreshButtonItem, nil]retain];
    [self setTitle:@"List Position"];
    
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    self.listShopView.frame = CGRectMake(0, 0, 480, 320);
    listShopView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    
    if (listType == MainList) {
        self.navigationItem.rightBarButtonItem = refreshButtonItem;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,refreshButtonItem, nil];
        NSLog(@"main list");
    }
    else if(listType == MapList){
        //self.navigationItem.rightBarButtonItem = done;
        NSLog(@"map list");
    }
    [super viewDidLoad];
}
-(void)addDoneButton{
    done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [done setTitle:@"X" forState:UIControlStateNormal];
    
    [done setFrame:CGRectMake(470, -5, 40, 40)];
    [done addTarget:self action:@selector(closeListViewInMap:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:done];
}


-(IBAction)closeListViewInMap:(id)sender{
    NSLog(@"Close list view");
    [done setHidden:YES];
    self.navigationController.navigationBar.hidden = YES;
    [self.delegate animationScaleOff:self.navigationController];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark getdata
-(void)getShopDataFromMap:(NSArray *)shopArray{
    shopsArray = [[NSMutableArray alloc]initWithArray:shopArray];
    if (userLocation==nil) {
       userLocation = [[LocationService sharedLocation]getOldLocation]; 
    }
    [self.listShopView reloadData];
}

-(void)getShopData{
    [[BeNCProcessDatabase sharedMyDatabase]getDatebase];
    shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
    [self.listShopView reloadData];
}

- (void)getData:(float)radius withPageSize:(int)pageSize withPageIndex:(int)pageIndex withCatagory:(int)catagory  withLanguage:(NSString *)language {
    NSLog(@"user lat = %f, user lng = %f",userLocation.coordinate.latitude, userLocation.coordinate.longitude);
    ArroundPlaceService * dataPlace = [[ArroundPlaceService alloc]init];
    dataPlace.delegate = self;
    [dataPlace getArroundPlaceWithLatitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] radius:radius pageSize:pageSize pageIndex:pageIndex category:catagory language:language];
}

- (void)requestDidFinish:(ArroundPlaceService *)controller withResult:(NSArray *)results
{
    
    arrayPosition = [[NSMutableArray arrayWithArray:results]retain];
    
    for (int i = 0; i < [arrayPosition count]; i ++) {
        InstanceData *instanceData = (InstanceData *)[arrayPosition objectAtIndex:i];
        NSLog(@"address : %@, lat = %f, lng = %f",instanceData.address,instanceData.latitude,instanceData.longitude);
    }
}

- (void)requestDidFail:(ArroundPlaceService *)controller withError:(NSError *)error
{
    NSLog(@"error : %@",error);
}

-(int)calculeDistance:(BeNCShopEntity *)shop{

    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:shop.shop_latitude longitude:shop.shop_longitute];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    [shoplocation release];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    [self sortShopByDistance];
    [self.listShopView reloadData];
}

- (void)refreshData
{
    if (!editing) {
        shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
        [self sortShopByDistance];
        [self.listShopView reloadData];
    }

}

- (void)sortShopByDistance
{
    for (int i = 0; i < [shopsArray count]; i ++) {
        for (int j = i + 1; j < [shopsArray count]; j ++) {
            if ([self calculeDistance:[shopsArray objectAtIndex:i]] > [self calculeDistance:[shopsArray objectAtIndex:j]]) 
                [shopsArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayPosition count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ARPositionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ARPositionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    InstanceData *position  = [arrayPosition objectAtIndex:indexPath.row];
//    if (shop.shopCheck == 1) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
//    }
//    else {
        cell.accessoryType = UITableViewCellAccessoryNone ;
//    }
    if (listType == MapList) {
        cell.distanceToShop.hidden = YES;
    }
    [cell updateContentForCell:position withLocation:userLocation];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editing) {
//        InstanceData *positionEntity  = [arrayPosition objectAtIndex:indexPath.row];
//        shop.shopCheck =! shop.shopCheck;
//        [self.listShopView reloadData];
//        
//    }
//    else {
       InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:indexPath.row];

        if (listType == MainList) {
            ARDetailViewController *detailViewController = [[ARDetailViewController alloc] initWithShop:positionEntity];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        else{
            [self.delegate showDetailInMapView:positionEntity];
        }
    
//   }
}


- (void)bnShoptCellDidClickedAtCell:(ARPositionCell *)shopCell
{
    if (!editing) {
        NSIndexPath *indexPathCell = [self.listShopView indexPathForCell:shopCell];
        BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPathCell.row];
        BeNCOneShopARViewController *oneShopAR = [[BeNCOneShopARViewController alloc]initWithShop:shopEntity];
        [self.navigationController pushViewController:oneShopAR animated:YES];
        [oneShopAR release];
    }
}


- (IBAction)editList:(id)sender
{
    editing =! editing;
    if (editing) {
        [arrayButtonItem removeObjectAtIndex:1];
        self.navigationItem.rightBarButtonItems = arrayButtonItem;
        for (int  i = 0; i < [shopsArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
            shopEntity.shopCheck = 1;
        }  
        [self.listShopView reloadData];
    }
    else {
        [arrayButtonItem addObject:refreshButtonItem];
        self.navigationItem.rightBarButtonItems = arrayButtonItem;
        for (int  i = 0; i < [shopsArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
            
            if (shopEntity.shopCheck == 0) {
                [shopsArray removeObject:shopEntity];
            }
        }
        [self.listShopView reloadData];
        for (int  i = 0; i < [shopsArray count]; i ++) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
            shopEntity.shopCheck = 0;
        } 
        [self.listShopView reloadData];

        }


}
- (void)dealloc
{
    [arrayPosition release];
    [shopsArray release];
    [arrayButtonItem release];
    [editButton release];
    [refreshButtonItem release];
    [userLocation release];
    [listShopView release];
    [super dealloc];
}
@end
