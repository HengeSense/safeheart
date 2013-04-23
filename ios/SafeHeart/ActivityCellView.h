//
//  ActivityCellView.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-02.
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
- (void)resetCell;
- (void)setLabelText:(NSString *)text;

@end
