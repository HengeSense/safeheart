//
//  RecentActivity.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-04-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "Activity.h"

@interface RecentActivity : Activity {


}


@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *startTimeString;
@property (nonatomic, strong) NSString *stopTimeString;
@property (nonatomic, assign) BOOL didMeasureHeartRate;
@property (nonatomic, assign) BOOL didMeasureLocation;
@property (nonatomic, assign) BOOL didMeasureCalories;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CGFloat calories;
@property (nonatomic, assign) CGFloat maxHeartRate;
@property (nonatomic, assign) CGFloat avgHeartRate;



- (id)initWithActivity:(Activity *)activity andDictionary:(NSDictionary *)dictionary;


@end
