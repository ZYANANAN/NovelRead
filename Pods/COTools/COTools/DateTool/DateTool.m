//
//  DateTool.m
//  KingReader
//
//  Created by lin wu on 6/3/15.
//  Copyright (c) 2015 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "DateTool.h"
#import "NSDate+ComparingDate.h"
#import "NSDateFormatter+CO.h"
@implementation DateTool

+ (NSString *)comparingWithString:(NSString *)dateStr {
    NSDateFormatter *fmt = [NSDateFormatter sharedInstance];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];  // 这是美国的时间格式
    NSDate *createdDate = [fmt dateFromString:dateStr];
    return [self comparingDateWithDate:createdDate];
}

+ (NSString *)comparingWithDate:(NSDate *)date {
    return [self comparingDateWithDate:date];
}

+ (NSString *)comparingDateWithDate:(NSDate *)date {
    NSDateFormatter *fmt = [NSDateFormatter sharedInstance];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    if (date.isToday) {
        // 今天
        if (date.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前", (long)date.deltaWithNow.hour];
        } else if (date.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)date.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (date.isYesterday) {
        // 昨天
        fmt.dateFormat = @"昨天HH:mm";
        return [fmt stringFromDate:date];
    } else if (date.isThisYear) {
        // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd";
        return [fmt stringFromDate:date];
    } else {
        // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:date];
    }
}

@end
