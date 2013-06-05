//
//  ARSelectType.h
//  ARPosition
//
//  Created by Duc Long on 6/5/13.
//
//

#import <UIKit/UIKit.h>
@protocol ARSelectTypeDelegate <NSObject>

@optional
- (void) setforRowTable :(NSString * )typeString;

@end
@interface ARSelectType : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tableViewSelect;
    NSArray *arrayType;

}
@property (nonatomic, retain) id<ARSelectTypeDelegate> delegate;


@end
