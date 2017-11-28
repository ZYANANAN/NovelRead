//
//  NSMutableDictionary+ShareParams.m
//  ThirdLoginSDKCreater
//
//  Created by wangbc on 16/8/22.
//  Copyright © 2016年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "NSMutableDictionary+ShareParams.h"

@implementation NSMutableDictionary (ShareParams)

- (void)SSDKSetupShareParamsByText:(NSString *)text
                            image:(id)image
                               url:(NSURL *)url
                             title:(NSString *)title
                              type:(SSDKContentType)type {
    //标题：title，内容：content，链接url：url，图片：image
    [self setValue:text forKey:@"content"];
    if ([image isKindOfClass:[NSString class]]) {
        image = [NSURL URLWithString:image];
    }
    [self setValue:image forKey:@"image"];
    [self setValue:url forKey:@"url"];
    [self setValue:title forKey:@"title"];
    [self setValue:@(type) forKey:@"type"];
    
}

@end
