//
//  CustomCell.h
//  CheaterCatcher
//
//  Created by Toliy on 1/14/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *customName;
@property (weak, nonatomic) IBOutlet UILabel *customRating;

@property (weak, nonatomic) IBOutlet UIImageView *customPicOne;
@property (weak, nonatomic) IBOutlet UIImageView *customPicTwo;
@property (weak, nonatomic) IBOutlet UIImageView *customPicThree;
@property (weak, nonatomic) IBOutlet UIImageView *customPicFour;

@property (weak, nonatomic) IBOutlet UIButton *customAddEvidenceButton;
@property (weak, nonatomic) IBOutlet UIButton *customSeeEvidenceButton;


@end
