//
//  LoginManager.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "LoginManager.h"
#import "CacheManager.h"
#import "Constants.h"

@implementation LoginManager

#pragma mark - LifeCycle Methods

+ (LoginManager *)sharedInstance {
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self getCachedUser];
    }
    return self;
}

#pragma mark - Public Methods

- (void)logInWithUsername:(NSString *)username andPassword:(NSString *)password {
    [[RequestManager sharedInstance] requestLoginWithUserName:username Password:password andDelegate:self];
}

- (void)logOut {
    _user = nil;
    [[CacheManager sharedInstance] clearCacheForArchive:USER_ARCHIVE];
}

- (BOOL)isLoggedIn {
    return _user != nil;
}

#pragma mark - Helper Methods

- (void)getCachedUser {
    SafeHeartUser *user = [[CacheManager sharedInstance] retrieveObjectInArchive:USER_ARCHIVE];
    if (user != nil) {
        _user = user;
    }
}

#pragma mark - RMLoginDelegate Methods

- (void)loginSuccessfulWithUser:(SafeHeartUser *)user {
    [user setMonitorLocation:MonitorLocationWaist];
    [user setViberate:YES];
    _user = user;
    [[CacheManager sharedInstance] cacheObject:_user archive:USER_ARCHIVE];
    
    if ([_delegate respondsToSelector:@selector(loginSuccessful)]) {
        [_delegate loginSuccessful];
    }
}

- (void)loginFailedWithError:(NSError *)error {
    _user = nil;
    
    [[CacheManager sharedInstance] clearCacheForArchive:USER_ARCHIVE];
    
    if ([_delegate respondsToSelector:@selector(loginFailedWithError:)]) {
        [_delegate loginFailedWithError:[error localizedDescription]];
    }
}

-(SafeHeartUser*) user {
    return _user;
}

@end
