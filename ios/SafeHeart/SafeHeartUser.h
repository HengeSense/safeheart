//
//  SafeHeartUser.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface SafeHeartUser : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *safeHeartId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSNumber *weight;

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *userType;
@property (strong, nonatomic) NSString *sessionKey;
@property (strong, nonatomic) NSString *dashboardURL;

@property (nonatomic, assign) BOOL viberate;

@property (assign, nonatomic) MonitorLocation monitorLocation;
@property (strong, nonatomic) UIImage *profileImage;


- (SafeHeartUser *)initWithAttributes:(NSDictionary *)dictionary;

+ (NSString *)stringForLocation:(MonitorLocation)location;

@end
