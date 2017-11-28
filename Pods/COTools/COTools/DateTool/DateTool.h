//
//  DateTool.h
//  KingReader
//
//  Created by lin wu on 6/3/15.
//  Copyright (c) 2015 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTool : NSObject
+ (NSString *)comparingWithString:(NSString *)dateStr;
+ (NSString *)comparingWithDate:(NSDate *)date;
+ (NSString *)comparingDateWithDate:(NSDate *)date;
@end
