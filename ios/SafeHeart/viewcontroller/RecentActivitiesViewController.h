//
//  RecentActivitiesViewController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserActivityManager.h"


@interface RecentActivitiesViewController : UITableViewController <UserActivityDelegate> {
    NSArray *_recentArray;
}


@end
