#import <Foundation/Foundation.h>
#import "ServerPostObject.h"

@interface ServerPostQueue : NSObject <NSCoding> {
    NSMutableArray *_queue;
}

- (id)init;
- (ServerPostObject *)pop;
- (ServerPostObject *)lastObject;

- (void)pushObject:(ServerPostObject *)object;
- (BOOL)isEmpty;
- (void)clear;

@end
