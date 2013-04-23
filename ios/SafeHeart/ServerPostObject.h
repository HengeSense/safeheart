#import <Foundation/Foundation.h>
#import "ActivityLog.h"

@interface ServerPostObject : NSObject <NSCoding> {
    
}

@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) ActivityLog *log;


- (id)initWithParameters:(NSDictionary *)parameters path:(NSString *)path andLog:(ActivityLog *)log;

@end
