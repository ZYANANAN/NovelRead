//
//  M2DeviceHelper.h
//  ComicsIsland
//
//  Created by Chen Meisong on 13-7-18.
//  Copyright (c) 2013年 appfactory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDevice+CO.h"
@interface M2DeviceHelper : NSObject
+ (NSString*)getFreeDiskSpaceReturnWithM;
+ (NSString*)getFreeDiskSpace;
+ (NSString*)sizeString:(unsigned long long)size;

//判断设备信息
+ (BOOL)isIphone4Screen;
+ (BOOL)isIphone5Screen;
+ (BOOL)isIphone6Screen;
+ (BOOL)isIphone6PlusScreen;
+ (BOOL)isIphoneSeries;
+ (BOOL)isIpadSeries;

//判断设备尺寸返回系统标准字体大小
+ (CGFloat)standardFontSystemSize;
@end
