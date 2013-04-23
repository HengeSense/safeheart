//
//  LoginEntryViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginEntryViewController : UITableViewController <UITextFieldDelegate>{
}

@property (nonatomic, strong) UITextField *loginId;
@property (nonatomic, strong) UITextField *password;

- (void)dismissKeyboard;

@end
