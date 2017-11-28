//
//  NSString+TJJ.m
//  ThirdLibraries
//
//  Created by     on 16/1/3.
//  Copyright © 2016年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "NSString+TJJ.h"

@implementation NSString (TJJ)

+ (CGFloat)heightForLinesWithFont:(UIFont *)font countOfLines:(NSInteger)countOfLines {
    if (countOfLines < 1) {
        return 0;
    }
    NSMutableString *testString = [NSMutableString string];
    for (NSInteger i = 0; i < countOfLines - 1; i++) {
        [testString appendString:@"“测试”？！。test\n"];
    }
    [testString appendString:@"测试”？！。test"];
    CGRect rect = [testString boundingRectWithSize:CGSizeMake(1000.0f, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil];
    return rect.size.height - rect.origin.y + 1.0f;
}

+ (CGFloat)heightForLinesWithFontSize:(CGFloat)fontSize countOfLines:(NSInteger)countOfLines {
    return [self heightForLinesWithFont:[UIFont systemFontOfSize:fontSize] countOfLines:countOfLines];
}

@end
