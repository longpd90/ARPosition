//
//  BeNCDetailShopInCamera.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARDetailPositionInView.h"
#import "LocationService.h"
#import <QuartzCore/QuartzCore.h>
#define textSize 18
#define max 100000

@implementation ARDetailPositionInView
@synthesize labelDistanceToShop,labelShopName;
@synthesize userLocation;
@synthesize delegate,position,imageViewBackground,starView;

- (id)initWithShop:(InstanceData *)positionEntity
{
    self = [super init];
    if (self) {
        UIImage *imageBackground = [UIImage imageNamed:@"BackgroudCell.png"];
        imageViewBackground = [[UIImageView alloc]init];
        imageViewBackground.image = imageBackground;
        [self addSubview:imageViewBackground];
        
        icon = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"EgoImageCell.png"]];
        icon.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:icon];
        
        position = positionEntity;
        userLocation = [[LocationService sharedLocation]getOldLocation];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didUpdateLocation:) name:@"UpdateLocation" object:nil];
        labelShopName = [[UILabel alloc]init];
        [labelShopName setBackgroundColor:[UIColor clearColor]];
        labelDistanceToShop = [[UILabel alloc]init];
        [labelDistanceToShop setBackgroundColor:[UIColor clearColor]];
        [labelDistanceToShop setTextAlignment:NSTextAlignmentRight];
        labelDistanceToShop.text = [NSString stringWithFormat:@"%d m",[self caculateDistanceToShop:positionEntity]];

        [self addSubview:labelShopName];
        [self addSubview:labelDistanceToShop];
        [self.layer setCornerRadius:8];
        [self setContentDetailShop:positionEntity];
    }
    return self;
}

- (void)ratingChanged:(float)newRating
{
    
}
- (void)setContentDetailShop:(InstanceData *)positionEntity
{
    [labelDistanceToShop setFont:[UIFont systemFontOfSize:textSize - 2]];
    labelShopName.text = positionEntity.label;
    [labelShopName setFont:[UIFont boldSystemFontOfSize:textSize - 2]];
    labelShopName.numberOfLines = 0;
    CGSize labelShopNameSize = [positionEntity.label sizeWithFont:[UIFont boldSystemFontOfSize:textSize - 2] constrainedToSize:CGSizeMake(190, max) lineBreakMode:UILineBreakModeCharacterWrap];
    
    starView = [[RatingView alloc]init];
    starView.frame = CGRectMake(53, labelShopNameSize.height, 130, 25);
    [self addSubview:starView];
    [starView setImagesDeselected:@"StarNoRate.png" partlySelected:@"StarNoRate.png" fullSelected:@"StarRated.png" andDelegate:self];
	[starView displayRating:positionEntity.rating];
    
    labelShopName.frame = CGRectMake(50, 0,190,labelShopNameSize.height );
    labelDistanceToShop.frame = CGRectMake(53 , labelShopNameSize.height,190, 25);
    imageViewBackground.frame = CGRectMake(0, 0, 190 + 57, labelShopNameSize.height + 30);
    icon.imageURL = [NSURL URLWithString:positionEntity.imageUrl];
}

- (int)caculateDistanceToShop:(InstanceData *)positionEntity
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    int distance = (int)[shoplocation distanceFromLocation: self.userLocation];
    return distance;
}

-(void)didUpdateLocation:(NSNotification *)notification {
    CLLocation *newLocation = (CLLocation *)[notification object];
    userLocation = [[CLLocation alloc]initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    labelDistanceToShop.text = [NSString stringWithFormat:@"%dm",[self caculateDistanceToShop:position]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchesToView)]) {
        [self.delegate didTouchesToView];
    }
}

@end
