//
//  SafeHeartUser.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "SafeHeartUser.h"
#import "Constants.h"
#import "APIUtilsController.h"

@implementation SafeHeartUser

#pragma mark - LifeCycle Methods

- (SafeHeartUser *)initWithAttributes:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _safeHeartId = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartId]];
        _username = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartUsername]];
        _firstName = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartFirstName]];
        _lastName = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartLastName]];
        _gender = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartGender]];
        _birthday = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartBirthday]];
        
        _weight = ([APIUtilsController getObject:[dictionary objectForKey:kSafeHeartWeight]]) ? [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartWeight]] : [NSNumber numberWithInt:80];
        
        _fullName = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartFullName]];
        _userType = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartUserType]];
        _dashboardURL = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartURL]];
        _sessionKey = [APIUtilsController getObject:[dictionary objectForKey:kSafeHeartSessionKey]];
        _profileImage = [UIImage imageNamed:@"canada"];
        }
    return self;
}

#pragma mark - Coder/Decoder Methods

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _safeHeartId = [decoder decodeObjectForKey:kSafeHeartId];
        _username = [decoder decodeObjectForKey:kSafeHeartUsername];
        _firstName = [decoder decodeObjectForKey:kSafeHeartFirstName];
        _lastName = [decoder decodeObjectForKey:kSafeHeartLastName];
        _gender = [decoder decodeObjectForKey:kSafeHeartGender];
        _birthday = [decoder decodeObjectForKey:kSafeHeartBirthday];
        _weight = [decoder decodeObjectForKey:kSafeHeartWeight]; //MM/DD/YYYY
        _monitorLocation = [decoder decodeIntegerForKey:kSafeHeartMonitorLocation];
        
        _fullName = [decoder decodeObjectForKey:kSafeHeartFullName];
        _dashboardURL = [decoder decodeObjectForKey:kSafeHeartURL];
        _userType = [decoder decodeObjectForKey:kSafeHeartUserType];
        _sessionKey = [decoder decodeObjectForKey:kSafeHeartSessionKey];
        _viberate = [decoder decodeBoolForKey:kSafeHeartViberate];
        _profileImage = [decoder decodeObjectForKey:kSafeHeartImage];
        
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_safeHeartId forKey:kSafeHeartId];
    [encoder encodeObject:_username forKey:kSafeHeartUsername];
    [encoder encodeObject:_firstName forKey:kSafeHeartFirstName];
    [encoder encodeObject:_lastName forKey:kSafeHeartLastName];
    [encoder encodeObject:_gender forKey:kSafeHeartGender];
    [encoder encodeObject:_birthday forKey:kSafeHeartBirthday];
    [encoder encodeObject:_weight forKey:kSafeHeartWeight];
    [encoder encodeInt:_monitorLocation forKey:kSafeHeartMonitorLocation];
    
    [encoder encodeObject:_fullName forKey:kSafeHeartFullName];
    [encoder encodeObject:_dashboardURL forKey:kSafeHeartURL];
    [encoder encodeObject:_userType forKey:kSafeHeartUserType];
    [encoder encodeObject:_sessionKey forKey:kSafeHeartSessionKey];
    [encoder encodeBool:_viberate forKey:kSafeHeartViberate];
    [encoder encodeObject:_profileImage forKey:kSafeHeartImage];
}

+ (NSString *)stringForLocation:(MonitorLocation)location {
    switch (location) {
        case MonitorLocationWaist:
            return @"Waist";
            break;
        case MonitorLocationArm:
            return @"Arm";
            break;
        case MonitorLocationJacket:
            return @"Jacket";
            break;
        default:
            break;
    }
}

@end
