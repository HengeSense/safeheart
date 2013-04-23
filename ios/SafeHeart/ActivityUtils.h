//
//  ActivityUtils.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ActivityUtils : NSObject


+ (NSString *)getStringForType:(ActivityType)type;
+ (ActivityType)getTypeForString:(NSString *)string;
+ (NSString *)getArchiveStringForType:(ActivityType)type;

@end
