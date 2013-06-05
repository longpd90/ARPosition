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
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelAddress;
@property (nonatomic,strong) EGOImageView *icon;
@property (nonatomic, strong)CLLocation *userLocation ;
@property (nonatomic, strong) id<ARPositionCellDelegate>delegate;
@property (nonatomic ,strong) UILabel *distanceToShop;
- (void)updateContentForCell:(InstanceData *)positionEntity withLocation:(CLLocation *)location;
-(int)calculeDistance:(InstanceData *)positionEntity withLocation:(CLLocation *)location;
@end
