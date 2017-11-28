//
//  NSString+TJJ.h
//  ThirdLibraries
//
//  Created by     on 16/1/3.
//  Copyright © 2016年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TJJ)

+ (CGFloat)heightForLinesWithFont:(UIFont *)font countOfLines:(NSInteger)countOfLines;
+ (CGFloat)heightForLinesWithFontSize:(CGFloat)fontSize countOfLines:(NSInteger)countOfLines;

@end
