//
//  NSData+CO.h
//  COCategory
//
//  Created by carlos on 13-9-19.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CO)
//转换成中文GBK编码
- (NSString *) converGBKString;
//转换成UTF8的字符串
- (NSString *) converUTF8String;
- (NSString *)converUTF8OrGBKString;
- (NSString *)converUTF8OrGBKStringOrUnicodeString;

//加密解密
- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
@end
