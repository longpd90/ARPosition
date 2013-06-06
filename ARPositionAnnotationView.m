//
//  BeNCAnnotationView.m
//  ARShop
//
//  Created by Applehouse on 1/3/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ARPositionAnnotationView.h"
#import "ARPositionAnnotation.h"
#define ANNOTATION_VIEW_WIDTH 57
#define ANNOTATION_VIEW_HEIGTH 64
@implementation ARPositionAnnotationView

@synthesize numberlb,numberImageView,backgroudImage;

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        backgroudImage = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"ARMapEgo.png"]];
        ARPositionAnnotation *shopannotation = (ARPositionAnnotation *)annotation;
        backgroudImage.imageURL =[NSURL URLWithString:shopannotation.position.imageUrl];
        [backgroudImage setFrame:CGRectMake(7, 7, 40, 40)];
        [self addSubview:backgroudImage];
        
        numberImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"numberView.png"]];
        numberImageView.frame = CGRectMake(40, 40, 20, 20);
        
        numberlb = [[UILabel alloc]initWithFrame:numberImageView.frame];
        
        numberlb.textColor = [UIColor whiteColor];
        numberlb.backgroundColor = [UIColor clearColor];
        numberlb.textAlignment = UITextAlignmentCenter;
        numberlb.font = [UIFont systemFontOfSize:10];
        numberlb.text = @"1";
        
        UIImage *img = [UIImage imageNamed:@"MapFrame.png"];
        self.image = img;
        [self addSubview:self.numberImageView];
        [self addSubview:self.numberlb];
        [self setFrame:CGRectMake(0, 0, ANNOTATION_VIEW_WIDTH  , ANNOTATION_VIEW_HEIGTH)];
        [self setCenterOffset:CGPointMake(self.frame.origin.x, self.frame.origin.y-25)];
                       // Initialization code
    }
    return self;

}

@end
