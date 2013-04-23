//
//  RequestManager.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "RequestManager.h"
#import "SafeHeartHTTPClient.h"
#import "Constants.h"
#import "LoginManager.h"
#import <CoreLocation/CoreLocation.h>
#import "CacheManager.h"
#import "AFHTTPRequestOperation.h"
#import "NSString+md5.h"
#import "ActivityUtils.h"
#import "RecentActivity.h"
//#import "SBJSON.h"

@implementation RequestManager

#pragma mark - LifeCycle Methods

+ (RequestManager *)sharedInstance {
    static RequestManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;

}

- (id)init {
    self = [super init];
    if (self) {
        [self setupQueue];
    }
    return self;
}

#pragma mark - Setup Methods

- (void)setupQueue {
    _postQueue = (ServerPostQueue *)[[CacheManager sharedInstance] retrieveObjectInArchive:QUEUE_ARCHIVE];
    if (_postQueue == nil) {
        _postQueue = [[ServerPostQueue alloc] init];
    }
}



#pragma mark - Public Methods

- (void)requestLoginWithUserName:(NSString *)username Password:(NSString *)password andDelegate:(id<RMLoginDelegate>)delegate {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    username, @"username",
                                    [password MD5], @"password",
                                    @"login",@"request",
                                    @"post",@"request_type",nil];
        
        [[SafeHeartHTTPClient sharedClient] postPath:LOGIN_API_PATH
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [self handleLoginSuccessResponseObject:responseObject error:nil delegate:delegate];
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [self handleLoginFailError:error delegate:delegate];
                                             }];
    });

}



- (void)requestActivityOfType:(NSString *)type andDelegate:(id<RMActivityDelegate>)delegate {
    
    if ([ActivityUtils getTypeForString:type] == ActivityTypeRecent) {
        [self requestRecentWithDelegete:delegate];
    } else if ([ActivityUtils getTypeForString:type] == ActivityTypeRecommended) {
        [self requestRecommendedWithDelegete:delegate];
    } else {
        [self requestAllWithDelegete:delegate];
    }
}

#pragma mark - Activity Helper Methods

- (void)requestActivityLogForActivity:(RecentActivity *)recentActivity completion:(void (^)(NSDictionary *dictionary))completionBlock {
    SafeHeartUser *user = [[LoginManager sharedInstance] user];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"activity",@"request",@"get",@"request_type",[user sessionKey],@"session", [recentActivity activityId],@"activity_id",@"heartRateEvents",@"which",nil];
    
    __block NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    __block int numberCompleted = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [dict setObject:[self getEventsForHeartRateWithObject:responseObject] forKey:@"heartRateEvents"];
                                                 numberCompleted++;
                                                 
                                                 if (numberCompleted == 3) {
                                                     completionBlock(dict);
                                                 }
                                                 
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 numberCompleted++;
                                                 if (numberCompleted == 3) {
                                                     completionBlock(dict);
                                                 }
                                             }];
    });
    
    params = [[NSDictionary alloc] initWithObjectsAndKeys:@"activity",@"request",@"get",@"request_type",[user sessionKey],@"session", [recentActivity activityId],@"activity_id",@"calorieEvents",@"which",nil];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [dict setObject:[self getEventsForCaloriesWithObject:responseObject] forKey:@"calorieEvents"];
                                                 numberCompleted++;
                                                 
                                                 if (numberCompleted == 3) {
                                                     completionBlock(dict);
                                                 }
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 numberCompleted++;
                                                 if (numberCompleted == 3) {
                                                     completionBlock(dict);
                                                 }
                                             }];
    });

    
    params = [[NSDictionary alloc] initWithObjectsAndKeys:@"activity",@"request",@"get",@"request_type",[user sessionKey],@"session", [recentActivity activityId],@"activity_id",@"locationEvents",@"which",nil];

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [dict setObject:[self getEventsForLocationWithObject:responseObject] forKey:@"locationEvents"];
                                                 numberCompleted++;
                                                 
                                                 if (numberCompleted == 3) {
                                                     completionBlock(dict);
                                                 }
                                                 
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 numberCompleted++;
                                                 if (numberCompleted == 3) {
                                                     completionBlock(dict);
                                                 }                                             }];
    });
}

- (NSArray *)getEventsForLocationWithObject:(id)responseObject {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
    if (newjsonError != nil || [dictionary objectForKey:@"events"] != nil) {
        NSArray *array = [dictionary objectForKey:@"events"];
        for (NSDictionary *dict in array) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[dict objectForKey:@"latitude"] doubleValue] longitude:[[dict objectForKey:@"longitude"] doubleValue]];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [timeFormat dateFromString:[dict objectForKey:@"time"]];
            
            TimeStampedEvent *event = [[TimeStampedEvent alloc] initWithTime:date Payload:location];
            [resultArray addObject:event];
        }
    }
    return resultArray;
}

- (NSArray *)getEventsForCaloriesWithObject:(id)responseObject {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
    if (newjsonError != nil || [dictionary objectForKey:@"events"] != nil) {
        NSArray *array = [dictionary objectForKey:@"events"];
        for (NSDictionary *dict in array) {
            NSNumber *calories = [dict objectForKey:@"calories"];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [timeFormat dateFromString:[dict objectForKey:@"time"]];
            
            TimeStampedEvent *event = [[TimeStampedEvent alloc] initWithTime:date Payload:calories];
            [resultArray addObject:event];
        }
    }
    return resultArray;
}

- (NSArray *)getEventsForHeartRateWithObject:(id)responseObject {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
    if (newjsonError != nil || [dictionary objectForKey:@"events"] != nil) {
        NSArray *array = [dictionary objectForKey:@"events"];
        for (NSDictionary *dict in array) {
            NSNumber *heartRate = [dict objectForKey:@"heartRate"];
            NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
            [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [timeFormat dateFromString:[dict objectForKey:@"time"]];
            TimeStampedEvent *event = [[TimeStampedEvent alloc] initWithTime:date Payload:heartRate];
            [resultArray addObject:event];
        }
    }
    return resultArray;
}



- (void)requestRecentWithDelegete:(id<RMActivityDelegate>)delegate {
    SafeHeartUser *user = [[LoginManager sharedInstance] user];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"activities",@"request",@"get",@"request_type",[user sessionKey],@"session", @"10",@"limit",nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [self handleRecentActivitySuccessResponseObject:responseObject delegate:delegate];
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [self handleRecentActivityFailError:error delegate:delegate];
                                             }];
    });
}

- (void)requestRecommendedWithDelegete:(id<RMActivityDelegate>)delegate {
    SafeHeartUser *user = [[LoginManager sharedInstance] user];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"recommendations",@"request",@"get",@"request_type",[user sessionKey],@"session",nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [self handleRecommendedActivitySuccessResponseObject:responseObject delegate:delegate];
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [self handleRecommendedActivityFailError:error delegate:delegate];
                                             }];
    });
}


- (void)requestAllWithDelegete:(id<RMActivityDelegate>)delegate {
    SafeHeartUser *user = [[LoginManager sharedInstance] user];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"sports",@"request",@"get",@"request_type",[user sessionKey],@"session",nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [self handleAllActivitySuccessResponseObject:responseObject delegate:delegate];
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [self handleAllActivityFailError:error delegate:delegate];
                                             }];
    });
}

#pragma mark -  Queue Methods

- (void)clearQueue {
    @synchronized(_postQueue) {
        [_postQueue clear];
        [[CacheManager sharedInstance] cacheObject:_postQueue archive:QUEUE_ARCHIVE];
    }
}

- (void)addToQueueWithParameters:(NSDictionary *)parameters path:(NSString *)path andLog:(ActivityLog *)log {
    @synchronized(_postQueue) {
        ServerPostObject *postObject = [[ServerPostObject alloc] initWithParameters:parameters path:path andLog:log];
        [_postQueue pushObject:postObject];
        [[CacheManager sharedInstance] cacheObject:_postQueue archive:QUEUE_ARCHIVE];
    }
}

- (void)requestCallWithObject:(ServerPostObject *)object {
    [[SafeHeartHTTPClient sharedClient] postPath:[object path]
                                      parameters:[object parameters]
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [self handleRequestWithPath:[object path] parameters:[object parameters] log:[object log] responseObject:responseObject];
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [self handleFailedPostRequestWithPath:[object path] parameters:[object parameters] log:[object log] responseObject:[operation responseData] andError:error];
                                         }];
}

- (void)dispatchQueue {
    @synchronized(_postQueue){
        if (![_postQueue isEmpty]) {
            ServerPostObject *object = [_postQueue lastObject];
            if(object != nil) {
                [self requestCallWithObject:object];
            }
            [[CacheManager sharedInstance] cacheObject:_postQueue archive:QUEUE_ARCHIVE];
        }
    }
}


- (void)popQueue {
    @synchronized(_postQueue){
        [_postQueue pop];
    }
}

#pragma mark - Response Handler Methods

- (void)handleLoginSuccessResponseObject:(id)responseObject error:(NSError *)error delegate:(id<RMLoginDelegate>)delegate {
    
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
    
    if (newjsonError || ![(NSString *)[dictionary objectForKey:@"loggedIn"] isEqualToString:@"true"]) {
        [self handleLoginFailError:newjsonError delegate:delegate];
    } else {
        SafeHeartUser *user = [[SafeHeartUser alloc] initWithAttributes:dictionary];
        if ([delegate respondsToSelector:@selector(loginSuccessfulWithUser:)]) {
            [delegate loginSuccessfulWithUser:user];
        }
    }
}

- (void)handleLoginFailError:(NSError *)error delegate:(id<RMLoginDelegate>)delegate {
    if ([delegate respondsToSelector:@selector(loginFailedWithError:)]) {
        [delegate loginFailedWithError:error];
    }
}

- (void)handleRecentActivitySuccessResponseObject:(id)responseObject delegate:(id<RMActivityDelegate>)delegate {
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
   
    if (newjsonError != nil || [dictionary objectForKey:@"activities"] != nil) {
        NSArray *dictionariesArray = [dictionary objectForKey:@"activities"];
        [self requestActivityDetailsForRecentActivityDictionaryArray:dictionariesArray completion:^(NSArray *array) {
            if ([delegate respondsToSelector:@selector(activityFetchSuccessWithType:andActivities:)]) {
                [delegate activityFetchSuccessWithType:ActivityTypeRecent andActivities:array];
            }}];
        } else {
        [self handleRecentActivityFailError:nil delegate:delegate];
    }
}


- (void)handleRecentActivityFailError:(NSError *)error delegate:(id<RMActivityDelegate>)delegate {
    if ([delegate respondsToSelector:@selector(activityFetchFailedWithType:andError:)]) {
        [delegate activityFetchFailedWithType:ActivityTypeRecent andError:error];
    }
}


- (void)handleRecommendedActivitySuccessResponseObject:(id)responseObject delegate:(id<RMActivityDelegate>)delegate {
    
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
    
    if (newjsonError != nil || [dictionary objectForKey:@"sports"] != nil) {
        NSArray *dictionariesArray = [dictionary objectForKey:@"sports"];
        NSMutableArray *recommendedActivityArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dictionary in dictionariesArray) {
            Activity *activity = [[Activity alloc] initWithDictionary:dictionary];
            [recommendedActivityArray addObject:activity];
        }
        
        if ([delegate respondsToSelector:@selector(activityFetchSuccessWithType:andActivities:)]) {
            [delegate activityFetchSuccessWithType:ActivityTypeRecommended andActivities:recommendedActivityArray];
        }
    } else {
        [self handleRecentActivityFailError:nil delegate:delegate];
    }
    
}

- (void)handleRecommendedActivityFailError:(NSError *)error delegate:(id<RMActivityDelegate>)delegate {
    if ([delegate respondsToSelector:@selector(activityFetchFailedWithType:andError:)]) {
        [delegate activityFetchFailedWithType:ActivityTypeRecommended andError:error];
    }
}

- (void)handleAllActivitySuccessResponseObject:(id)responseObject delegate:(id<RMActivityDelegate>)delegate {
    NSError *newjsonError = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
    
    if (newjsonError != nil || [dictionary objectForKey:@"sports"] != nil) {
        NSArray *dictionariesArray = [dictionary objectForKey:@"sports"];
        NSMutableArray *allActivityArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dictionary in dictionariesArray) {
            Activity *activity = [[Activity alloc] initWithDictionary:dictionary];
            [allActivityArray addObject:activity];
        }
        
        if ([delegate respondsToSelector:@selector(activityFetchSuccessWithType:andActivities:)]) {
            [delegate activityFetchSuccessWithType:ActivityTypeAll andActivities:allActivityArray];
        }
    } else {
        [self handleAllActivityFailError:nil delegate:delegate];
    }
    
}


- (void)handleAllActivityFailError:(NSError *)error delegate:(id<RMActivityDelegate>)delegate {
    if ([delegate respondsToSelector:@selector(activityFetchFailedWithType:andError:)]) {
        [delegate activityFetchFailedWithType:ActivityTypeAll andError:error];
    }
}

-(void)pushActivityLog:(ActivityLog*) l withDelegate:(id<RMActivityLogSyncDelegate>) d{
    
    __block ActivityLog* log = l;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString* username = [[[LoginManager sharedInstance] user] username];
        
        NSMutableArray * eventsArray = [[NSMutableArray alloc] init];
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        /**
         * Heart rate events
         */
        NSArray* heartRateEvents = [l heartRateEvents];
        for (TimeStampedEvent* e in heartRateEvents) {
            
            NSNumber* heartRateForEvent = (NSNumber*)[e payload];
            NSString* time = [timeFormat stringFromDate:[e time]];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 time, @"time",
                                                 heartRateForEvent, @"heartRate",
                                                 nil];
            [eventsArray addObject:dict];
        }
        
        NSError *error;
        NSData *heartRate_json_data = [NSJSONSerialization dataWithJSONObject:eventsArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *heartRate_json_str = [[NSString alloc] initWithData:heartRate_json_data encoding:NSUTF8StringEncoding];
        
        /**
         * Calorie events
         */
        eventsArray = [[NSMutableArray alloc] init];
        NSArray* calorieEvents = [l calorieEvents];
        for (TimeStampedEvent* e in calorieEvents) {
            
            NSNumber* calorieForEvent = (NSNumber*)[e payload];
            NSString* time = [timeFormat stringFromDate:[e time]];
            
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  time, @"time",
                                  calorieForEvent, @"calories",
                                  nil];
            [eventsArray addObject:dict];
        }
        
        NSData *calories_json_data = [NSJSONSerialization dataWithJSONObject:eventsArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *calories_json_str = [[NSString alloc] initWithData:calories_json_data encoding:NSUTF8StringEncoding];
        //NSLog(@"jsonData as string:\n%@", calories_json_str);
        
        /**
         * Location events
         */
        eventsArray = [[NSMutableArray alloc] init];
        NSArray* locationEvents = [l locationEvents];
        for (TimeStampedEvent* e in locationEvents) {
            
            CLLocation* location = (CLLocation*)[e payload];
            NSString* time = [timeFormat stringFromDate:[e time]];

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  time, @"time",
                                  [NSNumber numberWithFloat:location.coordinate.latitude], @"latitude",
                                  [NSNumber numberWithFloat:location.coordinate.longitude], @"longitude",
                                  [NSNumber numberWithFloat:location.altitude],@"altitude",
                                  nil];
            [eventsArray addObject:dict];
        }
        

        NSData *location_json_data = [NSJSONSerialization dataWithJSONObject:eventsArray options:NSJSONWritingPrettyPrinted error:&error];
        NSString *location_json_str = [[NSString alloc] initWithData:location_json_data encoding:NSUTF8StringEncoding];
        
        NSString *sportID = [[log activity] sport_id];
        
        SafeHeartUser *user = [[LoginManager sharedInstance] user];

        NSNumber *didMeasureCalories = [NSNumber numberWithInt:(int)[log didMeasureCalories]];
        NSNumber *didMeasureLocation = [NSNumber numberWithInt:(int)[log didMeasureLocation]];
        NSNumber *didMeasureHeartRate = [NSNumber numberWithInt:(int)[log didMeasureHeartRate]];
        
        NSNumber *duration = [NSNumber numberWithLong:[log duration]];
        NSNumber *distance = [NSNumber numberWithDouble:[log getTotalDistance]];
        NSNumber *calories = [NSNumber numberWithDouble:[log calories]];
        
        NSNumber *maxHearRate = [NSNumber numberWithInt:[log maxHeartRate]];
        NSNumber *averageHearRate = [NSNumber numberWithDouble:[log avgHeartRate]];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"activity",@"request",
                                    @"post",@"request_type",
                                    [user sessionKey], @"session",
                                    [[log activity] name], @"activity_type",
                                    [timeFormat stringFromDate:[log startTime]], @"activity_startTime",
                                    [timeFormat stringFromDate:[log stopTime]], @"activity_stopTime",
                                    heartRate_json_str,@"activity_heartRateEvents_json",
                                    location_json_str,@"activity_locationEvents_json",
                                    calories_json_str,@"activity_calorieEvents_json",sportID,@"sport_id",didMeasureCalories,@"activity_didMeasureCalories",didMeasureHeartRate,@"activity_didMeasureHeartRate",didMeasureLocation,@"activity_didMeasureLocation",duration,@"activity_duration",calories,@"activity_calories",distance,@"activity_distance",maxHearRate,@"activity_maxHeartRate",averageHearRate,@"activity_avgHeartRate",
                                    nil];
        
        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:parameters
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 [self handlePushActivityLogSuccessWithLog:log andDelegate:d];
                                                 [self dispatchQueue];
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [self handlePushActivityLFailWithEror:error Log:log parameters:parameters path:COMMAND_API_PATH responseObject:operation.response andDelegate:d];
                                             }];
        
    });
}

#pragma mark - Response Handler Methods


- (void)handlePushActivityLogSuccessWithLog:(ActivityLog *)log  andDelegate:(id<RMActivityLogSyncDelegate>) delegate {
    if (delegate != nil && [delegate respondsToSelector:@selector(activityLogSyncSuccessful:)]) {
        [delegate activityLogSyncSuccessful:log];
    }
}

- (void)handlePushActivityLFailWithEror:(NSError *)error  Log:(ActivityLog *)log parameters:(NSDictionary *)parameters path:(NSString *)path responseObject:(id)responseObject andDelegate:(id<RMActivityLogSyncDelegate>) delegate {
    
    
    BOOL connectionError = (responseObject == nil) || (error.code == -1009); //check it it was a coonection or server error somehow
    if (connectionError) {
        [self addToQueueWithParameters:parameters path:path andLog:log];
    }
    
    if (delegate != nil && [delegate respondsToSelector:@selector(activityLogSyncFailedWithError:)]) {
        [delegate activityLogSyncFailedWithError:error];
    }
}


#pragma mark - Queue Response Handler Methods

- (void)handleRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters log:(ActivityLog *)log responseObject:(id)responseObject {
        [self popQueue];
        [self dispatchQueue];
}

- (void)handleFailedPostRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters log:(ActivityLog *)log responseObject:(id)responseObject andError:(NSError *)error {
    
    BOOL connectionError = (responseObject == nil) || (error.code == -1009); //check it it was a coonection or server error somehow
    
    if (!connectionError) {     //if the actual call failed then remove it from list
        [self popQueue];
        [self dispatchQueue];
    }
}

#pragma mark - Handler Helper Methods


- (void)requestActivityDetailsForRecentActivityDictionaryArray:(NSArray *)array                        completion:(void (^)(NSArray *array))completionBlock {
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    int count = [array count];
    __block int currentCount = 0;
    
    
    for (NSDictionary *dictionary in array) {
        NSString *sportsID = [dictionary objectForKey:@"sport_id"];
        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"sport",@"request",sportsID,@"sport_id",@"get",@"request_type",nil];

        [[SafeHeartHTTPClient sharedClient] postPath:COMMAND_API_PATH
                                          parameters:params
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                
                                                 NSError *newjsonError = nil;
                                                 NSDictionary *activityDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&newjsonError];
                                                 
                                                 if (!newjsonError && activityDictionary) {
                                                     Activity *activity = [[Activity alloc] initWithDictionary:dictionary];
                                                     RecentActivity *recentActivity = [[RecentActivity alloc] initWithActivity:activity andDictionary:dictionary];
                                                     [resultArray addObject:recentActivity];
                                                 }
                                                 currentCount++;
                                                 
                                                 if (currentCount == count) {
                                                     completionBlock(resultArray);
                                                 }
                                                 
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 currentCount++;
                                                 if (currentCount == count) {
                                                     completionBlock(resultArray);
                                                 }
                                             }];
    }
}


@end
