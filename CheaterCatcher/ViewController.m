//
//  ViewController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/12/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"

static CGFloat expandedHeight = 100.0;
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
    self.resultList = [[NSArray alloc] init];
    PFQuery *retrieveCheaters = [PFQuery queryWithClassName:@"CheaterList"];
    [retrieveCheaters findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
    //Always only one list displayed at a time so we can keep this at one
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.resultList.count == 0) {
            UITableView *tableView = self.searchDisplayController.searchResultsTableView;
            for( UIView *subview in tableView.subviews ) {
                if( [subview class] == [UILabel class] ) {
                    UILabel *lbl = (UILabel*)subview; // sv changed to subview.
                    //Change text of no results
                    NSString *str = [self.searchDisplayController.searchBar.text stringByAppendingString:@" is Not a Known Cheater"];
                    lbl.text = str;
                    //Change color of no results
                    lbl.textColor = [UIColor blackColor];
                }
            }
        }
        //User typed something in the searchbar so look in the resultList
        return self.resultList.count;
    }
    else {
        //User didn't type something in the searchbar so look in the cheaterList
        return self.cheaterList.count;
    }
}

//TODO: REFACTOR!!!!
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // -- Cell Creation --
    static NSString *cellID = @"customCell";
    CustomCell *customCell = (CustomCell*)[self.tableView dequeueReusableCellWithIdentifier:cellID];
    if(customCell == nil)
    {
        customCell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    //-- Differentiate between search and non search --
    PFObject * tempObj;
    int row = indexPath.row;
    //Populate cell with resultList if anything in searchBar
    if (tableView == self.searchDisplayController.searchResultsTableView) {
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
    //Hiding extra pictures
    customCell.customRating.textColor = [UIColor grayColor];
    customCell.customPicOne.image = nil;
    customCell.customPicTwo.image = nil;
    customCell.customPicThree.image = nil;

    //Hiding buttons
    customCell.customAddEvidenceButton.hidden = true;
    
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

    }
   // NSLog(@"%@%@%@", customCell.customName.text, [tempObj objectForKey:@"foo"],customCell.customRating.text); //Test for pull
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
    
    if ([indexPath compare:self.expandedIndexPath] == NSOrderedSame) {
        self.expandedIndexPath = nil;
    } else {
        self.expandedIndexPath = indexPath;
        CustomCell *customCell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        //Expanded Cell Assigning values - Testing fade, once array of pics is up on parse we can change this to a loop for the images
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
            [UIView animateWithDuration:0.8 animations:^{
                customCell.customAddEvidenceButton.alpha = 1;
            }];
        }
        
    }
    
    [self.tableView endUpdates]; // tell the table you're done making your changes
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CustomCell *customCell = [self.tableView cellForRowAtIndexPath:indexPath];
    customCell.customPicOne.image = nil;
    customCell.customPicTwo.image = nil;
    customCell.customPicThree.image = nil;
    
    //Hiding buttons
    customCell.customAddEvidenceButton.hidden = true;
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

#pragma Uploading Image for Existing Cheater

- (IBAction)getPhoto:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //TODO: Get the local array, add the image to it and push to parse
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end










