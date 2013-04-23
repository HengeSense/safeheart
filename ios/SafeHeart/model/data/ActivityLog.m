//
//  ActivityLog.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-03-11.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ActivityLog.h"
#import <CoreLocation/CoreLocation.h>

#define IS_ACTIVE @"is_active"
#define IS_FINISHED @"is_finished"
#define ACTIVITY @"activity"
#define HEART_RATE @"heart_rate"
#define LOCATIONS @"locations"
#define CALORIES @"calories"


@implementation ActivityLog

-(id) initWithActivity:(Activity*)a {
    self = [super init];
    if (self) {
        isActive = false;
        isFinished = false;
        activity = a;
        heartRateEvents = [[NSMutableArray alloc] init];
        locationEvents = [[NSMutableArray alloc] init];
        calorieEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        isActive = [decoder decodeBoolForKey:IS_ACTIVE];
        isFinished = [decoder decodeBoolForKey:IS_FINISHED];
        activity = [decoder decodeObjectForKey:ACTIVITY];
        heartRateEvents = [decoder decodeObjectForKey:HEART_RATE];
        locationEvents = [decoder decodeObjectForKey:LOCATIONS];
        calorieEvents = [decoder decodeObjectForKey:CALORIES];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {

    [encoder encodeBool:isActive forKey:IS_ACTIVE];
    [encoder encodeBool:isFinished forKey:IS_FINISHED];
    [encoder encodeObject:activity forKey:ACTIVITY];
    [encoder encodeObject:heartRateEvents forKey:HEART_RATE];
    [encoder encodeObject:locationEvents forKey:LOCATIONS];
    [encoder encodeObject:calorieEvents forKey:CALORIES];
}



-(void) startActivity {
    isActive = true;
    startTime = [[NSDate alloc] init];
}

-(void) stopActivity {
    isActive = false;
    isFinished = true;
    stopTime = [[NSDate alloc] init];
}

-(void) addCalorieEvent:(TimeStampedEvent*) e {
    [calorieEvents addObject:e];
}

-(void) addHeartRateEvent:(TimeStampedEvent*) e {
    [heartRateEvents addObject:e];
}

-(void) addLocationEvent:(TimeStampedEvent*) e {
    [locationEvents addObject:e];
}

-(long) duration {
    
    if (startTime == nil) {
        return 0;
    }
    
    NSDate* endtime;
    if (stopTime == nil) {
        endtime = [[NSDate alloc] init];
    } else {
        endtime = stopTime;
    }
    
    return round([endtime timeIntervalSinceDate:startTime]);
}

-(Activity*) activity {
    return activity;
}

-(CGFloat) calories {
    if ([calorieEvents count] > 0) {
        return [((NSNumber *)[(TimeStampedEvent *)[calorieEvents lastObject] payload]) floatValue];
    } else {
        return 0;
    }
}

-(long) intensity {
    return 0;
}

-(NSDate*) startTime {
    return startTime;
}

-(NSDate*) stopTime {
    return stopTime;
}

-(NSArray*) heartRateEvents {
    return heartRateEvents;
}

-(NSArray*) locationEvents {
    return locationEvents;
}

-(NSArray*) calorieEvents {
    return calorieEvents;
}

-(double) getTotalDistance {
    if ([locationEvents count] < 2) {
        return 0;
    }
    
    NSArray* locationEventsCopy = [[NSArray alloc] initWithArray:locationEvents];
    
    CLLocation* prev = (CLLocation*)[(TimeStampedEvent*)[locationEventsCopy objectAtIndex:0] payload];
    int nextIndex = 1;
    double cumulativeDistance = 0;
    while (nextIndex != [locationEventsCopy count]) {
        CLLocation* next = (CLLocation*)[(TimeStampedEvent*)[locationEventsCopy objectAtIndex:nextIndex] payload];
        
        cumulativeDistance += [next distanceFromLocation:prev];
        
        nextIndex++;
        prev = next;
    }
    
    return cumulativeDistance;
}


-(BOOL) isActive {
    return isActive;
}

-(BOOL) isFinished {
    return isFinished;
}

-(BOOL) didMeasureHeartRate {
    return heartRateEvents != nil && [heartRateEvents count] > 0;
}
-(BOOL) didMeasureCalories {
    return calorieEvents != nil && [calorieEvents count] > 0;
}
-(BOOL) didMeasureLocation {
    return locationEvents != nil && [locationEvents count] > 0;
}

- (int)maxHeartRate {
    int max = 0;
    int n = [heartRateEvents count];
    for (int i = 0; i < n; i++) {
        int j = [(NSNumber*)[((TimeStampedEvent*)[heartRateEvents objectAtIndex:i]) payload] intValue];
        if (j > max) {
            max = j;
        }
    }
    return max;
}

- (double)avgHeartRate {
    int sum = 0;
    int n = [heartRateEvents count];
    
    if (n == 0) { return 0; }
    
    for (int i = 0; i < n; i++) {
        sum += [(NSNumber*)[((TimeStampedEvent*)[heartRateEvents objectAtIndex:i]) payload] intValue];
    }
    return sum*1.0/n;
}



- (void)setCalories:(NSArray *)array {
    calorieEvents = [[NSMutableArray alloc] initWithArray:array];
}

- (void)setHeartRate:(NSArray *)array {
    heartRateEvents = [[NSMutableArray alloc] initWithArray:array];
}

- (void)setLocation:(NSArray *)array {
    locationEvents = [[NSMutableArray alloc] initWithArray:array];
}

- (void)setStartTime:(NSDate *)date {
    startTime = date;
}

- (void)setStopTime:(NSDate *)date {
    stopTime = date;
}

@end
