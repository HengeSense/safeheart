//
//  ActivityCell.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetricView.h"

@interface ActivityCellView : UITableViewCell {
    MetricView* previous;
}


@property (strong, nonatomic) IBOutlet UILabel *labelActivityName;
@property (strong, nonatomic) IBOutlet UIView *viewAccessory;

-(void) addAcessoryView:(UIView*)v;
- (void)clearSubviews;


@end
