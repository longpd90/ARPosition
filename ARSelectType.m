//
//  ARSelectType.m
//  ARPosition
//
//  Created by Duc Long on 6/5/13.
//
//

#import "ARSelectType.h"

@implementation ARSelectType

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        arrayType = [[NSArray alloc]initWithObjects:@"Place",@"Bank Resource",@"Tourist Resource",@"Accomodation",@"Dinning Service", nil];
        tableViewSelect = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 175)];
        [tableViewSelect setDelegate:self];
        [tableViewSelect setDataSource:self];
        [self addSubview:tableViewSelect];
        // Initialization code
    }
    return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    }
    cell.textLabel.text = [arrayType objectAtIndex:[indexPath row]];
    [cell.textLabel setTextAlignment:UITextAlignmentCenter];
    return  cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *typeString = (NSString *)[arrayType objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(setforRowTable:)]) {
        [self.delegate setforRowTable:typeString];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

@end
