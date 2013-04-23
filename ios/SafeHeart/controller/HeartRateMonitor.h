//
//  HeartRateMonitor.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-25.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeartRateListener.h"

@interface HeartRateMonitor : NSObject

+(BOOL) isConnected;
+(void) setConnected:(BOOL)b;
+(void) updateHR:(int)heartRate;
+(void) registerHRListener:(id<HeartRateListener>) l;
+(void) unregisterHRListener:(id<HeartRateListener>) l;

+ (double)getIntensityConvertedToWaist:(double)intensity;

@end
