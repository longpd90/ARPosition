//
//  BeNCShopCell.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EGOImageView.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
@class ARPositionCell;
@protocol ARPositionCellDelegate <NSObject>

@optional
- (void)bnShoptCellDidClickedAtCell:(ARPositionCell *)shopCell;
@end

@interface ARPositionCell: UITableViewCell{
    UIButton *checkbox ;
    UILabel *distanceToShop;
    EGOImageView *icon ;
    CLLocation *userLocation ;
    UILabel *labelAddress;
    UILabel *labelName;
    UIImageView *imageViewBackground;

}
@property (nonatomic, retain) UILabel *labelName;
@property (nonatomic, retain) UILabel *labelAddress;
@property (nonatomic,retain) EGOImageView *icon;
@property (nonatomic, retain)CLLocation *userLocation ;
@property (nonatomic, retain) id<ARPositionCellDelegate>delegate;
@property (nonatomic ,retain) UILabel *distanceToShop;
- (void)updateContentForCell:(InstanceData *)positionEntity withLocation:(CLLocation *)location;
-(int)calculeDistance:(InstanceData *)positionEntity withLocation:(CLLocation *)location;
@end
