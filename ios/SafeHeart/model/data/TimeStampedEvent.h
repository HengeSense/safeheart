//
//  HeartRateEvent.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-03-11.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeStampedEvent : NSObject {
    NSDate* time;
    NSObject* payload;
}

-(id) initWithTime:(NSDate*)t Payload:(NSObject*) p;
-(NSObject*) payload;
-(NSDate*) time;

@end
