//
//  ViewUtil.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-23.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+(void) verticallyCenterChild:(UIView*)child inParent:(UIView*)parent {
    //printRect(parent.frame);
    //printRect(child.frame);
    int midY = getMidY(parent.frame);
    int yOffset = getMidY(child.frame);
    int newY = midY - yOffset;
    //NSLog(@"%i %i %i",midY,yOffset,newY);
    CGRect r = changeY(child.frame,newY);
    child.frame = r;
}

+(void) positionChild:(UIView*)child under:(UIView*)parent withPadding:(int)p {
    int newY = parent.frame.origin.y + parent.frame.size.height + p;
    CGRect r = changeY(child.frame,newY);
    child.frame = r;
}

+(void) positionChild:(UIView*)child rightOf:(UIView*)parent withPadding:(int)p {
    int newX = parent.frame.origin.x + parent.frame.size.width + p;
    CGRect r = changeX(child.frame,newX);
    child.frame = r;
}

int getMidY(CGRect r) {
    return r.size.height/2;
}

int getMidX(CGRect r) {
    return r.size.width/2;
}

void printRect(CGRect r) {
    NSLog(@"%f %f %f %f",r.origin.x,r.origin.y,r.size.width,r.size.height);
}

CGRect changeY(CGRect r, CGFloat y) {
    return CGRectMake(r.origin.x,y,r.size.width,r.size.height);
}

CGRect changeX(CGRect r, CGFloat x) {
    return CGRectMake(x,r.origin.y,r.size.width,r.size.height);
}

+(void) center:(UIView*)u OnXPosition:(double) p {
    //NSLog(@"Putting %f at %f from width %f",p,p-(u.frame.size.width/2),u.frame.size.width);
    u.frame = changeX(u.frame,p-(u.frame.size.width/2));
}

@end
