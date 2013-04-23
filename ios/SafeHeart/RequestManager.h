//
//  RequestManager.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SafeHeartUser.h"
#import "ActivityLog.h"
#import "ServerPostQueue.h"
#import "RecentActivity.h"

@protocol RMActivityLogSyncDelegate <NSObject>

- (void)activityLogSyncSuccessful:(ActivityLog *)log;
- (void)activityLogSyncFailedWithError:(NSError *)error;

@end

@protocol RMLoginDelegate <NSObject>

- (void)loginSuccessfulWithUser:(SafeHeartUser *)user;
- (void)loginFailedWithError:(NSError *)error;

@end

@protocol RMActivityDelegate <NSObject>

- (void)activityFetchSuccessWithType:(ActivityType)type andActivities:(NSArray *)activities;
- (void)activityFetchFailedWithType:(ActivityType)type andError:(NSError *)error;

@end

@interface RequestManager : NSObject {
    ServerPostQueue *_postQueue;
}

+ (RequestManager *)sharedInstance;

- (void)requestLoginWithUserName:(NSString *)username Password:(NSString *)password andDelegate:(id<RMLoginDelegate>)delegate;


- (void)requestActivityOfType:(NSString *)type andDelegate:(id<RMActivityDelegate>)delegate;

-(void)pushActivityLog:(ActivityLog*) l withDelegate:(id<RMActivityLogSyncDelegate>) d;
-(NSArray*) getActivityLogs;

- (void)requestActivityLogForActivity:(RecentActivity *)recentActivity completion:(void (^)(NSDictionary *dictionary))completionBlock;

@end
