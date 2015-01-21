//
//  ViewController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "ReportPlayerController.h"

static CGFloat expandedHeight = 135.0;
static CGFloat contractedHeight = 44.0;
int flag = 0;
@interface ViewController ()

@property (strong,nonatomic) NSArray *cheaterList;
@property (strong, nonatomic) NSArray *resultList;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;

@end

@implementation ViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //Create arrays and populate the first list
    self.resultList = [[NSArray alloc] init];
    PFQuery *retrieveCheaters = [PFQuery queryWithClassName:@"CheaterList"];
    [retrieveCheaters findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.cheaterList = [[NSArray alloc] initWithArray:objects];
            flag = 0;
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
    //Always only one list displayed at a time so we can keep this at one
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.searchDisplayController.searchBar.text isEqualToString:@""]) {
        if (self.resultList.count == 0) {
            return 1;
        }
        //User typed something in the searchbar so look in the resultList
        return self.resultList.count;
    }
    else {
        //User didn't type something in the searchbar so look in the cheaterList
        return self.cheaterList.count;
    }
}

#warning TODO: REFACTOR
- (void)addExtraContentToCell:(CustomCell *)customCell indexPath:(NSIndexPath *)indexPath {
    if (self.expandedIndexPath.row == indexPath.row && flag == 1) {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"WWFthree" ofType:@"png"];
        UIImage *myImageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
        NSString *imagePath2 = [[NSBundle mainBundle] pathForResource:@"WWFtwo" ofType:@"png"];
        UIImage *myImageObj2 = [[UIImage alloc] initWithContentsOfFile:imagePath2];
        NSString *imagePath3 = [[NSBundle mainBundle] pathForResource:@"WWFone" ofType:@"png"];
        UIImage *myImageObj3 = [[UIImage alloc] initWithContentsOfFile:imagePath3];
        
        [UIView transitionWithView:customCell.customPicOne
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^{
                            customCell.customPicOne.image = myImageObj;
                        } completion:nil];
        [UIView transitionWithView:customCell.customPicTwo
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^{
                            customCell.customPicTwo.image = myImageObj2;
                        } completion:nil];
        [UIView transitionWithView:customCell.customPicThree
                          duration:0.8f
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^{
                            customCell.customPicThree.image = myImageObj3;
                        } completion:nil];
        
        //Making button visible
        customCell.customAddEvidenceButton.alpha = 0;
        customCell.customAddEvidenceButton.hidden = false;
        [UIView animateWithDuration:1.0 animations:^{
            customCell.customAddEvidenceButton.alpha = 1;
        }];
        
        customCell.customSeeEvidenceButton.alpha = 0;
        customCell.customSeeEvidenceButton.hidden = false;
        [UIView animateWithDuration:1.0 animations:^{
            customCell.customSeeEvidenceButton.alpha = 1;
        }];
        
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // -- Cell Creation --
    static NSString *cellID = @"customCell";
    CustomCell *customCell = (CustomCell*)[self.tableView dequeueReusableCellWithIdentifier:cellID];
    if(customCell == nil)
    {
        customCell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //Hiding extra pictures
    customCell.customRating.textColor = [UIColor grayColor];
    customCell.customPicOne.image = nil;
    customCell.customPicTwo.image = nil;
    customCell.customPicThree.image = nil;
    
    //Hiding buttons
    customCell.customAddEvidenceButton.hidden = true;
    customCell.customSeeEvidenceButton.hidden = true;

    //-- Differentiate between search and non search --
    PFObject * tempObj;
    //int row = indexPath.row;
    
    //Populate cell with resultList if anything in searchBar
    if (![self.searchDisplayController.searchBar.text isEqualToString:@""]) {
        //If no results then let them know that this is not a suspected cheater
        if (self.resultList.count == 0) {
            customCell.customName.text = self.searchDisplayController.searchBar.text;
            customCell.customRating.text = @"Is not a Suspected Cheater";
            customCell.customAddEvidenceButton.hidden = NO;
            [customCell.customAddEvidenceButton setTitle:@"Report" forState:UIControlStateNormal];
            return customCell;
        }
        tempObj = [self.resultList objectAtIndex:indexPath.row];
    }
    else{
        //Else populate cell with cheaterList
        tempObj = [self.cheaterList objectAtIndex:indexPath.row];
    }
    
    //-- Assign Values --
    customCell.customName.text = [tempObj objectForKey:@"foo"];
    int score = [[tempObj objectForKey:@"rating"] intValue];
    if (score == 1) {
        customCell.customRating.text = @"Under Investigation";
    }
    else if (score == 2){
        customCell.customRating.text = @"Possibly a Cheater";
    }
    else if (score == 3){
        customCell.customRating.text = @"Probably a Cheater";
    }
    else if (score == 4){
        customCell.customRating.text = @"Suspected Cheater";
    }
    else if (score == 5){
        customCell.customRating.text = @"Known Cheater";
    }
    
    NSString *objectID = [tempObj objectId];
    
    [self addExtraContentToCell:customCell indexPath:indexPath];
    NSLog(@"Loading Cell: %@ %@", customCell.customName.text, customCell.customRating.text); //Test for pull
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates]; // tell the table you're about to start making changes
    flag = 1;
    // If the index path of the currently expanded cell is the same as the index that
    // has just been tapped set the expanded index to nil so that there aren't any
    // expanded cells, otherwise, set the expanded index to the index that has just
    // been selected.
    
    //Get the cell in question
    CustomCell *customCell = [tableView cellForRowAtIndexPath:indexPath];

    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        #warning TODO: Add in animation for leaving cell?
        self.expandedIndexPath = nil;
        //Hiding extra pictures
        customCell.customRating.textColor = [UIColor grayColor];
        CustomCell *customCell = [self.tableView cellForRowAtIndexPath:indexPath];
        customCell.customPicOne.image = nil;
        customCell.customPicTwo.image = nil;
        customCell.customPicThree.image = nil;
        //Hiding buttons
        customCell.customAddEvidenceButton.hidden = true;
        customCell.customSeeEvidenceButton.hidden = true;
    }
    else {
        self.expandedIndexPath = indexPath;
        //Expanded Cell Assigning values - Testing fade, once array of pics is up on parse we can change this to a loop for the images
        [self addExtraContentToCell:customCell indexPath:indexPath];
        
    }
    
    [self.tableView endUpdates]; // tell the table you're done making your changes
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *customCell = [self.tableView cellForRowAtIndexPath:indexPath];
    customCell.customPicOne.image = nil;
    customCell.customPicTwo.image = nil;
    customCell.customPicThree.image = nil;
    //Hiding buttons
    customCell.customAddEvidenceButton.hidden = true;
    customCell.customSeeEvidenceButton.hidden = true;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    flag = 0;
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
    [self.tableView reloadData];
}

- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText: searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    NSLog(@"User canceled search");
    [searchBar resignFirstResponder];// if you want the keyboard to go away
    self.searchDisplayController.searchBar.text = @"";
    [self.tableView reloadData];
}

#pragma Cell Animations

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

#pragma Segue Stuff
- (IBAction)reportDoneButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"reportDonePush" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"reportDonePush"]) {
        
        // Get destination view
        ReportPlayerController *vc = [segue destinationViewController];
        
        // Get name
        NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
        NSString *tagIndex;
        PFObject *thisObjectPF;
        if (selectedIndexPath == nil) {
            tagIndex = self.searchDisplayController.searchBar.text;
        }
        else{
            CustomCell *customCell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            tagIndex = customCell.customName.text;
            if ([self.searchDisplayController.searchBar.text isEqualToString:@""]) {
                thisObjectPF = [self.cheaterList objectAtIndex:selectedIndexPath.row];
            }
            else if (self.resultList.count != 0){
                thisObjectPF = [self.resultList objectAtIndex:selectedIndexPath.row];
            }
            else{
                thisObjectPF = nil;
            }
        }
        
        // Set the selected player to send
        [vc setSelectedPlayerName:tagIndex];
        [vc setSelectedPlayerObject:thisObjectPF];
        
    }
}

@end










