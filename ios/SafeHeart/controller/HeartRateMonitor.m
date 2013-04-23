//
//  HeartRateMonitor.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-25.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "HeartRateMonitor.h"
#import "LoginManager.h"

@implementation HeartRateMonitor

BOOL isConnected;
NSMutableArray *listeners;

void checkListeners() {
    if (listeners == nil) {
        listeners = [[NSMutableArray alloc] init];
        //startTicker();
    }
}

//void startTicker() {
//    [NSTimer scheduledTimerWithTimeInterval:2 target:[HeartRateMonitor class] selector:@selector(updateHR) userInfo:nil repeats:YES];
//}

+(void) updateHR:(int)heartRate {
    //NSLog(@"Updating HR value");
    
    //int heartRate = arc4random() % 120;
    for (id<HeartRateListener> l in listeners) {
        [l didUpdateHeartRate:heartRate];
    }
}

+(void) setConnected:(BOOL)b {
    isConnected = b;
}

+(BOOL) isConnected {
    return isConnected;
}

+(void) registerHRListener:(id<HeartRateListener>) l {
    checkListeners();
    [listeners addObject:l];
}

+(void) unregisterHRListener:(id<HeartRateListener>) l {
    checkListeners();
    [listeners removeObject:l];
}


+ (double)getIntensityConvertedToWaist:(double)intensity {
    double a = 1.0f;
    double b = 0.0f;

    if ([[[LoginManager sharedInstance] user] monitorLocation] == MonitorLocationArm) {
        a = 0.77091;
        b = 1.2328;
    } else if ([[[LoginManager sharedInstance] user] monitorLocation] == MonitorLocationJacket) {
        a = 0.99051;
        b = -0.27129;
    }
    
    return  a*intensity + b;
}

@end
