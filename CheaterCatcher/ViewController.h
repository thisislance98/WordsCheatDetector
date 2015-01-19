//
//  ViewController.h
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UIImagePickerController *picker;
    UIImage *image;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)getPhoto:(id)sender;
@end

