//
//  ActivityCellView.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ActivityCellView.h"
#import "ViewUtil.h"

@implementation ActivityCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        previous = nil;
        // Initialization code
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

- (void)resetCell {
    for (UIView *view in [self.viewAccessory subviews]) {
        if ([view isKindOfClass:[MetricView class]]) {
            [view removeFromSuperview];
        }
    }
    previous = nil;
}

- (void)setLabelText:(NSString *)text {
    [_labelActivityName setText:text];
}

@end

