//
//  RecentActivityCell.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricView.h"

@interface RecentActivityCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;

- (void)addMetric:(MetricView*)metric;


@end
