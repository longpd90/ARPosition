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
#import "ARPositionCell.h"
#import "ARAPositionViewController.h"
#import "EGOImageView.h"
#import "ARShopInRadar.h"
#define MainList 0
#define MapList 1

@interface ARListViewController ()

@end

@implementation ARListViewController
@synthesize listShopView,userLocation,distanceToShop;
@synthesize listType,delegate,arrayPosition;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userLocation = [[LocationService sharedLocation]getOldLocation];
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateData:) name:@"UpdateData" object:nil];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    refreshButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshData)];
    
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editList:)];
    arrayButtonItem =  [[NSMutableArray arrayWithObjects:editButton,refreshButtonItem, nil]retain];
    
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    self.listShopView.frame = CGRectMake(0, 0, 480, 320);
    listShopView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
    
    if (listType == MainList) {
        self.navigationItem.rightBarButtonItem = refreshButtonItem;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton,refreshButtonItem, nil];
    }
    else if(listType == MapList){
        //self.navigationItem.rightBarButtonItem = done;
        NSLog(@"map list");
    }
    [super viewDidLoad];
}

-(void)didUpdateData:(NSMutableArray *)arrayData {
    arrayPosition = arrayData;
    [self.listShopView reloadData];
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
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    
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
    arrayPosition = [[NSMutableArray alloc]initWithArray:shopArray];
    if (userLocation==nil) {
       userLocation = [[LocationService sharedLocation]getOldLocation]; 
    }
    [self.listShopView reloadData];
}


-(int)calculeDistance:(InstanceData *)positionEntity{

    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    int distance = (int)[shoplocation distanceFromLocation: userLocation];
    [shoplocation release];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notifi{
    CLLocation *newLocation = (CLLocation *)[notifi object];
    [userLocation release];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
//    [self sortShopByDistance];
    [self.listShopView reloadData];
}

//- (void)refreshData
//{
//    if (!editing) {
//        shopsArray = [[NSMutableArray alloc]initWithArray:[[BeNCProcessDatabase sharedMyDatabase] arrayShop]];
//        [self sortShopByDistance];
//        [self.listShopView reloadData];
//    }
//
//}


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
    InstanceData *positionEntity = [arrayPosition objectAtIndex:indexPath.row];
    return [self heightofCell:positionEntity];
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
            ARAPositionViewController *detailViewController = [[ARAPositionViewController alloc] initWithShop:positionEntity];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        else{
            [self.delegate showDetailInMapView:positionEntity];
        }
    
//   }
}
-(CGFloat)heightofCell:(InstanceData *)positionEntity
{
    CGSize labelShopNameSize = [positionEntity.address sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize labelShopAddresSize = [positionEntity.address sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    float results = labelShopAddresSize.height + labelShopNameSize.height;
    return results;
    
}

- (void)bnShoptCellDidClickedAtCell:(ARPositionCell *)shopCell
{
//    if (!editing) {
        NSIndexPath *indexPathCell = [self.listShopView indexPathForCell:shopCell];
        InstanceData *positionEntity = (InstanceData *)[arrayPosition objectAtIndex:indexPathCell.row];
        ARAPositionViewController *oneShopAR = [[ARAPositionViewController alloc]initWithShop:positionEntity];
        [self.navigationController pushViewController:oneShopAR animated:YES];
        [oneShopAR release];
//    }
}

//
//- (IBAction)editList:(id)sender
//{
//    editing =! editing;
//    if (editing) {
//        [arrayButtonItem removeObjectAtIndex:1];
//        self.navigationItem.rightBarButtonItems = arrayButtonItem;
//        for (int  i = 0; i < [shopsArray count]; i ++) {
//            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
//            shopEntity.shopCheck = 1;
//        }  
//        [self.listShopView reloadData];
//    }
//    else {
//        [arrayButtonItem addObject:refreshButtonItem];
//        self.navigationItem.rightBarButtonItems = arrayButtonItem;
//        for (int  i = 0; i < [shopsArray count]; i ++) {
//            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
//            
//            if (shopEntity.shopCheck == 0) {
//                [shopsArray removeObject:shopEntity];
//            }
//        }
//        [self.listShopView reloadData];
//        for (int  i = 0; i < [shopsArray count]; i ++) {
//            BeNCShopEntity *shopEntity = (BeNCShopEntity *)[shopsArray objectAtIndex:i];
//            shopEntity.shopCheck = 0;
//        } 
//        [self.listShopView reloadData];
//
//        }
//
//
//}
- (void)dealloc
{
    [arrayPosition release];
    [arrayButtonItem release];
    [editButton release];
    [refreshButtonItem release];
    [userLocation release];
    [listShopView release];
    [super dealloc];
}
@end
