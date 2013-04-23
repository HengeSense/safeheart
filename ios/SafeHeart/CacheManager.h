//
//  CacheManager.h
//  SafeHeart
//
//  Created by Rohan Bali on 2013-02-09.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject {
}

+ (CacheManager *)sharedInstance;

//Save, retrieve, delete
- (void)cacheObject:(id)object archive:(NSString *)archive;
- (id)retrieveObjectInArchive:(NSString *)archive;
//- (NSArray *)getCacheNamed:(NSString *)archiveName;
- (void)clearCacheForArchive:(NSString *)archive;
@end
