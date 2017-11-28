//
//  NSDictionary+CO.m
//  KingReader
//
//  Created by wangbc on 15/2/25.
//  Copyright (c) 2015年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "NSDictionary+CO.h"

@implementation NSDictionary (CO)
- (NSString *)customDescription {
    return [NSString stringWithFormat:@"%@",[self description]];
}
@end
