//
//  ActivityLog.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-03-11.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"
#import "TimeStampedEvent.h"

@interface ActivityLog : NSObject {
    Activity*   activity;
    NSDate*     startTime;
    NSDate*     stopTime;
    NSMutableArray*    heartRateEvents;
    NSMutableArray*    locationEvents;
    NSMutableArray*    calorieEvents;
    long        calories;
    long        intensity;
    BOOL        isActive;
    BOOL        isFinished;
}

-(id) initWithActivity:(Activity*)a;

- (void)setHeartRate:(NSArray *)array;
- (void)setCalories:(NSArray *)array;
- (void)setLocation:(NSArray *)array;

- (void)setStartTime:(NSDate *)date;
- (void)setStopTime:(NSDate *)date;


-(void) startActivity;
-(void) stopActivity;
-(void) addCalorieEvent:(TimeStampedEvent*) e;
-(void) addHeartRateEvent:(TimeStampedEvent*) e;
-(void) addLocationEvent:(TimeStampedEvent*) e;

-(double) getTotalDistance;

-(Activity*) activity;
-(BOOL) isActive;
-(BOOL) isFinished;
-(long) duration;
-(CGFloat) calories;
-(long) intensity;
-(NSDate*) startTime;
-(NSDate*) stopTime;
-(NSArray*) locationEvents;
-(NSArray*) heartRateEvents;
-(NSArray*) calorieEvents;

-(BOOL) didMeasureHeartRate;
-(BOOL) didMeasureCalories;
-(BOOL) didMeasureLocation;
-(int) maxHeartRate;
- (double)avgHeartRate;


@end
