#import "ServerPostObject.h"

@implementation ServerPostObject
@synthesize path = path_;
@synthesize parameters = parameters_;

#define POST_PATH @"postIdentifier"
#define POST_DICTIONARY @"postDictionary"
#define POST_LOG @"postLog"

- (id)initWithParameters:(NSDictionary *)parameters path:(NSString *)path andLog:(ActivityLog *)log{
    self = [super init];
    if (self) {
        parameters_ = parameters;
        path_ = path;
        _log = log;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        path_ = [decoder decodeObjectForKey:POST_PATH];
        parameters_ = [decoder decodeObjectForKey:POST_DICTIONARY];
        _log = [decoder decodeObjectForKey:POST_LOG];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:path_ forKey:POST_PATH];
    [encoder encodeObject:parameters_ forKey:POST_DICTIONARY];
    [encoder encodeObject:_log forKey:POST_LOG];
}

@end
