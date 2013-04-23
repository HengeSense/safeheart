//
//  ActivityUtils.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-02.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "ActivityUtils.h"

@implementation ActivityUtils

+ (NSString *)getStringForType:(ActivityType)type {
    switch (type) {
        case 0:
            return @"All";
            break;
        case 1:
            return @"Recommended";
            break;
        case 2:
            return @"Recent";
            break;
        default:
            return @"All";
            break;
    }
}

+ (ActivityType)getTypeForString:(NSString *)string {
    if ([string isEqualToString:@"All"]) {
        return ActivityTypeAll;
    } else if ([string isEqualToString:@"Recommended"]) {
        return ActivityTypeRecommended;
    } else if ([string isEqualToString:@"Recent"]) {
        return ActivityTypeRecent;
    } else {
        return ActivityTypeAll;
    }
}

+ (NSString *)getArchiveStringForType:(ActivityType)type {
    switch (type) {
        case 0:
            return ACTIVITY_ALL_ARCHIVE;
            break;
        case 1:
            return ACTIVITY_RECOMMENDED_ARCHIVE;
            break;
        case 2:
            return ACTIVITY_RECENT_ARCHIVE;
            break;
        default:
            return ACTIVITY_ALL_ARCHIVE;
            break;
    }
}


@end
