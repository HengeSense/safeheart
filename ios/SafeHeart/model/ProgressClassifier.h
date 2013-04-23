//
//  ProgressClassifier.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-27.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProgressClassifier <NSObject>

- (NSString*) classifyProgress:(double)p;

@end
