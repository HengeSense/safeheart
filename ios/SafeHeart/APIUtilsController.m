//
//  APIUtilsController.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "APIUtilsController.h"

@implementation APIUtilsController

+ (id)getObject:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        return object;
    }
}

@end
