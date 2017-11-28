//
//  NSString+Validate.h
//  KingReader
//
//  Created by lin wu on 5/28/15.
//  Copyright (c) 2015 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)

- (BOOL)validateName;
- (BOOL)validatePassword;
- (BOOL)validateEmail;

@end
