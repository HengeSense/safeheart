//
//  Colors.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+(UIColor*) getDarkGrayColor {
    return [Colors getGrayScale:23.0/255.0];
}

+(UIColor*) getMediumGrayColor {
    return [Colors getGrayScale:140.0/255.0];
}

+(UIColor*) getLightGrayColor {
    return [Colors getGrayScale:230.0/255.0];
}

+(UIColor*) getGrayScale:(CGFloat) s {
    return [[UIColor alloc] initWithRed:s green:s blue:s alpha:1.0];
}

+(UIColor*) getDeepRedColor {
    return [[UIColor alloc] initWithRed:153.0/255.0 green:5.0/255.0 blue:1.0/255.0 alpha:1.0];
}

+(UIColor*) getBrightGreen {
    return [[UIColor alloc] initWithRed:53.0/255.0 green:215.0/255.0 blue:50.0/255.0 alpha:1.0];
}



@end
