//
//  SafeHeartHTTPClient.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "SafeHeartHTTPClient.h"
#import "Constants.h"

@implementation SafeHeartHTTPClient

#pragma mark - LifeCycle Methods

+ (SafeHeartHTTPClient *)sharedClient {
    static SafeHeartHTTPClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_API_PATH]];
    });
    
    return _sharedClient;
}


@end
