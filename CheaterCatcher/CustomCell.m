//
//  CustomCell.m
//  CheaterCatcher
//
//  Created by Toliy on 1/14/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize customName;
@synthesize customRating;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
}

- (IBAction)uploadPhoto:(id)sender {

    
}
@end
