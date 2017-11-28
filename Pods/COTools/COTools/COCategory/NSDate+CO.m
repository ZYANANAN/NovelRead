//
//  NSDate+CO.m
//  COCategory
//
//  Created by carlos on 13-9-15.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "NSDate+CO.h"
#import "NSDateFormatter+CO.h"

@implementation NSDate (CO)
//shared NSCalendar 阳历
+ (NSCalendar *)sharedCalendar {
    static NSCalendar *calendar;
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    }
    return calendar;
}

//字符串转换成日期
+(NSDate *) converToDate:(NSString *)mDateContent{
    if (!mDateContent.length) {
        return nil;
    }
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:mDateContent];
    return date;
}

//字符串转换成日期
+(NSDate *) converToDate:(NSString *)mDateContent withFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:mDateContent];
    return date;
}

//获取当月天数
+(NSInteger)daysInCurrentMonth {
    NSDate *today = [NSDate date];
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:today];
    
    return days.length;
}

//根据日期获取年月日时分秒
- (NSString *) converToString{
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate *date=[formatter dateFromString:mDateContent];
    return [formatter stringFromDate:self];;
}

//根据日期获取年月日时分秒(中间用+号相连)
- (NSString *) converToStringConnectByAddSymbol {
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance] ;
    [formatter setDateFormat:@"yyyy-MM-dd+HH:mm:ss"];
    //    NSDate *date=[formatter dateFromString:mDateContent];
    return [formatter stringFromDate:self];
}

//根据日期获取年月日时分秒
- (NSString *) converToStringWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter sharedInstance] ;
    [formatter setDateFormat:format];
    //    NSDate *date=[formatter dateFromString:mDateContent];
    return [formatter stringFromDate:self];;
}

- (BOOL)isTheSameDayWithDate:(NSDate *)date {
    NSDateComponents *dateComponentsOfSelf = self.dateComponents;
    NSDateComponents *dateComponentsOfDate = date.dateComponents;
    if (dateComponentsOfSelf.year == dateComponentsOfDate.year && dateComponentsOfSelf.month == dateComponentsOfDate.month && dateComponentsOfSelf.day == dateComponentsOfDate.day) {
        return YES;
    }
    return NO;
}

- (NSDateComponents *)dateComponents {
    NSCalendar *calendar = [NSDate sharedCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    return comps;
}

- (BOOL)isTheSameMonthToCurrent {
    NSDate *currentDate = [NSDate date];
    if (self.dateComponents.year == currentDate.dateComponents.year && self.dateComponents.month == currentDate.dateComponents.month) {
        return YES;
    }
    return NO;
}

- (NSInteger)minutesInThisMonth {
    return (self.dateComponents.day - 1) * 24 * 60 + self.dateComponents.hour * 60 + self.dateComponents.minute;
}
@end
