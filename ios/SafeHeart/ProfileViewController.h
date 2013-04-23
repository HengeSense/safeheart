//
//  ProfileViewController.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-30.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UIActionSheetDelegate, UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate> {
    
    IBOutlet UIImageView *_profileImageView;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UISwitch *_vibrateSwitch;
    IBOutlet UILabel *_locationLabel;
    IBOutlet UILabel *_weightLabel;
    
    UIPickerView *_weightPicker;
    UIActionSheet *_hrLocationActionSheet;
    UIImagePickerController *_iPc;
    
    IBOutlet UIView *_settingContainerView;
    
    IBOutlet UILabel *_genderLabel;
    
    IBOutlet UILabel *_dobLabel;
    
    IBOutlet UIScrollView *_scrollView;
}

- (IBAction)profileImageButtonPressed:(id)sender;
- (IBAction)weightButtonPressed:(id)sender;
- (IBAction)hrLocationButtonPressed:(id)sender;

- (IBAction)dobButtonPressed:(id)sender;

- (IBAction)genderButtonPressed:(id)sender;

@end
