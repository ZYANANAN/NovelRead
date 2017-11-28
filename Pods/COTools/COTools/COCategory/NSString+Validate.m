//
//  NSString+Validate.m
//  KingReader
//
//  Created by lin wu on 5/28/15.
//  Copyright (c) 2015 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "NSString+Validate.h"

@implementation NSString (Validate)

- (BOOL)validateName {
    NSString *userNameRegex = @"^[A-Za-z_][A-Za-z0-9_]{5,17}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    if ([userNamePredicate evaluateWithObject:self]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)validatePassword {
    NSString *passWordRegex = @"[a-zA-Z0-9`~!@#\\$%\\^&\\*()_\\+-=\\{\\}\\|:\"<>?\\[\\]\\\\;',./']{6,18}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if ([passWordPredicate evaluateWithObject:self]){
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:self]) {
        return YES;
    }else {
        return NO;
    }
}

@end
