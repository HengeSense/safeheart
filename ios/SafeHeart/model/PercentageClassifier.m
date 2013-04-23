//
//  PercentageClassifier.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-27.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "PercentageClassifier.h"
#import "ProgressClassifier.h"

@implementation PercentageClassifier


-(id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(NSString *)classifyProgress:(double)p {
    return [NSString stringWithFormat:@"%i%%",(int)p];
}

@end
