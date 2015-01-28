//
//  ReportPlayerController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/20/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "ReportPlayerController.h"
#import "ViewController.h"

@interface ReportPlayerController ()

@end

@implementation ReportPlayerController

@synthesize SelectedPlayerName, SelectedPlayerObject;

#warning TODO: still needs autolayout to be done before production

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.displayScreenShot.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.displayScreenShot.layer setBorderWidth: 2.0];
    self.attachComments.layer.borderWidth = 2.0f;
    self.attachComments.layer.borderColor = [[UIColor blackColor] CGColor];
    
    //keyboard going away listener
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    //Initializing keyboard listener
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.reportControllerNav.topItem.title = [@"Report: " stringByAppendingString:SelectedPlayerName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Uploading Image for Existing Cheater

- (IBAction)attachScreenshot:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //get image from the photo library since we are pushing screenshots
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)reportDone:(id)sender {
    int *isNew = 0;
    //If player exists in parse database and is only being updated
    if (SelectedPlayerObject != nil) {
        PFQuery *query = [PFQuery queryWithClassName:@"CheaterList"];
        
        // Retrieve the object by id
        [query getObjectInBackgroundWithId:[SelectedPlayerObject objectId] block:^(PFObject *gameScore, NSError *error) {
            
            // Now let's update it with some new data. In this case, only cheatMode and score
            // will get sent to the cloud. playerName hasn't changed.
            [gameScore incrementKey:@"rating"];
            [gameScore saveInBackground];
        }];
        isNew = 0;
    }
    else{ //Object is nil and this is a new entry for parse
        PFObject *gameScore = [PFObject objectWithClassName:@"CheaterList"];
        gameScore[@"foo"] = SelectedPlayerName;
        gameScore[@"rating"] = @1;
        [gameScore saveInBackground];
        isNew = 1;
    }
    
    //Saving Evidence
    PFObject *userPhoto = [PFObject objectWithClassName:[SelectedPlayerObject objectId]];
    //If theres an image save get all image data you need
    if (self.displayScreenShot.image != nil) {

        UIImage *myImageObj = self.displayScreenShot.image;
        NSData *imageData = UIImagePNGRepresentation(myImageObj);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        
        userPhoto[@"imageFile"] = imageFile;
    }
    //Set omments value
    userPhoto[@"imageName"] = self.attachComments.text;
    //Send data to Parse
    [userPhoto saveInBackground];

    
    //Going back to list of cheaters
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) uploadImage:(NSData *)imageData{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"Test1"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    //[self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            //[HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        //HUD.progress = (float)percentDone/100;
    }];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    //just display the image the user picked so he can make sure he picked the correct picture
    self.displayScreenShot.image = image;
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma Keyboard Raising

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.attachComments])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= 140.0;
        rect.size.height += 140.0;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += 140.0;
        rect.size.height -= 140.0;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)dismissKeyboard
{
    [self.attachComments resignFirstResponder];
}

@end


