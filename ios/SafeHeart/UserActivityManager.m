//
//  UserActivityManager.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-15.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "UserActivityManager.h"
#import "CacheManager.h"
#import "Activity.h"
#import "RecentActivity.h"
#import "ActivityUtils.h"

@implementation UserActivityManager

+ (UserActivityManager *)sharedInstance {
    static UserActivityManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self retrieveCache];
    }
    return self;
}

#pragma mark - Public Methods

-(void)getActivityForType:(ActivityType)type {
    NSDate *date = [self getDateForType:type];
    if ([self isDateValid:date]) {
        if ([_delegate respondsToSelector:@selector(activityFetchedForType:array:)]) {
            [_delegate activityFetchedForType:type array:[self getArrayForType:type]];
        }
    } else {
        [[RequestManager sharedInstance] requestActivityOfType:[ActivityUtils getStringForType:type] andDelegate:self];
    }
}


#pragma mark - Helper Methods

- (BOOL)isDateValid:(NSDate *)date {
    return (date != nil) && ([[NSDate date] timeIntervalSinceDate:date] < 3600*24*7);
}


- (NSDate *)getDateForType:(ActivityType)type {
    switch (type) {
        case 0:
            return _lastUpdateAll;
            break;
        case 1:
            return _lastUpdateRecommended;
            break;
        case 2:
            return nil;
            break;            
        default:
            return _lastUpdateAll;
            break;
    }
}

- (NSMutableArray *)getArrayForType:(ActivityType)type {
    switch (type) {
        case 0:
            return _activityListAll;
            break;
        case 1:
            return _activityListRecommended;
            break;
        case 2:
            return _activityListRecent;
            break;
        default:
            return _activityListAll;
            break;
    }
}

- (void)copyArray:(NSMutableArray *)array IntoArrayForType:(ActivityType)type {
    switch (type) {
        case 0:
            _activityListAll = [[NSMutableArray alloc] initWithArray:array];
            break;
        case 1:
            _activityListRecommended = [[NSMutableArray alloc] initWithArray:array];
            break;
        case 2:
            _activityListRecent = [[NSMutableArray alloc] initWithArray:array];
            break;
        default:
            _activityListAll = [[NSMutableArray alloc] initWithArray:array];
            break;
    }
}


#pragma mark - Cache Methods

- (void)retrieveCache {
    [self retrieveAll];
    [self retrieveRecommended];
    [self retrieveRecent];
}

- (void)retrieveAll {
    NSDictionary *dictionary = [[CacheManager sharedInstance] retrieveObjectInArchive:[ActivityUtils getArchiveStringForType:ActivityTypeAll]];
    if (dictionary) {
        _lastUpdateAll = [dictionary objectForKey:kActivityUpdateTime];
        _activityListAll = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:kActivityArray]];
    }
}

- (void)retrieveRecommended {
    NSDictionary *dictionary = [[CacheManager sharedInstance] retrieveObjectInArchive:[ActivityUtils getArchiveStringForType:ActivityTypeRecommended]];
    if (dictionary) {
        _lastUpdateRecommended = [dictionary objectForKey:kActivityUpdateTime];
        _activityListRecommended = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:kActivityArray]];
    }
}

- (void)retrieveRecent {
    NSDictionary *dictionary = [[CacheManager sharedInstance] retrieveObjectInArchive:[ActivityUtils getArchiveStringForType:ActivityTypeRecent]];
    if (dictionary) {
        _activityListRecent = [[NSMutableArray alloc] initWithArray:[dictionary objectForKey:kActivityArray]];
    }
}

#pragma mark - RMActivityDelegate Methods

- (void)activityFetchSuccessWithType:(ActivityType)type andActivities:(NSArray *)activities {
    NSMutableArray *array;
    NSDate *date;
    if (type == ActivityTypeRecent) {
        _activityListRecent = [[NSMutableArray alloc] initWithArray:activities];
        array = _activityListRecent;
        date = nil;
    } else if (type == ActivityTypeAll) {
        _activityListAll = [[NSMutableArray alloc] initWithArray:activities];
        array = _activityListAll;
        _lastUpdateAll = [NSDate date];
        date = _lastUpdateAll;
    } else {
        _activityListRecommended = [[NSMutableArray alloc] initWithArray:activities];
        array = _activityListRecommended;
        _lastUpdateRecommended = [NSDate date];
        date = _lastUpdateRecommended;
    }
    
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:date,kActivityUpdateTime ,array,kActivityArray,nil];
    
    [[CacheManager sharedInstance] cacheObject:dictionary archive:[ActivityUtils getArchiveStringForType:type]];
    
    if ([_delegate respondsToSelector:@selector(activityFetchedForType:array:)]) {
        [_delegate activityFetchedForType:type array:array];
    }
}

- (void)activityFetchFailedWithType:(ActivityType)type andError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(activityFecthFailForType:oldArray:error:)]) {
        [_delegate activityFecthFailForType:type oldArray:[self getArrayForType:type] error:error];
    }
}

@end
