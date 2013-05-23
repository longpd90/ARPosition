//
//  BeNCShopCellCell.m
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ARPositionCell.h"

@implementation ARPositionCell
@synthesize distanceToShop,delegate,userLocation,labelAddress,labelName;
@synthesize icon;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageViewBackground = [[UIImageView alloc]init];
        UIImage *imageBackground = [UIImage imageNamed:@"BackgroudCell.png"];
        imageViewBackground.image = imageBackground;
        [self addSubview:imageViewBackground];
        distanceToShop = [[UILabel alloc]initWithFrame:CGRectMake(375, 5, 90, 50)];
        [distanceToShop setBackgroundColor:[UIColor clearColor]];
        [distanceToShop setFont:[UIFont boldSystemFontOfSize:18]];
        distanceToShop.textAlignment = NSTextAlignmentCenter;
//        [distanceToShop addTarget:self action:@selector(touchesToButtonDistance) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:distanceToShop];
        
        icon = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"EgoImageCell.png"]];
        icon.frame = CGRectMake(5, 5, 50, 50);
        [self addSubview:self.icon];
        
        labelAddress = [[UILabel alloc]init];
        [labelAddress setFont:[UIFont systemFontOfSize:14]];
        labelAddress.backgroundColor = [UIColor clearColor];
        [self addSubview:labelAddress];
        
        labelName = [[UILabel alloc]init];
        [labelName setFont:[UIFont boldSystemFontOfSize:16]];
        [labelName setBackgroundColor:[UIColor clearColor]];
        [labelName setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:labelName];
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
    labelName.text = positionEntity.label;
    CGSize labelShopNameSize = [positionEntity.address sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    labelName.frame = CGRectMake(65, 0, 300, labelShopNameSize.height);
    labelName.numberOfLines = 0;
    labelAddress.text = positionEntity.address;
    CGSize labelShopAddresSize = [positionEntity.address sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    labelAddress.frame = CGRectMake(65, labelShopNameSize.height, 300, labelShopAddresSize.height) ;
    labelAddress.numberOfLines = 0;
    imageViewBackground.frame = CGRectMake(0, 0, 480, labelShopNameSize.height + labelShopAddresSize.height +2);

    self.imageView.image = [UIImage imageNamed:@"blank.png"];
    icon.imageURL = [NSURL URLWithString:positionEntity.imageUrl];
    NSString *distanceShop = [NSString stringWithFormat:@"%d m",[self calculeDistance:positionEntity withLocation:location]];
    self.distanceToShop.text = distanceShop;
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
    [labelAddress release];
    [icon release];
    [distanceToShop release];
    [super dealloc];
}

@end
