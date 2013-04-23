//
//  HeartRateListener.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-25.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HeartRateListener <NSObject>

-(void) didUpdateHeartRate:(int) heartRate;

@end
