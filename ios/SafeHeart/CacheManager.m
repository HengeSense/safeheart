//
//  CacheManager.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "CacheManager.h"

@interface CacheManager ()

//Helper Methods
- (NSString *)getArchive:(NSString *)archive;

@end

@implementation CacheManager

#pragma mark - LifeCycle Methods

+ (CacheManager *)sharedInstance {
    static CacheManager *sharedInstance_ = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        sharedInstance_ = [[self alloc] init];
    });
    
    return sharedInstance_;
}

#pragma mark - Helper Methods
   
- (NSString *)getArchive:(NSString *)archive {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingFormat:@"/%@",archive];
    return filePath;
}


#pragma mark - Archive Methods

- (void)cacheObject:(id)object archive:(NSString *)archive {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSKeyedArchiver archiveRootObject:object toFile:[self getArchive:archive]];
    });
}

- (id)retrieveObjectInArchive:(NSString *)archive {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getArchive:archive]];
}

//- (NSArray *)getCacheNamed:(NSString *)archiveName {
//    NSString *path = [self getArchive:archiveName];
//    
//    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
//    return directoryContent;
//}

- (void)clearCacheForArchive:(NSString *)archive {
    [self cacheObject:nil archive:archive];
}


@end
