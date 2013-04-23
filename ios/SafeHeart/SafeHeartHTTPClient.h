//
//  SafeHeartHTTPClient.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SafeHeartHTTPClient : AFHTTPClient

+ (SafeHeartHTTPClient *)sharedClient;

@end
