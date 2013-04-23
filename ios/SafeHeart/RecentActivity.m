//
//  RecentActivity.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-04-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "RecentActivity.h"

@implementation RecentActivity

- (id)initWithActivity:(Activity *)activity andDictionary:(NSDictionary *)dictionary {
    self = [super initWithActivity:activity];
    if (self) {
        _activityId = [dictionary objectForKey:@"activity_id"];
        _startTimeString = [dictionary objectForKey:@"startTime"];
        _stopTimeString = [dictionary objectForKey:@"stopTime"];
        _didMeasureHeartRate = [[dictionary objectForKey:@"didMeasureHeartRate"] boolValue];
        _didMeasureLocation = [[dictionary objectForKey:@"didMeasureLocation"] boolValue];
        _didMeasureCalories = [[dictionary objectForKey:@"didMeasureCalories"] boolValue];
        _duration = [[dictionary objectForKey:@"duration"] floatValue];
        _distance = [[dictionary objectForKey:@"distance"] floatValue];
        _calories = [[dictionary objectForKey:@"calories"] floatValue];
        _maxHeartRate = [[dictionary objectForKey:@"maxHeartRate"] floatValue];
        _avgHeartRate = [[dictionary objectForKey:@"avgHeartRate"] floatValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _activityId = [decoder decodeObjectForKey:@"activity_id"];
        _startTimeString = [decoder decodeObjectForKey:@"startTime"];
        _stopTimeString = [decoder decodeObjectForKey:@"stopTime"];
        _didMeasureHeartRate = [decoder decodeBoolForKey:@"didMeasureHeartRate"];
        _didMeasureLocation = [decoder decodeBoolForKey:@"didMeasureLocation"];
        _didMeasureCalories = [decoder decodeBoolForKey:@"didMeasureCalories"];
        _duration = [decoder decodeFloatForKey:@"duration"];
        _distance = [decoder decodeFloatForKey:@"distance"];
        _calories = [decoder decodeFloatForKey:@"calories"];
        _maxHeartRate = [decoder decodeFloatForKey:@"maxHeartRate"];
        _avgHeartRate = [decoder decodeFloatForKey:@"avgHeartRate"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_activityId forKey:@"activity_id"];
    [encoder encodeObject:_startTimeString forKey:@"startTime"];
    [encoder encodeObject:_stopTimeString forKey:@"stopTime"];
    [encoder encodeBool:_didMeasureHeartRate forKey:@"didMeasureHeartRate"];
    [encoder encodeBool:_didMeasureLocation forKey:@"didMeasureLocation"];
    [encoder encodeBool:_didMeasureCalories forKey:@"didMeasureCalories"];
    [encoder encodeFloat:_duration forKey:@"duration"];
    [encoder encodeFloat:_distance forKey:@"distance"];
    [encoder encodeFloat:_calories forKey:@"calories"];
    [encoder encodeFloat:_maxHeartRate forKey:@"maxHeartRate"];
    [encoder encodeFloat:_avgHeartRate forKey:@"avgHeartRate"];

}



@end
