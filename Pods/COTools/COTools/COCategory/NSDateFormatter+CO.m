//
//  NSDateFormatter+CO.m
//  KingReader
//
//  Created by wangbc on 15/6/17.
//  Copyright (c) 2015年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "NSDateFormatter+CO.h"

@implementation NSDateFormatter (CO)

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSDateFormatter alloc] init];
    });
    return instance;
}

@end
