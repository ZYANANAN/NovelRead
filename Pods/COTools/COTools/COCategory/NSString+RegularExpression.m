//
//  NSString+RegularExpression.m
//  RegularExpression
//
//  Created by abraham on 14-2-27.
//  Copyright (c) 2014年 Abraham Wang. All rights reserved.
//

#import "NSString+RegularExpression.h"

@implementation NSString (RegularExpression)

- (NSString*)encodedURLParameterString {
    NSString *result = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                            (__bridge CFStringRef)self,
                                                                                            NULL,
                                                                                            CFSTR(":/=,!$&'()*+;[]@#?^%\"`<>{}\\|~ "),
                                                                                            kCFStringEncodingUTF8);
	return result;
}
- (NSString *)subStringWithRegularExpression:(NSString *)regular
{
    NSRange theRange = [self rangeOfString:regular options:NSRegularExpressionSearch];
    if (theRange.length) {
        return [self substringWithRange:theRange];
    }
    return nil;
}
@end
