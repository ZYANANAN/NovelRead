//
//  TJJRefreshGifHeader.h
//  TJJRefreshExample
//
//  Created by MJ Lee on 15/4/24.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "TJJRefreshStateHeader.h"

@interface TJJRefreshGifHeader : TJJRefreshStateHeader
/** 设置state状态下的动画图片images 动画持续时间duration*/
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(TJJRefreshState)state;
- (void)setImages:(NSArray *)images forState:(TJJRefreshState)state;
@end
