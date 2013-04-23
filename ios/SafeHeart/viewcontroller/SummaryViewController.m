//
//  SummaryViewController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "SummaryViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "StoryBoardController.h"
#import "ProgressPointerViewController.h"
#import "PercentageClassifier.h"
#import "RecentActivitiesViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

ProgressPointerViewController *progressViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"Master view did load");
    NSLog(@"Navigation controller is %@",self.navigationController);
    progressViewController = (ProgressPointerViewController*) [self.childViewControllers objectAtIndex:0];
    [progressViewController setProgressClassifier:[[PercentageClassifier alloc] init]];
    [progressViewController setSubtext:@"to next goal of 200 minutes"];
    [progressViewController setProgressive:YES];
    
}

-(void)viewDidLayoutSubviews {
    NSLog(@"Layout Asking progress bar to refresh");
    [progressViewController setProgress:27];

}

-(void)viewWillLayoutSubviews {
    NSLog(@"Layout Will Asking progress bar to refresh");
    [progressViewController setProgress:27];
}


-(void) viewDidAppear:(BOOL)animated {
    NSLog(@"Asking progress bar to refresh");
    [progressViewController setProgress:27];
}

-(void) viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
    
  
    NSLog(@"Master view will appear");
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
	    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:[StoryBoardController identifierMenuView]];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    
    NSLog(@"Showing navigation bar");
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}


@end
