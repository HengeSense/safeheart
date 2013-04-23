//
//  StoryBoardController.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryBoardController : NSObject

+(UIStoryboard*) storyBoard;

+(NSString *) identifierConnectHRView;
+(NSString *) identifierLoginView;
+(NSString *) identifierRootView;
+(NSString *) identifierSummaryView;
+(NSString *) identifierMenuView;
+(NSString *) identifierSlideView;
+(NSString *) identifierInActivityView;

+(NSString *) identifierMenuCell;
+(NSString *) identifierRecentActivityCell;

+ (NSString *)identifierCompletionView;


@end
