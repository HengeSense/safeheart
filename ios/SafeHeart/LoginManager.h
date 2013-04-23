//
//  LoginManager.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SafeHeartUser.h"
#import "RequestManager.h"

@protocol LoginManagerDelegate <NSObject>

- (void)loginSuccessful;
- (void)loginFailedWithError:(NSString *)errorString;

@end

@interface LoginManager : NSObject <RMLoginDelegate> {
    
}

@property (nonatomic,weak) id<LoginManagerDelegate> delegate;
@property (nonatomic, strong) SafeHeartUser *user;

+ (LoginManager *)sharedInstance;

- (void)logInWithUsername:(NSString*)username andPassword:(NSString *)password;
- (BOOL)isLoggedIn;
- (void)logOut;
- (SafeHeartUser*) user;

@end
