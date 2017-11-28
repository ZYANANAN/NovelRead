//
//  NSString+COString.m
//  MyFamework
//
//  Created by carlos on 13-9-7.
//  Copyright (c) 2013年 carlos. All rights reserved.
//

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

#import "NSString+CO.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (CO)

#define JavaNotFound -1

+ (NSString *) base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}

- (BOOL) contains:(NSString*) str {
    NSRange range = [self rangeOfString:str];
    return (range.location != NSNotFound);
}

- (BOOL) startsWith:(NSString*)prefix {
    return [self hasPrefix:prefix];
}

- (BOOL) equals:(NSString*) anotherString {
    return [self isEqual:anotherString];
}

- (BOOL) equalsIgnoreCase:(NSString*) anotherString {
    return [[self toLowerCase] equals:[anotherString toLowerCase]];
}


- (int) lastIndexOfString:(NSString*)str {
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch];
    if (range.location == NSNotFound) {
        return JavaNotFound;
    }
    return range.location;
}

- (int) lastIndexOfString:(NSString*)str fromIndex:(int)index {
    NSRange fromRange = NSMakeRange(0, index);
    NSRange range = [self rangeOfString:str options:NSBackwardsSearch range:fromRange];
    if (range.location == NSNotFound) {
        return JavaNotFound;
    }
    return range.location;
}

- (NSString *) substringFromIndex:(int)beginIndex toIndex:(int)endIndex {
    if (endIndex <= beginIndex) {
        return @"";
    }
    NSRange range = NSMakeRange(beginIndex, endIndex - beginIndex);
    return [self substringWithRange:range];
}

- (NSString *) toLowerCase {
    return [self lowercaseString];
}

- (NSString *) toUpperCase {
    return [self uppercaseString];
}

- (NSString *) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) replaceAll:(NSString*)origin with:(NSString*)replacement {
    return [self stringByReplacingOccurrencesOfString:origin withString:replacement];
}

- (NSArray *) split:(NSString*) separator {
    return [self componentsSeparatedByString:separator];
}
//MD5加密
-(NSString *)md5{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

#pragma mark verify
//校验手机号码
-(BOOL) verifyPhone{
    NSString *result = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(result.length > 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

//校验身份证
- (BOOL) verifyIdentityCard{
    NSString *regexStr = @"\\d{15}|\\d{18}";
    return [self verifyBase:regexStr];
}
//校验email
- (BOOL) verifyEmail{

    return [self verifyBase:@"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"];
}
//基本的校验方法
- (BOOL) verifyBase:(NSString *)regexStr{
    if (!regexStr) {
        return NO;
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                          options:NSRegularExpressionCaseInsensitive    // 还可以加一些选项，例如：不区分大小写
                                                                            error:&error];
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    
    return matches.count>0;

}


//字符串是否为空
+(BOOL)isStringEmpty:(NSString *)string{
    
    return !string || [@"" isEqual:string];
}
//字符串是否不为空
+(BOOL)isStringNotEmpty:(NSString *)string{
    return string && ![@"" isEqual:string];
}

- (BOOL)isNumText {
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}

- (NSString*)encodedURLParameterString {
    NSString *result = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                            (__bridge CFStringRef)self,
                                                                                            NULL,
                                                                                            CFSTR(":/=,!$&'()*+;[]@#?^%\"`<>{}\\|~ "),
                                                                                            kCFStringEncodingUTF8);
    return result;
}

//url编码（不包括+号）
- (NSString*)encodedURLStringWithoutAdd {
    NSString *result = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                            (__bridge CFStringRef)self,
                                                                                            NULL,
                                                                                            CFSTR(":/=,!$&'()*;[]@#?^%\"`<>{}\\|~ "),
                                                                                            kCFStringEncodingUTF8);
    return result;
}

+ (NSString *)stringFromFile:(NSString *)file {
    NSString *content = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (!content.length) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 );
        content = [NSString stringWithContentsOfFile:file encoding:gbkEncoding error:nil];
        if (!content.length) {
            content = [NSString stringWithContentsOfFile:file encoding:NSUnicodeStringEncoding error:nil];
        }
    }
    return content;
}

+ (NSString *)stringFromData:(NSData *)data {
    NSString *content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (!content.length) {
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingGB_18030_2000 );
        content = [[NSString alloc]initWithData:data encoding:gbkEncoding];
    }
    return content;
}

- (BOOL)coContainsString:(NSString *)str {
    if ([self rangeOfString:str].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (NSString *)getRelativePath {
    NSString *relativePath = self;
    NSArray *seperators = @[@"/Documents/", @"/Library/"];
    for (NSString *seperator in seperators) {
        if ([self coContainsString:seperator]) {
            NSRange range = [self rangeOfString:seperator options:NSBackwardsSearch];
            relativePath = [self substringFromIndex:range.location];
        }
    }
    NSString *homeDirectory = NSHomeDirectory();
    NSString *localFilePath = [homeDirectory stringByAppendingPathComponent:relativePath];
    NSString *path = [localFilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return path;
}

@end