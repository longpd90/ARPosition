//
//  ARSettingViewController.m
//  ARPosition
//
//  Created by Duc Long on 6/4/13.
//
//

#import "ARSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationService.h"

@interface ARSettingViewController ()

@end

@implementation ARSettingViewController
@synthesize zoomLabel,sliderDistance,arrayPosition;
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
    [[LocationService sharedLocation]startUpdate];
    userLocation = [[LocationService sharedLocation]getOldLocation];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.view.bounds = CGRectMake(0, 0, 480, 320);
    UIImageView *imageViewBackground = [[UIImageView alloc]initWithFrame:self.view.bounds];
    UIImage *imageBackground = [UIImage imageNamed:@"BackgroudCell.png"];
    imageViewBackground.image = imageBackground;
    [self.view addSubview:imageViewBackground];
    sliderDistance = [[UISlider alloc]initWithFrame:CGRectMake(120, 60, 300, 20)];
    sliderDistance.maximumValue = 20;
    sliderDistance.value = 10;
    sliderDistance.minimumValue = 1;
    [sliderDistance addTarget:self action:@selector(changeValueSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:sliderDistance];
    
    zoomLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 40, 60, 20)];
    zoomLabel.text = [NSString stringWithFormat:@"10km"];
    zoomLabel.textColor = [UIColor blackColor];
    zoomLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:zoomLabel];
    
    buttonSelectType = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonSelectType.frame = CGRectMake(120, 140, 300, 50) ;
    [buttonSelectType setTitle:@"Place" forState:UIControlStateNormal];
    [buttonSelectType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSelectType.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [buttonSelectType addTarget:self action:@selector(SelectOption:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSelectType];
    
    labelType = [[UILabel alloc]initWithFrame:CGRectMake(30, 140, 70, 50)];
    [labelType setTextAlignment:NSTextAlignmentCenter];
    [labelType setFont:[UIFont boldSystemFontOfSize:16]];
    labelType.text = @"Type";
    [labelType.layer setCornerRadius:8];
    [self.view addSubview:labelType];
    
    UILabel *labelRadius = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 70, 50)];
    [labelRadius setTextAlignment:NSTextAlignmentCenter];
    [labelRadius setFont:[UIFont boldSystemFontOfSize:16]];
    labelRadius.text = @"Radius";
    [labelRadius.layer setCornerRadius:8];
    [self.view addSubview:labelRadius];
    
    UIButton *buttonSumit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonSumit.frame = CGRectMake(220, 205, 70, 50) ;
    [buttonSumit setTitle:@"Submit" forState:UIControlStateNormal];
    [buttonSumit addTarget:self action:@selector(Submit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSumit];
    tableSelect = [[ARSelectType alloc]initWithFrame:CGRectMake(120, 110, 300, 175)];
    tableSelect.delegate = self;
    
    [self.view addSubview:tableSelect];
    tableSelect.hidden = YES;


    [super viewDidLoad];
    TypePlace = -1;
    Radius = 10;
   
}

- (IBAction)changeValueSlider:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    int valueInt = (int)slider.value;
    Radius = valueInt;
    zoomLabel.text = [NSString stringWithFormat:@"%dkm",valueInt];
    CGPoint centerLabel;
    centerLabel.x = valueInt * 15 + 120;
    centerLabel.y = 50;
    zoomLabel.center = centerLabel;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateRadius" object:[NSNumber numberWithInt:valueInt]];

}

- (void)setforRowTable:(NSString *)typeString
{
    [buttonSelectType setTitle:typeString forState:UIControlStateNormal];
    tableSelect.hidden = YES;
    selectOption = 0;
    if ([typeString isEqualToString:@"Place"]) {
        TypePlace = -1;
    }
    else  if ([typeString isEqualToString:@"Bank Resource"]) {
        TypePlace = 0;
    }
    else  if ([typeString isEqualToString:@"Tourist Resource"]) {
        TypePlace = 1;
    }
    else  if ([typeString isEqualToString:@"Accomodation"]) {
        TypePlace = 2;
    }
    else  if ([typeString isEqualToString:@"Dinning Service"]) {
        TypePlace = 3;
    }
}
- (IBAction)SelectOption:(id)sender
{
    if (selectOption == 0) {
        tableSelect.hidden = NO;
        selectOption = 1;
    } else {
        tableSelect.hidden = YES;
        selectOption = 0;
    }
}
- (IBAction)Submit:(id)sender
{
    [self getData:Radius withPageSize:8 withPageIndex:1 withCatagory:TypePlace withLanguage:@"vn"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)didcConnectSuccess
{
    
}
- (void)setViewConnectFail
{
    
}

- (void)getData:(float)radius withPageSize:(int)pageSize withPageIndex:(int)pageIndex withCatagory:(int)catagory  withLanguage:(NSString *)language {
    ArroundPlaceService * dataPlace = [[ArroundPlaceService alloc]init];
    dataPlace.delegate = self;
    [dataPlace getArroundPlaceWithLatitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude] radius:radius pageSize:pageSize pageIndex:pageIndex category:catagory language:language];
}


- (void)requestDidFinish:(ArroundPlaceService *)controller withResult:(NSArray *)results
{
    arrayPosition = [NSMutableArray arrayWithArray:results];
    if (arrayPosition.count > 0) {
        [self sortShopByDistance];
        [self didcConnectSuccess];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UpdateData" object:arrayPosition];

    }
    else{
        [self setViewConnectFail];
    }
}

- (void)requestDidFail:(ArroundPlaceService *)controller withError:(NSError *)error
{
    NSLog(@"error : %@",error);
    [self setViewConnectFail];
}

- (void)sortShopByDistance
{
    for (int i = 0; i < [arrayPosition count]; i ++) {
        for (int j = i + 1; j < [arrayPosition count]; j ++) {
            if ([self calculeDistance:[arrayPosition objectAtIndex:i]] > [self calculeDistance:[arrayPosition objectAtIndex:j]])
                [arrayPosition exchangeObjectAtIndex:i withObjectAtIndex:j];
        }
    }
}
- (float)calculeDistance:(InstanceData *)positionEntity{
    
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    float distance = [shoplocation distanceFromLocation: userLocation];
    return distance;
}

@end
