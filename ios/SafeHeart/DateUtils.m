//
//  DateUtils.m
//  SafeHeart
//
//  Created by Rohan Bali on 2013-03-01.
//  Copyright (c) 2013 Marc Fiume. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSString *)stringForDateDifference:(NSDate *)date {
    NSMutableString *returnString = [[NSMutableString alloc] init];
    
    if ([DateUtils isThisWeek:date]) {
        [returnString appendString:[DateUtils getDayNameFromDate:date]];
    } else {
        [returnString appendString:[NSString stringWithFormat:@"%@ %@",[DateUtils getDayNumberFromDate:date],[DateUtils getMonthNameFromDate:date]]];
        
        if ([DateUtils isThisYear:date]) {
            [returnString appendString:[DateUtils getYearNumberFromDate:date]];
        }
    }
    
    return returnString;
}


+ (BOOL)isThisWeek:(NSDate *)date {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:date
                                                          toDate:[NSDate date]
                                                         options:0];
    
    return [components day] < 7;
}

+ (BOOL)isThisYear:(NSDate *)date {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:date
                                                          toDate:[NSDate date]
                                                         options:0];
    
    return [components year] < 1;
}


+ (NSString *)getDayNameFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getMonthNameFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"MMMM";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getYearNumberFromDate:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%d",[compoNents year]];
}

+ (NSString *)getDayNumberFromDate:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%d",[compoNents day]];
}


@end
