//
//  COAppTool.h
//  COTools
//
//  Created by carlos on 13-9-20.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "COBaseTool.h"
#define IOS10_OR_LATER    ([[[UIDevice currentDevice] systemVersion] integerValue] >= 10)
#define IOS9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] integerValue] >= 9)
#define IOS8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] integerValue] >= 8)
#define IOS7_OR_LATER	([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)
#define IOS6_OR_LATER	([[[UIDevice currentDevice] systemVersion] integerValue] >= 6)
#define IOS5_OR_LATER	([[[UIDevice currentDevice] systemVersion] integerValue] >= 5)
#define IOS4_OR_LATER	([[[UIDevice currentDevice] systemVersion] integerValue] >= 4)
#define IOS3_OR_LATER	([[[UIDevice currentDevice] systemVersion] integerValue] >= 3)
#define IS_IPHONE                       ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPAD                         ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


@interface COAppTool : COBaseTool
//获取应用名
+ (NSString *)appName;
//获取版本号
+ (NSString *)appVersionName;
//获取系统Version
+ (float )osVersion;
//评论url
+ (NSString *)commonUrl:(NSString *)appId;
//appurl
+ (NSString *)appUrl:(NSString *)appId;

//是否越狱
+ (BOOL)isJailBroken;

+ (NSString *) localIPAddress;
@end