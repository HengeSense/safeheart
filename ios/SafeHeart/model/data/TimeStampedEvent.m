//
//  HeartRateEvent.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-03-11.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "TimeStampedEvent.h"

#define TIME @"time"
#define PAYLOAD @"payload"

@implementation TimeStampedEvent

-(id) initWithTime:(NSDate*)t Payload:(NSObject*) p {
    self = [super init];
    if (self){
        time = t;
        payload = p;
    } return self;
}


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        time = [decoder decodeObjectForKey:TIME];
        payload = [decoder decodeObjectForKey:PAYLOAD];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:time forKey:TIME];
    [encoder encodeObject:payload forKey:PAYLOAD];
}


-(NSObject*) payload {
    return payload;
}

-(NSDate*) time {
    return time;
}

@end
