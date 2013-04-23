#import "ServerPostQueue.h"

#define POST_QUEUE @"postQueue"

@implementation ServerPostQueue

- (id)init {
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}
        
- (void)pushObject:(ServerPostObject *)object {
    [_queue addObject:object];   
}

- (ServerPostObject *)pop {
    ServerPostObject *firstObject = nil;
    if([_queue count] > 0) {
        firstObject = [_queue objectAtIndex:0];
        [_queue removeObjectAtIndex:0];
    }
    return firstObject;
}

- (ServerPostObject *)lastObject {
    ServerPostObject *firstObject = nil;
    if([_queue count] > 0) {
        firstObject = [_queue objectAtIndex:0];
    }
    return firstObject;
}

- (BOOL)isEmpty {
    return !([_queue count] > 0);
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _queue = [decoder decodeObjectForKey:POST_QUEUE];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_queue forKey:POST_QUEUE];
}

- (void)clear {
    [_queue removeAllObjects];
}

@end
