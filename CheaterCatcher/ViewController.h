//
//  ViewController.h
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

