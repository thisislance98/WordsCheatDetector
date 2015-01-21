//
//  ReportPlayerController.h
//  CheaterCatcher
//
//  Created by Toliy on 1/20/15.
//  Copyright (c) 2015 AKSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportPlayerController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UIImagePickerController *picker;
    NSString *SelectedPlayerName;
}
@property (strong, nonatomic) NSString *SelectedPlayerName;

@property (strong, nonatomic) IBOutlet UIImageView *displayScreenShot;
@property (strong, nonatomic) IBOutlet UITextView *attachComments;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *reportControllerNav;

- (IBAction)attachScreenshot:(id)sender;
- (IBAction)reportDone:(id)sender;


@end
