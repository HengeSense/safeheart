//
//  Activity.h
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-23.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ActivityO2LevelLow = 1,
    ActivityO2LevelMedium = 2,
    ActivityO2LevelHigh = 3
};
typedef NSUInteger ActivityO2Level;

enum {
    ActivityIntensityLevelLow = 1,
    ActivityIntensityLevelMedium = 2,
    ActivityIntensityLevelHigh = 3
};
typedef NSUInteger ActivityIntensityLevel;


enum {
    ActivityIntensityLevelOK = 1,
    ActivityIntensityLevelConsultClinician = 2,
    ActivityIntensityLevelNotOK = 3
};
typedef NSUInteger ActivityRecommendation;

@interface Activity : NSObject {

}

@property (nonatomic,strong) NSString* name;
@property (nonatomic,assign) ActivityIntensityLevel intensity;
@property (nonatomic,assign) ActivityO2Level oxygen;
@property (nonatomic,strong) UIImage* icon;
@property (nonatomic,strong) NSString* sport_id;


- (id)initWithName:(NSString *)n oxygen:(ActivityO2Level)o intensity:(ActivityIntensityLevel) i icon:(UIImage*) icn;
- (id)initWithActivity:(Activity *)activity;
- (id)initWithDictionary:(NSDictionary *)dictionary;



-(NSString*) getOxygenLevelString;
-(NSString*) getIntensityLevelString;

@end
