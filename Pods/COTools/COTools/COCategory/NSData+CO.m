//
//  NSData+CO.m
//  COCategory
//
//  Created by carlos on 13-9-19.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "NSData+CO.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (CO)
//转换成中文GBK编码
- (NSString *) converGBKString{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 );
    NSString *content = [[ NSString alloc ] initWithData :self encoding :gbkEncoding];
    return content;
}
//转换成UTF8的字符串
- (NSString *) converUTF8String{
    NSString* content = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return content;
}

- (NSString *) converUnicodeString {
    NSString* content = [[NSString alloc] initWithData:self encoding:NSUnicodeStringEncoding];
    return content;
}

- (NSString *)converUTF8OrGBKString {
    NSString *resultStr = [self converUTF8String]; 
    if (resultStr.length) {
        return resultStr;
    } else {
        resultStr = [self converGBKString];
        if (resultStr.length) {
            return resultStr;
        }
    } 
    return @"";
}

- (NSString *)converUTF8OrGBKStringOrUnicodeString {
    NSString *resultStr = [self converUTF8OrGBKString]; 
    if (resultStr.length) {
        return resultStr;
    }
    return [self converUnicodeString];
}

- (NSData *)AES256EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256DecryptWithKey:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end