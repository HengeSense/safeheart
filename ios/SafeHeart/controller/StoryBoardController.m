//
//  StoryBoardController.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-08.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "StoryBoardController.h"

@implementation StoryBoardController

+(UIStoryboard*) storyBoard {
    return [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
}

+(NSString*) identifierConnectHRView {
    return @"viewConnect";
}

+(NSString *) identifierLoginView {
    return @"viewLogin";
}
+(NSString*) identifierRootView {
    return @"RootNavigationController";
}
+(NSString *) identifierSummaryView {
    return @"viewSummary";
}
+ (NSString *)identifierCompletionView {
    return @"activityCompletion";
}
+(NSString *) identifierMenuView {
    return @"viewMenu";
}
+(NSString *) identifierSlideView {
    return @"viewSlide";
}

+(NSString*) identifierInActivityView {
    return @"viewInActivity";
}

+(NSString *) identifierMenuCell {
    return @"cellMenu";
}

+(NSString *) identifierRecentActivityCell {
    return @"cellRecentActivity";
}

@end
