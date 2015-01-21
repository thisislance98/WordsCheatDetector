//
//  ReportPlayerController.m
//  CheaterCatcher
//
//  Created by Toliy on 1/20/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import "ReportPlayerController.h"

@interface ReportPlayerController ()

@property (strong, nonatomic) NSArray *commentsFinished;

@end

@implementation ReportPlayerController

@synthesize SelectedPlayerName;

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
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)reportDone:(id)sender {
    if (self.displayScreenShot.image != nil) {
        UIImage *image = self.displayScreenShot.image;
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [self.displayScreenShot.image drawInRect: CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(self.displayScreenShot.image, 0.05f);
        //[self uploadImage:imageData];
    #warning TODO: CREATE UPLOAD IMAGE METHOD
    }
    if (![self.attachComments.text isEqualToString:@""]) {
        self.commentsFinished = self.attachComments.text;
        
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
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


