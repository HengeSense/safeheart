//
//  ActivityCell.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-22.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ActivityCellView.h"
#import "Colors.h"
#import "MetricView.h"
#import "ViewUtil.h"

@implementation ActivityCellView

//NSMutableArray* metricViews;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        previous = nil;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) addAcessoryView:(MetricView*)v {
    
    [ViewUtil positionChild:v rightOf:previous withPadding:3];
    [ViewUtil verticallyCenterChild:v inParent:self.viewAccessory];
    [self.viewAccessory addSubview:v];
    
    previous = v;
}

- (void)clearSubviews {
    NSArray *array = [self.viewAccessory subviews];
    for (UIView *view in array) {
        if ([view isKindOfClass:[MetricView class]]) {
            [view removeFromSuperview];
        }
    }
    previous = nil;
}
@end
