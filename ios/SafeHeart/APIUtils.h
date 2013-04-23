//
//  APIUtilsController.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIUtils : NSObject

+ (id)getObject:(id)object;
+ (NSDate *)getDate:(id)object;

@end
