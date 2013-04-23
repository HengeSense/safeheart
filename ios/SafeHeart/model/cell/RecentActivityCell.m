//
//  RecentActivityCell.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "RecentActivityCell.h"
#import "Colors.h"

@implementation RecentActivityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [_labelTitle setTextColor:[Colors getDarkGrayColor]];
        UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        bgview.opaque = YES;
        bgview.backgroundColor = [Colors getLightGrayColor];
        [self setBackgroundView:bgview];
        
        UIView *highlightedbgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        highlightedbgview.backgroundColor = [Colors getDeepRedColor];
        [self setSelectedBackgroundView:highlightedbgview];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) addMetric:(MetricView*)metric {
    [self addSubview:metric];
}

@end
