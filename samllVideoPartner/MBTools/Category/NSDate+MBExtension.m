//
//  NSDate+MBExtension.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/7.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "NSDate+MBExtension.h"

static NSDateFormatter *_dateFormatter;

@implementation NSDate (MBExtension)

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}
- (NSString *)YMDString {
    self.dateFormatter.dateFormat = @"YYYY-MM-dd";
    return [self.dateFormatter stringFromDate:self];
}

- (NSString *)YMDPointString {
    self.dateFormatter.dateFormat = @"YYYY.MM.dd";
    return [self.dateFormatter stringFromDate:self];
}

+ (NSString *)YMDStringFromSecondsSince1970:(long long)seconds {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [date YMDString];
}

+ (NSDate *)localDateFromUTCDate:(NSDate *)date {
    // time zone
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    
    // offset
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    // interval
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    return destinationDateNow;
}

+ (NSDate *)UTCDateFromLocalDate:(NSDate *)date
{
    // time zone
    NSTimeZone *sourceTimeZone = [NSTimeZone localTimeZone];
    // interval
    NSTimeInterval interval = [sourceTimeZone secondsFromGMT];
    
    NSDate *destinationDateNow = [date dateByAddingTimeInterval:-interval];
    return destinationDateNow;
}

@end
