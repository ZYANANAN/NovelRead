//
//  ViewUtils.h
//  WitWenZhou
//
//  Created by carlos on 13-3-22.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseObject.h"

typedef enum : NSUInteger {
    TJAlignmentTop = 1, // 1
    TJAlignmentBottom = 1 << 1, // 2
    TJAlignmentVerticalCenter = 3, // 3
    TJAlignmentLeft = 1 << 2, // 4
    TJAlignmentRight = 1 << 3, // 8
    TJAlignmentHorizontalCenter = 12,
    TJAlignmentCenter = 15
} TJAlignment;

@interface ViewUtils : NSObject

//显示吐司
+ (void)showToast:(NSString *)toast;

//在屏幕中上部显示提示
+ (void)showPrompt:(NSString *)prompt;

//progress
+ (void)showProgressView;
+ (void)showProgressViewWithText:(NSString *)text;
+ (void)showProgressViewCanRespond;
+ (void)hideProgressView;
+ (void)showProgressViewWithDelay:(NSTimeInterval)delay;

+ (void)showActionSheetTitles:(NSArray *)titles inViewController:(UIViewController *)viewController completeBlock:(void (^)(int index))block;

+ (void)showAlertWithOneTextFieldWithMessage:(NSString *)message confirmBlock:(void(^)(NSString *msg))confirmBlock;
+ (void)showAlertWithMessage:(NSString *)message confirmBlock:(void (^)(int index))confirmBlock;
+ (void)showAlertWithMessage:(NSString *)message;
+ (void)showAlertWithMessage:(NSString *)message confirmBtnTitle:(NSString *)confirmBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle alertTitle:(NSString *)title confirmBlock:(void (^)(int index))confirmBlock;

+ (BOOL)showPopupWithView:(UIView *)popupView withTimeoutInterval:(NSInteger)timeoutInterval alignment:(TJAlignment)alignment canMaskViewRespond:(BOOL)canMaskViewRespond;
+ (void)hidePopupWithView:(UIView *)popupView withAnimation:(BOOL)needsAnimation;

+ (BOOL)canPushPopupView;
+ (void)pushPopupView:(UIView *)popupView fromDirection:(TJAlignment)fromDirection toDirection:(TJAlignment)toDirection removeToDirection:(TJAlignment)removeToDirection canMaskViewRespond:(BOOL)canMaskViewRespond withAnimation:(BOOL)needsAnimation;
+ (void)hidePopupWithView:(UIView *)popupView toDirection:(TJAlignment)toDirection withAnimation:(BOOL)needsAnimation;

@end
