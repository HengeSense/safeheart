//
//  ViewUtil.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-23.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtil : NSObject

+(void) verticallyCenterChild:(UIView*)child inParent:(UIView*)parent;
+(void) positionChild:(UIView*)child under:(UIView*)parent withPadding:(int)p;
+(void) positionChild:(UIView*)child rightOf:(UIView*)parent withPadding:(int)p;
+(void) center:(UIView*)u OnXPosition:(double) p;

@end
