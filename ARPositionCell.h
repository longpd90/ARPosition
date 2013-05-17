//
//  BeNCShopCell.h
//  ARShop
//
//  Created by Administrator on 12/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeNCShopEntity.h"
#import "EGOImageView.h"
@class ARPositionCell;
@protocol ARPositionCellDelegate <NSObject>

@optional
- (void)bnShoptCellDidClickedAtCell:(ARPositionCell *)shopCell;
- (void)beNCShopCellDidCleckCheckButton:(ARPositionCell *)shopCell;
@end

@interface ARPositionCell: UITableViewCell{
    UIButton *checkbox ;
    UIButton *distanceToShop;
    EGOImageView *icon ;
    CLLocation *userLocation ;

}
@property (nonatomic,retain) EGOImageView *icon;
@property (nonatomic, retain)CLLocation *userLocation ;
@property (nonatomic, retain) id<ARPositionCellDelegate>delegate;
@property (nonatomic ,retain) UIButton *distanceToShop;
- (void)updateContentForCell:(BeNCShopEntity *)shopEntity withLocation:(CLLocation *)location;
-(int)calculeDistance:(BeNCShopEntity *)shop withLocation:(CLLocation *)location;
@end
