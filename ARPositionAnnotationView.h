//
//  BeNCAnnotationView.h
//  ARShop
//
//  Created by Applehouse on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EGOImageView.h"
@interface ARPositionAnnotationView : MKAnnotationView{
    EGOImageView *backgroudImage;
    UIImageView *numberImageView;
    UILabel *numberlb;
}
@property(nonatomic,strong)  EGOImageView *backgroudImage;
@property(nonatomic,strong)  UIImageView *numberImageView;
@property(nonatomic,strong)  UILabel *numberlb;
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;
@end
