//
//  ViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginController.h"
#import "StoryBoardController.h"
#import "SlidingViewController.h"
#import "LoginEntryViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [touchButton setBackgroundColor:[UIColor clearColor]];
    [touchButton addTarget:self action:@selector(touchBegan:) forControlEvents:UIControlEventAllTouchEvents];
    touchButton.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height/4);
    if ([[LoginManager sharedInstance] isLoggedIn]) {
        [self showNewControllersWithAnimation:NO];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Methods

- (IBAction)tryLogin:(id)sender {
    [self tryLogin];
}

- (void)touchBegan:(id)sender {
    [touchButton removeFromSuperview];
    [(LoginEntryViewController *)[self.childViewControllers objectAtIndex:0] dismissKeyboard];
}

#pragma mark - Public Methods

//- (void)tryLogin {
//    [_progressIndicator setHidden:NO];
//    
//    BOOL successfulLogin = [LoginController logInWithUsername:@"marcfiume@gmail.com" password:@"hockey"];
//    
//    [_progressIndicator setHidden:YES];
//    
//    if (successfulLogin) {
//        NSLog(@"Logged in");
//        
//        SlidingViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierSlideView]];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//        
//        svc.topViewController = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierSummaryView]];
//        svc.underLeftViewController = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierMenuView]];
//        
//        /*
//         slidingViewController.topViewController = self.navigationController;
//         slidingViewController.underLeftViewController = rearViewController;
//         
//         UIViewController *vc = [[StoryBoardController storyBoard] instantiateViewControllerWithIdentifier:[StoryBoardController identifierSummaryView]];
//         */
//        //svc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:svc animated:YES completion:nil];
//    } else {
//        UIAlertView *alert =
//        [[UIAlertView alloc] initWithTitle: @"Uh oh"
//                                   message: @"Login failed."
//                                  delegate: self
//                         cancelButtonTitle: @"OK"
//                         otherButtonTitles: nil];
//        [alert show];
//    }
//    
//}

- (void)tryLogin {
    [_progressIndicator setHidden:NO];

    LoginEntryViewController *childController = (LoginEntryViewController *)[self.childViewControllers objectAtIndex:0];
    [[LoginManager sharedInstance] setDelegate:self];
    [[LoginManager sharedInstance] logInWithUsername:childController.loginId.text andPassword:childController.password.text];
}

- (void)showTouchScreen:(BOOL)show {
    if (show) {
        [self.view addSubview:touchButton];
    } else {
        [touchButton removeFromSuperview];
    }
}

#pragma mark - Helper Methods

- (void)showNewControllersWithAnimation:(BOOL)animation {
    SlidingViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierSlideView]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    svc.topViewController = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierRootView]];
    svc.underLeftViewController = [storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierMenuView]];

    [self presentViewController:svc animated:animation completion:nil];
}

#pragma mark - LoginManagerDelegate Methods

- (void)loginSuccessful {
    [_progressIndicator setHidden:YES];
    [[LoginManager sharedInstance] setDelegate:nil];
    [self showNewControllersWithAnimation:YES];
    /*
     slidingViewController.topViewController = self.navigationController;
     slidingViewController.underLeftViewController = rearViewController;
     
     UIViewController *vc = [[StoryBoardController storyBoard] instantiateViewControllerWithIdentifier:[StoryBoardController identifierSummaryView]];
     */
    //svc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

- (void)loginFailedWithError:(NSString *)errorString {
    [_progressIndicator setHidden:YES];
    [[LoginManager sharedInstance] setDelegate:nil];
    LoginEntryViewController *childController = (LoginEntryViewController *)[self.childViewControllers objectAtIndex:0];
    
    [[childController password] setText:@""];
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle: @"Uh oh"
                               message: @"Login failed."
                              delegate: self
                     cancelButtonTitle: @"OK"
                     otherButtonTitles: nil];
    [alert show];
}

@end
