//
//  MetricView.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetricView : UIView

enum {
    MetricOxygen,
    MetricIntensity,
    MetricTime,
    MetricRecommendation,
    MetricBattery,
    MetricHeart,
    MetricCalories,
    MetricDistance
};
typedef NSUInteger Metric;

@property (strong, nonatomic) IBOutlet UIImageView *viewIcon;
@property (strong, nonatomic) IBOutlet UILabel *labelMetricValue;
@property (strong, nonatomic) IBOutlet UILabel *labelSubtext;

//-(id) initWithImage:(UIImage*) i subText:(NSString*) s;

//+(MetricView*) getTimeMetricWithMinutes:(int)m seconds:(int)s;
+(MetricView*) getViewForMetric:(Metric)m;
+(NSString*) encodeTimeWithMinutes:(int)m seconds:(int)s;
-(void) setMetricValue:(NSString*)s;

@end
