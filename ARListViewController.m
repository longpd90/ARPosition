//
//  BeNCListViewController.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARListViewController.h"
#import "LocationService.h"
#import "BeNCDetailViewController.h"
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
@synthesize listType,delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];
        [self getShopData];
        [self sortShopByDistance];

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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark getdata
-(void)getShopDataFromMap:(NSArray *)shopArray{
    NSLog(@"get shop data from map");
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
    return [shopsArray count];
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
    BeNCShopEntity *shop  = [shopsArray objectAtIndex:indexPath.row];
    if (shop.shopCheck == 1) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone ;
    }
    if (listType == MapList) {
        cell.distanceToShop.hidden = YES;
    }
    [cell updateContentForCell:shop withLocation:userLocation];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editing) {
        BeNCShopEntity *shop  = [shopsArray objectAtIndex:indexPath.row];
        shop.shopCheck =! shop.shopCheck;
        [self.listShopView reloadData];
        
    }
    else {
        
        
        
        if (listType == MainList) {
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPath.row];
            BeNCDetailViewController *detailViewController = [[BeNCDetailViewController alloc] initWithShop:shopEntity];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        else{
            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:indexPath.row];
            [self.delegate showDetailInMapView:shopEntity];
        }
    
   }
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
    [shopsArray release];
    [arrayButtonItem release];
    [editButton release];
    [refreshButtonItem release];
    [userLocation release];
    [listShopView release];
    [super dealloc];
}
@end
