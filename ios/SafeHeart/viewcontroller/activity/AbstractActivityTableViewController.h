//
//  AbstractActivityTableViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricView.h"

@interface AbstractActivityTableViewController : UITableViewController {
    UINavigationController* parentNavigationController;
}

@property (nonatomic, retain) NSArray *activities;

-(void) setParentNavigationController:(UINavigationController*)n;

@end
