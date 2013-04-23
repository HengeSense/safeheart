//
//  IntensityManager.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-12.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface IntensityManager : NSObject {
    CMMotionManager *_motionManager;
    CMAcceleration _currentAcceleration;
    double _totalIntensity;
    int _count;
    NSDate *_lastRecievedDate;
    NSDate *_startDate;
}

+ (IntensityManager *)sharedInstance;

- (void)startIntensityUpdates;
- (void)stopIntensityUpdates;

- (double)getTotalIntensity;

@end
