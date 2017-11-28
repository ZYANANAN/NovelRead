//
//  ViewUtils.m
//  WitWenZhou
//
//  Created by carlos on 13-3-22.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//
#define kToastViewTag 6783
#define kPopupViewTag 920720
#define kPushedPopupViewTag 920721

//界面的宽
#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseSize [[UIScreen mainScreen]bounds].size
//界面的高
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height

#define IOS8_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#import "ViewUtils.h"
#import "UIView+CO.h"
#import "NSObject+CO.h"
#import "UIView+Constraint.h"
#import "SVProgressHUD.h"
#import "UIColor+CO.h"

@interface ViewUtils () <UIActionSheetDelegate, UIAlertViewDelegate, UIPopoverPresentationControllerDelegate>

@property (copy, nonatomic) void(^actionSheetBlock)(int index);
@property (assign, nonatomic) NSNumber *actionSheetShowing;

@property (copy, nonatomic) void (^alertBlock)(int index);
@property (copy, nonatomic) void(^alertBlockWithMsg)(NSString *msg);
@property (assign, nonatomic) NSNumber *alertShowing;

@end

@implementation ViewUtils

+ (instancetype)sharedInstance {
    static id instance = nil;
    if (!instance) {
        instance = [[ViewUtils alloc] init];
        if (!IOS8_OR_LATER) {
            [[UIView appearanceWhenContainedIn:[UIActionSheet class], nil] setTintColor:[UIColor colorWithRGBHex:0x6c6c6c]];
        }
    }
    return instance;
}

//显示吐司
+ (void)showToast:(NSString *)toast {
    if (!toast.length) {
        return;
    }
    UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
    for (UIView *theView in currentWindow.subviews) {
        if (theView.tag == kToastViewTag && [theView isKindOfClass:[UILabel class]]) {
            [theView removeFromSuperview];
        }
    }
    UILabel *toastL = [[UILabel alloc] init];
    toastL.tag = kToastViewTag;
    toastL.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.65];
    toastL.textColor = [UIColor whiteColor];
    toastL.text = toast;
    toastL.layer.cornerRadius = 10.0f;
    toastL.clipsToBounds = YES;
    toastL.textAlignment = NSTextAlignmentCenter;
    toastL.font = [UIFont systemFontOfSize:15.0f];
    [toastL sizeToFit];
    
    CGSize toastSize = [ViewUtils sizeOfTitle:toastL.text];
    if (toastSize.width > kFBaseWidth) {
        toastSize.width = kFBaseWidth - 20;
        toastSize.height = toastSize.height * 2 + 18;
        toastL.size = toastSize;
        toastL.numberOfLines = 2;
        toastL.lineBreakMode = NSLineBreakByTruncatingHead;
    } else {
        toastL.height = toastL.height + 18.0f;
        toastL.width = toastL.width + 20;
    }
    
    toastL.x = (kFBaseWidth - toastL.width) / 2;
    toastL.y = kFBaseHeight * 4 / 6;
    toastL.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [currentWindow addSubview:toastL];
    [UIView animateWithDuration:0.1 animations:^{
        toastL.transform = CGAffineTransformIdentity;
    }];
    [currentWindow bringSubviewToFront:toastL];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastL removeFromSuperview];
    });
}

+ (CGSize)sizeOfTitle:(NSString *)title {
    UIFont *titleFont = [UIFont systemFontOfSize:18.0f];
    NSDictionary *attributes = @{NSFontAttributeName : titleFont};
    CGSize sizeOfTitle = [title sizeWithAttributes:attributes];
    sizeOfTitle = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    return sizeOfTitle;
}

+ (void)showPrompt:(NSString *)prompt {
    UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
    for (UIView *theView in currentWindow.subviews) {
        if (theView.tag == kToastViewTag && [theView isKindOfClass:[UILabel class]]) {
            [theView removeFromSuperview];
        }
    }
    UILabel *toastL = [[UILabel alloc] init];
    toastL.tag = kToastViewTag;
    toastL.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.65];
    toastL.textColor = [UIColor whiteColor];
    toastL.text = [NSString stringWithFormat:@"   %@   ",prompt];
    toastL.layer.cornerRadius = 10.0f;
    toastL.clipsToBounds = YES;
    toastL.font = [UIFont systemFontOfSize:15.0f];
    [toastL sizeToFit];
    toastL.height = toastL.height + 18.0f;
    toastL.x = (kFBaseWidth - toastL.width) / 2;
    toastL.y = kFBaseHeight * 1 / 3;
    toastL.transform = CGAffineTransformMakeScale(0.95, 0.95);
    [currentWindow addSubview:toastL];
    [UIView animateWithDuration:0.1 animations:^{
        toastL.transform = CGAffineTransformIdentity;
    }];
    [currentWindow bringSubviewToFront:toastL];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [toastL removeFromSuperview];
    });
}

+ (void)showProgressViewWithDelay:(NSTimeInterval)delay{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    [SVProgressHUD dismissWithDelay:delay];
}

+ (void)showProgressView {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
}

+ (void)showProgressViewWithText:(NSString *)text {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:text];
}

+ (void)hideProgressView {
    [SVProgressHUD dismiss];
}

// 可以响应的圈圈
+ (void)showProgressViewCanRespond {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD show];
}

#pragma mark - action sheet
#pragma mark - UIActionSheetDelegate
+ (void)showActionSheetTitles:(NSArray *)titles inViewController:(UIViewController *)viewController completeBlock:(void(^)(int index))block {
    if (!titles.count) {
        return;
    }
    NSNumber *actionSheetShowing = [[self sharedInstance] valueForKey:@"actionSheetShowing"];
    if (actionSheetShowing.boolValue) {
        return;
    }
    [[self sharedInstance] setValue:@(YES) forKey:@"actionSheetShowing"];
    [[self sharedInstance] setValue:block forKey:@"actionSheetBlock"];
    if (IOS8_OR_LATER) {
        titles = [titles arrayByAddingObject:@"取消"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof([self sharedInstance]) wSelf = [self sharedInstance];
        for (NSInteger index = 0; index < titles.count; index++) {
            NSString *title = titles[index];
            UIAlertActionStyle actionStyle = ((index == titles.count - 1) ? UIAlertActionStyleCancel : UIAlertActionStyleDefault);
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                [wSelf setValue:@(NO) forKey:@"actionSheetShowing"];
                if (block) {
                    block((int)index);
                }
            }];
            [alertController addAction:action];
        }
        UIPopoverPresentationController *popoverPresentationController = alertController.popoverPresentationController;
        popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
        UIView *sourceView = viewController.view;
        // popoverPresentationController.delegate = [self sharedInstance];
        popoverPresentationController.sourceView = sourceView;
        popoverPresentationController.sourceRect = CGRectMake((CGRectGetWidth(sourceView.bounds)-2)*0.5f, (CGRectGetHeight(sourceView.bounds)-2)*0.5f, 2, 2);
        [viewController presentViewController:alertController animated:YES completion:nil];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        sheet.delegate = [self sharedInstance];
        for (NSString *theItem in titles) {
            [sheet addButtonWithTitle:theItem];
        }
        [sheet addButtonWithTitle:@"取消"];
        sheet.cancelButtonIndex = titles.count;
        [sheet showInView:viewController.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.actionSheetBlock) {
        self.actionSheetBlock((int)buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.actionSheetShowing = @(NO);
    self.actionSheetBlock = nil;
}

#pragma mark - alert
#pragma mark - UIAlertViewDelegate
+ (void)showAlertWithOneTextFieldWithMessage:(NSString *)message confirmBlock:(void(^)(NSString *msg))confirmBlock {
    NSNumber *alertShowing = [[self sharedInstance] valueForKey:@"alertShowing"];
    if (alertShowing.boolValue) {
        return;
    }
    [[self sharedInstance] setValue:@(YES) forKey:@"alertShowing"];
    [[self sharedInstance] setValue:confirmBlock forKey:@"alertBlockWithMsg"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:[self sharedInstance] cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

+ (void)showAlertWithMessage:(NSString *)message confirmBtnTitle:(NSString *)confirmBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle alertTitle:(NSString *)title confirmBlock:(void(^)(int index))confirmBlock {
    if (!message.length) {
        return;
    }
    NSNumber *alertShowing = [[self sharedInstance] valueForKey:@"alertShowing"];
    if (alertShowing.boolValue) {
        return;
    }
    [[self sharedInstance] setValue:@(YES) forKey:@"alertShowing"];
    [[self sharedInstance] setValue:confirmBlock forKey:@"alertBlock"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:[self sharedInstance] cancelButtonTitle:cancelBtnTitle otherButtonTitles:confirmBtnTitle, nil];
    [alert show];
}

+ (void)showAlertWithMessage:(NSString *)message confirmBlock:(void(^)(int index))confirmBlock {
    [self showAlertWithMessage:message confirmBtnTitle:@"确定" cancelBtnTitle:@"取消" alertTitle:nil confirmBlock:confirmBlock];
}

+ (void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        if (self.alertBlockWithMsg) {
            UITextField *tf = [alertView textFieldAtIndex:0];
            self.alertBlockWithMsg(tf.text);
        }
    } else if (self.alertBlock) {
        self.alertBlock(buttonIndex);
    }
    self.alertShowing = @(NO);
    self.alertBlock = nil;
    self.alertBlockWithMsg = nil;
}

#pragma mark - popup
+ (BOOL)showPopupWithView:(UIView *)popupView withTimeoutInterval:(NSInteger)timeoutInterval alignment:(TJAlignment)alignment canMaskViewRespond:(BOOL)canMaskViewRespond {
    if (popupView) {
        UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
        for (UIView *subviewOfWindow in currentWindow.subviews) {
            if (subviewOfWindow.tag == kPopupViewTag) {
                return NO;
            }
        }
        UIView *viewAboveWindow = [[UIView alloc] initWithFrame:currentWindow.bounds];
        viewAboveWindow.alpha = 0;
        viewAboveWindow.backgroundColor = [UIColor clearColor];
        viewAboveWindow.tag = kPopupViewTag;
        [currentWindow addSubview:viewAboveWindow];
        
        UIView *maskView = [[UIView alloc] initWithFrame:viewAboveWindow.bounds];
        maskView.alpha = 0.2f;
        maskView.backgroundColor = [UIColor blackColor];
        [viewAboveWindow addSubview:maskView];
        if (canMaskViewRespond) {
            __weak UIView *wPopupView = popupView;
            [maskView addTagEvenBlock:^(UIView *sender) {
                [self hidePopupWithView:wPopupView withAnimation:YES];
            }];
        }
        
        [viewAboveWindow addSubview:popupView];
        TJAlignment horizontalDirection = alignment & 12;
        TJAlignment verticalDirection = alignment & 3;
        switch (horizontalDirection) {
            case TJAlignmentLeft:
                [popupView setConstraintLeading:0];
                break;
            case TJAlignmentRight:
                [popupView setConstraintTrail:0];
                break;
            case TJAlignmentHorizontalCenter: {
                UIView *superView = popupView.superview;
                if (superView) {
                    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:popupView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
                    [superView addConstraint:constraint];
                }
            }
                break;
            default: // 默认：左
                [popupView setConstraintLeading:0];
                break;
        }
        switch (verticalDirection) {
            case TJAlignmentTop:
                [popupView setConstraintTop:0];
                break;
            case TJAlignmentBottom:
                [popupView setConstraintBottom:0];
                break;
            case TJAlignmentVerticalCenter: {
                UIView *superView = popupView.superview;
                if (superView) {
                    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:superView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:popupView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
                    [superView addConstraint:constraint];
                }
            }
                break;
            default: // 默认：上
                [popupView setConstraintTop:0];
                break;
        }

        if (timeoutInterval != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeoutInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self hidePopupWithView:popupView withAnimation:YES];
            });
        }
        [UIView animateWithDuration:.5f animations:^{
            viewAboveWindow.alpha = 1.0f;
        }];
        return YES;
    }
    return NO;
}

+ (void)hidePopupWithView:(UIView *)popupView withAnimation:(BOOL)needsAnimation {
    if (popupView) {
        UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
        NSArray *viewsAboveWindow = [currentWindow subviews];
        [viewsAboveWindow enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if (obj.tag == kPopupViewTag) {
                UIView *viewAboveWindow = obj;
                if ([[viewAboveWindow subviews] lastObject] == popupView) {
                    if (needsAnimation) {
                        [UIView animateWithDuration:.5f animations:^{
                            viewAboveWindow.alpha = 0;
                        } completion:^(BOOL finished) {
                            [viewAboveWindow removeFromSuperview];
                        }];
                    } else {
                        [viewAboveWindow removeFromSuperview];
                    }
                }
            }
        }];
    }
}

/*
 fromDirection:top, bottom, left, right
 toDirection:top, bottom, left, right, center
 */
+ (BOOL)canPushPopupView {
    UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
    for (UIView *subviewOfWindow in currentWindow.subviews) {
        if (subviewOfWindow.tag == kPushedPopupViewTag) {
            return NO;
        }
    }
    return YES;
}

+ (void)pushPopupView:(UIView *)popupView fromDirection:(TJAlignment)fromDirection toDirection:(TJAlignment)toDirection removeToDirection:(TJAlignment)removeToDirection canMaskViewRespond:(BOOL)canMaskViewRespond withAnimation:(BOOL)needsAnimation {
    if (popupView) {
        UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
        for (UIView *subviewOfWindow in currentWindow.subviews) {
            if (subviewOfWindow.tag == kPushedPopupViewTag) {
                return;
            }
        }
        UIView *viewAboveWindow = [[UIView alloc] initWithFrame:currentWindow.bounds];
        viewAboveWindow.backgroundColor = [UIColor clearColor];
        viewAboveWindow.tag = kPushedPopupViewTag;
        [currentWindow addSubview:viewAboveWindow];
        
        UIView *maskView = [[UIView alloc] initWithFrame:viewAboveWindow.bounds];
        maskView.alpha = 0;
        maskView.backgroundColor = [UIColor blackColor];
        [viewAboveWindow addSubview:maskView];
        if (canMaskViewRespond) {
            __weak UIView *wPopupView = popupView;
            __weak typeof(self) wSelf = self;
            [maskView addTagEvenBlock:^(UIView *sender) {
                [wSelf hidePopupWithView:wPopupView toDirection:removeToDirection withAnimation:YES];
            }];
        }
        [viewAboveWindow addSubview:popupView];
        NSLayoutConstraint *constraintBeforeAnimation = nil;
        switch (fromDirection) {
            case TJAlignmentTop: {
                constraintBeforeAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
            }
                break;
            case TJAlignmentLeft: {
                constraintBeforeAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
            }
                break;
            case TJAlignmentBottom: {
                constraintBeforeAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
            }
                break;
            case TJAlignmentRight: {
                constraintBeforeAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
            }
                break;
            default:
                break;
        }
        switch (fromDirection) {
            case TJAlignmentTop:
            case TJAlignmentBottom: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
                [viewAboveWindow addConstraint:constraint];
            }
                break;
            case TJAlignmentLeft:
            case TJAlignmentRight: {
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
                [viewAboveWindow addConstraint:constraint];
            }
                break;
            default:
                break;
        }
        [viewAboveWindow addConstraint:constraintBeforeAnimation];
        [viewAboveWindow layoutIfNeeded];
        [viewAboveWindow removeConstraint:constraintBeforeAnimation];
        switch (toDirection) {
            case TJAlignmentTop:
                [popupView setConstraintTop:0];
                break;
            case TJAlignmentLeft:
                [popupView setConstraintLeading:0];
                break;
            case TJAlignmentBottom:
                [popupView setConstraintBottom:0];
                break;
            case TJAlignmentRight:
                [popupView setConstraintTrail:0];
                break;
            case TJAlignmentCenter:
                [popupView setConstraintCenter];
            default:
                break;
        }
        [UIView animateWithDuration:.25f animations:^{
            maskView.alpha = 0.2f;
            [viewAboveWindow layoutIfNeeded];
        }];
    }
}

/*
 toDirection:top, bottom, left, right
 */
+ (void)hidePopupWithView:(UIView *)popupView toDirection:(TJAlignment)toDirection withAnimation:(BOOL)needsAnimation {
    if (popupView) {
        UIWindow *currentWindow = [(NSObject *)[[UIApplication sharedApplication] delegate] valueForKey:@"window"];
        NSArray *viewsAboveWindow = [currentWindow subviews];
        [viewsAboveWindow enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if (obj.tag == kPushedPopupViewTag) {
                UIView *viewAboveWindow = obj;
                if ([[viewAboveWindow subviews] lastObject] == popupView) {
                    if (needsAnimation) {
                        // remove
                        NSMutableArray *constraintsToRemove = [NSMutableArray array];
                        for (NSLayoutConstraint *constraint in viewAboveWindow.constraints) {
                            if (constraint.firstAttribute != NSLayoutAttributeCenterX && constraint.firstAttribute != NSLayoutAttributeCenterY) {
                                [constraintsToRemove addObject:constraint];
                            }
                        }
                        [viewAboveWindow removeConstraints:constraintsToRemove];
                        NSLayoutConstraint *constraintAfterAnimation = nil;
                        switch (toDirection) {
                            case TJAlignmentTop: {
                                constraintAfterAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
                            }
                                break;
                            case TJAlignmentLeft: {
                                constraintAfterAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
                            }
                                break;
                            case TJAlignmentBottom: {
                                constraintAfterAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
                            }
                                break;
                            case TJAlignmentRight: {
                                constraintAfterAnimation = [NSLayoutConstraint constraintWithItem:popupView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewAboveWindow attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
                            }
                                break;
                            default:
                                break;
                        }
                        NSLayoutAttribute attributeToRemove = NSLayoutAttributeCenterX;
                        if (toDirection == TJAlignmentTop || toDirection == TJAlignmentBottom) {
                            attributeToRemove = NSLayoutAttributeCenterY;
                        }
                        for (NSLayoutConstraint *constraint in viewAboveWindow.constraints) {
                            if (constraint.firstAttribute == attributeToRemove && constraint.secondAttribute == attributeToRemove) {
                                [viewAboveWindow removeConstraint:constraint];
                            }
                        }
                        [viewAboveWindow addConstraint:constraintAfterAnimation];
                        UIView *maskView = [[viewAboveWindow subviews] firstObject];
                        [UIView animateWithDuration:.25f animations:^{
                            maskView.alpha = 0;
                            [viewAboveWindow layoutIfNeeded];
                        } completion:^(BOOL finished) {
                            [viewAboveWindow removeFromSuperview];
                        }];
                    } else {
                        [viewAboveWindow removeFromSuperview];
                    }
                }
            }
        }];
    }
}

@end
