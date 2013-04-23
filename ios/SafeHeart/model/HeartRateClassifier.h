//
//  HeartRateClassifier.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-27.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProgressClassifier.h"

@interface HeartRateClassifier : NSObject <ProgressClassifier> {
    int min;
    int max;
    NSTimer *maxVibrator;
}

-(id) initWithNormalRageMin:(int)mn Max:(int)mx;

@end
