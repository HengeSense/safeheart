//
//  UserActivityManager.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-15.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "RequestManager.h"

@protocol UserActivityDelegate <NSObject>

- (void)activityFetchedForType:(ActivityType)type array:(NSArray *)array;
- (void)activityFecthFailForType:(ActivityType)type oldArray:(NSArray *)array error:(NSError *)error;

@end

@interface UserActivityManager : NSObject <RMActivityDelegate> {
    NSMutableArray *_activityListAll;
    NSMutableArray *_activityListRecommended;
    NSMutableArray *_activityListRecent;
    NSDate *_lastUpdateAll;
    NSDate *_lastUpdateRecommended;
}

@property (nonatomic,strong) id<UserActivityDelegate> delegate;

+ (UserActivityManager *)sharedInstance;
- (void)getActivityForType:(ActivityType)type;

@end
