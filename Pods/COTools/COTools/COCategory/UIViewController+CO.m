//
//  UIViewController+CO.m
//  WifiPlus_iOS
//
//  Created by abraham on 14-5-19.
//  Copyright (c) 2014年 carlosk. All rights reserved.
//

#import "UIViewController+CO.h"
#import <objc/runtime.h>

@implementation UIViewController (CO)

- (void)setSuperViewNotClipToBounds {
    UIView *theView = self.view;
    while (theView) {
        theView.clipsToBounds = NO;
        theView = theView.superview;
    }
}

@end
