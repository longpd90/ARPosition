//
//  ARSettingViewController.h
//  ARPosition
//
//  Created by Duc Long on 6/4/13.
//
//

#import <UIKit/UIKit.h>
#import "ARSelectType.h"
#import <ArroundPlaceService/ArroundPlaceService.h>
#import <CoreLocation/CoreLocation.h>


@interface ARSettingViewController : UIViewController<ARSelectTypeDelegate,ServiceControllerDelegate>{
    UISlider *sliderDistance;
    UILabel *zoomLabel;
    ARSelectType *tableSelect;
    UILabel * labelType;
    BOOL selectOption;
    CLLocation *userLocation ;
    int Radius;
    int TypePlace;
    UIButton *buttonSelectType;
}
@property (nonatomic, strong) NSMutableArray *arrayPosition;

@property (nonatomic, strong) UISlider *sliderDistance;
@property (nonatomic, strong) UILabel *zoomLabel;

@end
