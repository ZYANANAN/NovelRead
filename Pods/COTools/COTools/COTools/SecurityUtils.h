//
//  SecurityUtils.h
//  WifiPlus_iOS
//
//  Created by carlos on 13-11-26.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtils : NSObject
//加密
+ (NSString *)encode:(NSString *)content;

//解密
+ (NSString *)decode:(NSString *)content;

//加密
+ (NSString *)httpEncode3:(NSString *)content;

//解密
+ (NSString *)httpDecode3:(NSString *)content;
@end
