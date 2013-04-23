//
//  HeartRateClassifier.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-27.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "HeartRateClassifier.h"

@implementation HeartRateClassifier

-(id) initWithNormalRageMin:(int)mn Max:(int)mx {
    self = [super init];
    if (self) {
        min = mn;
        max = mx;
    }
    return self;
}

-(NSString *)classifyProgress:(double)p {
    
    NSString* result = @"OK";
    if (p < min) {
        result = @"LOW";
    } else if (p > max) {
        result = @"HIGH";
    }
    
    return result;
}

@end
