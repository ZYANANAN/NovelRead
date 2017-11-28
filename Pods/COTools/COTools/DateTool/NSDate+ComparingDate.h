//
//  NSDate+ComparingDate.h
//  OCCategory
//
//  Created by lin wu on 6/3/15.
//  Copyright (c) 2015 lin wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ComparingDate)

/**
    是否为今天
 */
- (BOOL)isToday;

/**
    是否为昨天
 */
- (BOOL)isYesterday;

/**
    是否为今年
 */
- (BOOL)isThisYear;

/**
    返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
    获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

@end
