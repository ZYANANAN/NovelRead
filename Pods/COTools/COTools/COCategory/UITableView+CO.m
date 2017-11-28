//
//  UITableView+CO.m
//  COTools
//
//  Created by carlos on 13-9-29.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "UITableView+CO.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "COBaseCell.h"
#import "UIView+CO.h"
@interface UITableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UITableView (CO)

- (void)addEmptyFooterWithHeigth:(CGFloat)height {
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.size = CGSizeMake([[UIScreen mainScreen]bounds].size.width, height);
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableFooterView = tableFooterView;
}
@end
