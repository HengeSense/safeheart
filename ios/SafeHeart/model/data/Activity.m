//
//  Activity.m
//  SafeHeart
//
//  Created by Marc Fiume on 2013-02-23.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "Activity.h"

#define NAME @"name"
#define OXYGEN @"oxygen"
#define INTENSITY @"intensity"
#define ICON @"icon"
#define ICON @"icon"
#define SPORT_ID @"sportid"


@implementation Activity

- (id)initWithName:(NSString *)n oxygen:(ActivityO2Level)o intensity:(ActivityIntensityLevel) i icon:(UIImage*) icn sportId:(NSString *)sportId{
    
    if (self = [super init]) {
        _name = n;
        _oxygen = o;
        _intensity = i;
        _icon = icn;
        _sport_id = sportId;
        return self;
    } else {
        return nil;
    }
}


- (id)initWithDictionary:(NSDictionary *)dictionary {
    NSString *dName = [dictionary objectForKey:@"name"];
    ActivityO2Level dOxygen = [[dictionary objectForKey:@"dynamic_level"] intValue];
    dOxygen = dOxygen ? dOxygen : 1;
    
    ActivityIntensityLevel dIntensity = [[dictionary objectForKey:@"static_level"] intValue];
    
    dIntensity = dIntensity ? dIntensity : 1;
    UIImage *image = [UIImage imageNamed:[dictionary objectForKey:@"image"]];
    
    NSString *sportId = [dictionary objectForKey:@"sport_id"];
    
    return [self initWithName:dName oxygen:dOxygen intensity:dIntensity icon:image sportId:sportId] ;
}

- (id)initWithActivity:(Activity *)activity {
    return [self initWithName:activity.name oxygen:activity.oxygen intensity:activity.intensity icon:activity.icon sportId:activity.sport_id];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _name = [decoder decodeObjectForKey:NAME];
        _oxygen = [decoder decodeIntegerForKey:OXYGEN];
        _intensity = [decoder decodeIntegerForKey:INTENSITY];
        _icon = [decoder decodeObjectForKey:ICON];
        _sport_id = [decoder decodeObjectForKey:SPORT_ID];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:NAME];
    [encoder encodeInteger:_oxygen forKey:OXYGEN];
    [encoder encodeInteger:_intensity forKey:INTENSITY];
    [encoder encodeObject:_icon forKey:ICON];
    [encoder encodeObject:_sport_id forKey:SPORT_ID];
}


-(NSString*) getOxygenLevelString { return stringWithActivityO2Level(_oxygen); }
-(NSString*) getIntensityLevelString { return stringWithActivityIntensityLevel(_intensity); }

NSString *stringWithActivityO2Level(ActivityO2Level input) {
    NSArray *arr = @[
                     @"Low",
                     @"Medium",
                     @"High"
                     ];
    return (NSString *)[arr objectAtIndex:input-1];
}

NSString *stringWithActivityIntensityLevel(ActivityIntensityLevel input) {
    NSArray *arr = @[
                     @"Low",
                     @"Medium",
                     @"High"
                     ];
    return (NSString *)[arr objectAtIndex:input-1];
}




@end
