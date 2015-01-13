//
//  TableViewController.h
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TableViewController : UITableViewController{
    NSArray *cheaterArray;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
