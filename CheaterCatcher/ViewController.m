//
//  ViewController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PFObject *testObject = [PFObject objectWithClassName:@"CheaterList"];
    testObject[@"foo"] = @"Toliy";
    [testObject saveInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
