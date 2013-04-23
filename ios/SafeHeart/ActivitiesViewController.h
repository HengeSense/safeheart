//
//  ActivitiesViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

#import "AbstractActivityTableViewController.h"
#import "UserActivityManager.h"

@interface ActivitiesViewController : UIViewController<iCarouselDataSource, iCarouselDelegate,UserActivityDelegate> {
    
    AbstractActivityTableViewController* _recommendedVc;
    AbstractActivityTableViewController* _recentVc;
    AbstractActivityTableViewController* _allVc;
}

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
