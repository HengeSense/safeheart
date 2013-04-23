//
//  Colors.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "SHColors.h"

@implementation SHColors

+(UIColor*) getDarkGrayColor {
    return [SHColors getGrayScale:23.0/255.0];
}

+(UIColor*) getMediumGrayColor {
    return [SHColors getGrayScale:140.0/255.0];
}

+(UIColor*) getLightGrayColor {
    return [SHColors getGrayScale:230.0/255.0];
}

+(UIColor*) getGrayScale:(CGFloat) s {
    return [[UIColor alloc] initWithRed:s green:s blue:s alpha:1.0];
}

+(UIColor*) getDeepRedColor {
    return [[UIColor alloc] initWithRed:194.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0];
}

@end
