//
//  M2DeviceHelper.m
//  ComicsIsland
//
//  Created by Chen Meisong on 13-7-18.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import "M2DeviceHelper.h"
//界面的宽
#define kFBaseWidth [[UIScreen mainScreen]bounds].size.width
#define kFBaseSize [[UIScreen mainScreen]bounds].size
//界面的高
#define kFBaseHeight [[UIScreen mainScreen]bounds].size.height


@implementation M2DeviceHelper

+ (NSString*)getFreeDiskSpaceReturnWithM
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    unsigned long long size = [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    NSString *sizeString = nil;
    ////NSLog(@"SIZE = %d", size);
    if (size < 1024) {
        sizeString = [NSString stringWithFormat:@"%lluB", size];
    }else if (size < 1024 * 1024){
        sizeString = [NSString stringWithFormat:@"%.1fK", size / 1024.0];
    }else {
        sizeString = [NSString stringWithFormat:@"%.1fM", size / 1024.0 / 1024.0];
    }
    return sizeString;
}

+ (NSString*)getFreeDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    unsigned long long size = [[fattributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
    NSString *string = [self sizeString:size];
    
	return string;
}

+ (NSString*)sizeString:(unsigned long long)size{
    NSString *sizeString = nil;
    if (size < 1024) {
        sizeString = [NSString stringWithFormat:@"%lluB", size];
    }else if (size < 1024 * 1024){
        sizeString = [NSString stringWithFormat:@"%.1fK", size / 1024.0];
    }else if (size < 1024 * 1024 * 1024){
        sizeString = [NSString stringWithFormat:@"%.1fM", size / 1024.0 / 1024.0];
    }else{
        sizeString = [NSString stringWithFormat:@"%.1fG", size / 1024.0 / 1024.0 / 1024.0];
    }
    
    return sizeString;
}

//判断设备信息
+ (BOOL)isIphone4Screen {
    return (kFBaseHeight == 480);
}
+ (BOOL)isIphone5Screen {
    return (kFBaseHeight == 568);
}
+ (BOOL)isIphone6Screen {
    return (kFBaseHeight == 667);
}
+ (BOOL)isIphone6PlusScreen {
    return (kFBaseHeight == 736);
}
+ (BOOL)isIphoneSeries {
    NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
    if ([device isEqualToString:@"iPho"] || [device isEqualToString:@"iPod"]){
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isIpadSeries {
    NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
    if ([device isEqualToString:@"iPad"]){
        return YES;
    } else {
        return NO;
    }
}

//判断手机型号返回指定的字体大小
+ (CGFloat)standardFontSystemSize{
    NSString *device = [[UIDevice currentDevice].model substringToIndex:4];
    if (kFBaseHeight == 480) {
        return 12;
    }else if(kFBaseHeight == 568){
        return 12;
    }else if(kFBaseHeight == 667){
        return 13;
    }else if(kFBaseHeight == 736){
        return 14;
    }else if([device isEqualToString:@"iPad"]){
        return 16;
    }else
    {
        return 12;
    }
}
@end
