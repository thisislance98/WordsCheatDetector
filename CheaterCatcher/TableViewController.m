//
//  TableViewController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self performSelector:@selector(retrieveFromParse)];//Test for pull
    
    PFQuery *retrieveCheaters = [PFQuery queryWithClassName:@"TestObject"];
    [retrieveCheaters findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSLog(@"%@", objects); //Test for pull
        if (!error) {
            cheaterArray = [[NSArray alloc] initWithArray:objects];
            NSLog(@"%@", cheaterArray); //Test for pull
            [self performSelector:@selector(retrieveFromParse)];//Test for pull
        }
    }];
    

}

- (void)retrieveFromParse {
    PFQuery *retrieveCheaters = [PFQuery queryWithClassName:@"TestObject"];
    [retrieveCheaters findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSLog(@"%@", objects); //Test for pull
        if (!error) {
            cheaterArray = [[NSArray alloc] initWithArray:objects];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;//Since we are just filling one section of cheaters for now
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"cheater count: %lu", cheaterArray.count);
    return cheaterArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CheaterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"CheaterCell" forIndexPath:indexPath];
    PFObject *tempObj = [cheaterArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [tempObj objectForKey:@"foo"];
    
    // Configure the cell...
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
