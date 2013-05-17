//
//  BeNCShopCellCell.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARPositionCell.h"
#import "BeNCShopEntity.h"

@implementation ARPositionCell
@synthesize distanceToShop,delegate,userLocation;
@synthesize icon;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        distanceToShop = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        icon = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"images.png"]];
        icon.frame = CGRectMake(5, 5, 50, 50);
        [self addSubview:self.icon];
            }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)touchesToButtonDistance
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bnShoptCellDidClickedAtCell:)]) {
        [self.delegate bnShoptCellDidClickedAtCell:self];
    }
}
- (void)updateContentForCell:(InstanceData *)positionEntity withLocation:(CLLocation *)location
{    
    [distanceToShop setFrame:CGRectMake(330, 5, 90, 50)];
    [distanceToShop addTarget:self action:@selector(touchesToButtonDistance) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:distanceToShop];
    
    self.textLabel.text = positionEntity.label;
    self.detailTextLabel.text = positionEntity.address;
    self.imageView.image = [UIImage imageNamed:@"blank.png"];
    self.icon.imageURL = [NSURL URLWithString:positionEntity.imageUrl];
    NSString *distanceShop = [NSString stringWithFormat:@"%d m",[self calculeDistance:positionEntity withLocation:location]];
    [self.distanceToShop setTitle:distanceShop forState:UIControlStateNormal];
}

-(int)calculeDistance:(InstanceData *)positionEntity withLocation:(CLLocation *)location
{
    CLLocation *shoplocation = [[CLLocation alloc]initWithLatitude:positionEntity.latitude longitude:positionEntity.longitude];
    int distance = (int)[shoplocation distanceFromLocation:location];
    [shoplocation release];
    return distance;

}


//-(void)checkboxSelected:(id)sender
//{
//    checkBoxSelected = !checkBoxSelected;
//    [checkbox setSelected:checkBoxSelected];
////    if (self.delegate && [self.delegate respondsToSelector:@selector(beNCShopCellDidCleckCheckButton:)]) {
////        [self.delegate beNCShopCellDidCleckCheckButton:self];
////    }
//}
- (void)dealloc
{
    [icon release];
    [distanceToShop release];
    [super dealloc];
}

@end
