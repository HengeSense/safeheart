//
//  ViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginManager.h"

@interface LoginViewController : UIViewController <LoginManagerDelegate> {
    UIButton *touchButton;
}

- (IBAction)tryLogin:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;

- (void)tryLogin;
- (void)showTouchScreen:(BOOL)show;

@end
