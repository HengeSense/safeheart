//
//  IntensityManager.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-12.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "IntensityManager.h"
#include "HeartRateMonitor.h"

#define kFilteringFactor 0.1

#define A 0.000013571
#define B 0.0037402

@implementation IntensityManager

static UIAccelerationValue rollingX=0, rollingY=0, rollingZ=0;

#pragma mark - LifeCycle Methods

+ (IntensityManager *)sharedInstance {
    static IntensityManager *sharedInstance_ = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance_ = [[self alloc] init];
    });
    
    return sharedInstance_;
}


- (id)init {
    self = [super init];
    if (self) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = 0.01;
    }
    return self;
}


- (void)setupForNewCalculation {
    _startDate = [NSDate date];
    _totalIntensity = 0;
    _currentAcceleration.x = 0;
    _currentAcceleration.y = 0;
    _currentAcceleration.z = 0;    
}

- (void)startIntensityUpdates {
    [self setupForNewCalculation];
    [_motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        
        CMAcceleration newAcceleration = [self highPassOnData:accelerometerData];
        
        _currentAcceleration = newAcceleration;
        
        
        [self updateTotalIntensity];        
        
    }];
}

- (void)updateTotalIntensity {
	@synchronized(self) {
        if (_lastRecievedDate == nil) {
            _lastRecievedDate = [NSDate date];
        } else {
            double currentIntensity = fabs(_currentAcceleration.x) + fabs(_currentAcceleration.y) + fabs(_currentAcceleration.z);
            CGFloat timeFactor = [self getTimeFactor];
            _totalIntensity += currentIntensity/timeFactor;
            
        }
    }
}

- (CGFloat)getTimeFactor {
    NSTimeInterval timeInteval = [[NSDate date] timeIntervalSinceDate:_lastRecievedDate];
    _lastRecievedDate = [NSDate date];
    return 1.0f/timeInteval;    
}


- (void)stopIntensityUpdates {
    [_motionManager stopAccelerometerUpdates];
}

- (CMAcceleration)highPassOnData:(CMAccelerometerData *)accelerationData {
    rollingX = (accelerationData.acceleration.x*9.8 * kFilteringFactor) + (rollingX * (1.0 - kFilteringFactor));
    
    rollingY = (accelerationData.acceleration.y*9.8 * kFilteringFactor) + (rollingY * (1.0 - kFilteringFactor));
    
    rollingZ = (accelerationData.acceleration.z*9.8  * kFilteringFactor) + (rollingZ * (1.0 - kFilteringFactor));
    
    
    CMAcceleration correctedAcceleration;
    correctedAcceleration.x = accelerationData.acceleration.x*9.8  - rollingX;
    correctedAcceleration.y = accelerationData.acceleration.y*9.8  - rollingY;
    correctedAcceleration.z = accelerationData.acceleration.z*9.8  - rollingZ;

    return correctedAcceleration;
}



#pragma mark - Public Methods

- (double)getTotalIntensity {
    double caloriePerKg = [HeartRateMonitor getIntensityConvertedToWaist:_totalIntensity];
    caloriePerKg = A*caloriePerKg + ((float)([[NSDate date] timeIntervalSinceDate:_startDate])/30.0f)*B;
    if (caloriePerKg < 0) {
        return 0;
    } else {
        return caloriePerKg;
    }
}

@end
