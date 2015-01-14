//
//  ViewController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "ViewController.h"

static CGFloat expandedHeight = 100.0;
static CGFloat contractedHeight = 44.0;

@interface ViewController ()

@property (strong,nonatomic) NSArray *cheaterList;
@property (strong, nonatomic) NSArray *resultList;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;

@end

@implementation ViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultList = [[NSArray alloc] init];
    PFQuery *retrieveCheaters = [PFQuery queryWithClassName:@"CheaterList"];
    [retrieveCheaters findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //NSLog(@"%@", objects); //Test for pull
        if (!error) {
            self.cheaterList = [[NSArray alloc] initWithArray:objects];
            [tableView reloadData];
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"cheater count: %lu", self.cheaterList.count);//for testing
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.resultList.count;
    }
    else{
        return self.cheaterList.count;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // -- Cell Creation --
    static NSString *cellID = @"customCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    //-- Differentiate between search and non --
    PFObject * tempObj;
    //Populate cell with resultList if anything in searchBar
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tempObj = [self.resultList objectAtIndex:indexPath.row];
    }
    else{
        //Else populate cell with cheaterList
        tempObj = [self.cheaterList objectAtIndex:indexPath.row];
    }
    
    //-- Assign Values --
    cell.textLabel.text = [tempObj objectForKey:@"foo"];
    int score = [[tempObj objectForKey:@"rating"] intValue];
    if (score == 1) {
        cell.detailTextLabel.text = @"Under Investigation";
    }
    else if (score == 2){
        cell.detailTextLabel.text = @"Possibly a Cheater";
    }
    else if (score == 3){
        cell.detailTextLabel.text = @"Probably a Cheater";
    }
    else if (score == 4){
        cell.detailTextLabel.text = @"Suspected Cheater";
    }
    else if (score == 5){
        cell.detailTextLabel.text = @"Known Cheater";
    }
    cell.detailTextLabel.textColor = [UIColor grayColor];
    NSLog(@"%@%@%@", cell.textLabel.text, [tempObj objectForKey:@"foo"],cell.detailTextLabel.text); //Test for pull
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates]; // tell the table you're about to start making changes
    
    // If the index path of the currently expanded cell is the same as the index that
    // has just been tapped set the expanded index to nil so that there aren't any
    // expanded cells, otherwise, set the expanded index to the index that has just
    // been selected.
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
    } else {
        self.expandedIndexPath = indexPath;
    }
    
    [tableView endUpdates]; // tell the table you're done making your changes
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If row was clicked expand the height of the cell
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        return expandedHeight; // Expanded height
    }
    return contractedHeight; // Normal height
}


#pragma Search Results

- (void) filterContentForSearchText: (NSString *) searchText scope:(NSString *) scope{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.foo beginswith[c] %@", searchText];
    self.resultList = [self.cheaterList filteredArrayUsingPredicate:predicate];
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText: searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

@end
