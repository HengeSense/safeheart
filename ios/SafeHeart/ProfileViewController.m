//
//  ProfileViewController.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-30.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginManager.h"

#define MIN_WEIGHT 25.0f
#define MAX_WEIGHT 699.0f

@interface ProfileViewController ()

@end

@implementation ProfileViewController

#pragma mark - LifeCycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFields];
    [self setupWeightPicker];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                      style:UIBarButtonItemStyleDone
                                                     target:self
                                                     action:@selector(doneButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    

	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_scrollView addSubview:_settingContainerView];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, _settingContainerView.frame.size.height)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Methods

- (void)setupFields {
    SafeHeartUser *user = [[LoginManager sharedInstance] user];
    [_nameLabel setText:[user fullName]];
    [_weightLabel setText:[NSString stringWithFormat:@"%d",[[user weight] intValue]]];
    [_locationLabel setText:[SafeHeartUser stringForLocation:[user monitorLocation]]];
    [_profileImageView setImage:user.profileImage];
    [_vibrateSwitch setOn:[user viberate]];
    [_vibrateSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_genderLabel setText:[user gender]];
    [_dobLabel setText:[user birthday]];
}

- (void)setupWeightPicker {
    _weightPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f,self.view.frame.size.height,320.0f, 180.0f)];
    [_weightPicker setDelegate:self];
    [_weightPicker setHidden:YES];
    [self.view addSubview:_weightPicker];
}



#pragma mark - Button Methods

- (IBAction)profileImageButtonPressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _iPc = [[UIImagePickerController alloc] init];
            _iPc.delegate = self;
            _iPc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _iPc.mediaTypes = [NSArray arrayWithObjects:
                               (NSString *) kUTTypeImage,
                               nil];
            _iPc.allowsEditing = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:_iPc animated:YES completion:nil];
            });
        });
    }
}

- (IBAction)weightButtonPressed:(id)sender {
//    [_weightPicker setHidden:NO];
//    [UIView animateWithDuration:0.3
//                          delay:0.0f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         CGRect frame = _weightPicker.frame;
//                         frame.origin.y = self.view.frame.size.height-180.0f;
//                         _weightPicker.frame = frame;
//                     }
//                     completion:^(BOOL finished) {
//                     }];
}

- (IBAction)hrLocationButtonPressed:(id)sender {
    _hrLocationActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Waist",@"Arm",@"Jacket", nil];
    [_hrLocationActionSheet showInView:self.view];
}


- (IBAction)dobButtonPressed:(id)sender {
}

- (IBAction)genderButtonPressed:(id)sender {
}

#pragma mark - Switch Methhods

- (void)switchChanged:(id)sender {
    if ([(UISwitch *)sender isOn]) {
        [[[LoginManager sharedInstance] user] setViberate:YES];
    } else {
        [[[LoginManager sharedInstance] user] setViberate:NO];
    }
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [[[LoginManager sharedInstance] user] setMonitorLocation:MonitorLocationWaist];
            break;
        case 1:
            [[[LoginManager sharedInstance] user] setMonitorLocation:MonitorLocationArm];
            break;
        case 2:
            [[[LoginManager sharedInstance] user] setMonitorLocation:MonitorLocationJacket];
            break;
        default:
            break;
    }
    [_locationLabel setText:[SafeHeartUser stringForLocation:[[[LoginManager sharedInstance] user] monitorLocation]]];
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return MAX_WEIGHT - MIN_WEIGHT + 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 200.0f;
    
}

#pragma mark - UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
        return [NSString stringWithFormat:@"%1.0f %@", row + MIN_WEIGHT, @"Kg"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [_weightLabel setText:[NSString stringWithFormat:@"%1.0f %@", row + MIN_WEIGHT, @"Kg"]];
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_iPc dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [_profileImageView setImage:image];
        [[[LoginManager sharedInstance] user] setProfileImage:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_iPc dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
