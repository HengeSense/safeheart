//
//  MetricView.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "MetricView.h"
#import "Fonts.h"
#import "Colors.h"
#import "ViewUtil.h"

@implementation MetricView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setMetricValue:(NSString*) s {
    [self.labelMetricValue setText:s];
}

+(MetricView*) getViewForMetric:(Metric)m {
    
    MetricView* mv = [[[NSBundle mainBundle] loadNibNamed:@"MetricView" owner:self options:nil] objectAtIndex:0];
    
    //[mv setBackgroundColor:[UIColor yellowColor]];
    mv.autoresizingMask = UIViewAutoresizingNone;
    
    [mv setMetricValue:@""];
    
    NSString *s = [MetricView getSubtextForMetric:m];
    UIImage  *i = [MetricView getIconForMetric:m];
    
    [mv.viewIcon setImage:i];
    [mv.labelSubtext setText:[s uppercaseString]];
    
    return mv;
}

+(UIImage*) getIconForMetric:(Metric)m {
    NSString* p;
    switch (m) {
        case MetricDistance:
            p = @"metric-distance.png";
            break;
        case MetricCalories:
            p = @"metric-calories.png";
            break;
        case MetricBattery:
            p = @"metric-battery.png";
            break;
        case MetricTime:
            p = @"metric_timer.png";
            break;
        case MetricOxygen:
            p = @"metric-o2.png";
            break;
        case MetricIntensity:
            p = @"metric-intensity.png";
            break;
        case MetricRecommendation:
            p = @"metric-thumb.png";
            break;
        case MetricHeart:
            p = @"metric-heart.png";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:p];
}

+(NSString*) getSubtextForMetric:(Metric)m {
    NSString* p;
    switch (m) {
        case MetricDistance:
            p = @"distance";
            break;
        case MetricCalories:
            p = @"calories";
            break;
        case MetricBattery:
            p = @"battery";
            break;
        case MetricTime:
            p = @"time";
            break;
        case MetricOxygen:
            p = @"uptake";
            break;
        case MetricIntensity:
            p = @"intensity";
            break;
        case MetricRecommendation:
            p = @"to do";
            break;
        case MetricHeart:
            p = @"heart rate";
            break;
        default:
            break;
    }
    return p;
}

+(NSString*) encodeTimeWithMinutes:(int)m seconds:(int)s {
    return [NSString stringWithFormat:@"%i:%i",m,s];
}


@end
