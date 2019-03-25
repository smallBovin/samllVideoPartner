//
//  NSDate+MBExtension.h
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/7.
//  Copyright © 2019年 bovin. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MBExtension)

/**
 *  2016-1-1
 */
- (NSString *)YMDString;
/**
 *  2016.1.1
 */
- (NSString *)YMDPointString;

+ (NSString *)YMDStringFromSecondsSince1970:(long long)seconds;
/**
 *  Transform local date to UTC date.
 *
 *  @param date Data type is NSDate and the date is device's time.
 *
 *  @return UTC date
 */
+ (NSDate *)UTCDateFromLocalDate:(NSDate *)date;

/**
 *  Transform UTC date to local date.
 *
 *  @param date Data type is NSDate and UTC date.
 *
 *  @return Local date
 */
+ (NSDate *)localDateFromUTCDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
