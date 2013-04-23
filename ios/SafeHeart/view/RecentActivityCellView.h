//
//  ActivityCell.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricView.h"

@interface RecentActivityCellView : UITableViewCell {
    MetricView* previous;
}


@property (strong, nonatomic) IBOutlet UILabel *labelActivityName;
@property (strong, nonatomic) IBOutlet UIView *viewAccessory;
@property (strong, nonatomic) IBOutlet UILabel *labelActivityDate;

-(void) addAcessoryView:(UIView*)v;
- (void)resetCell;

@end
