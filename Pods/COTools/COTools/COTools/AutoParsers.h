//
//  AutoParsers.h
//  WitWenZhou
//
//  Created by carlos on 13-3-26.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//自动解析


#import <Foundation/Foundation.h>
@interface AutoParsers : NSObject
//根据json字符串解析成对象
+(NSArray *)parserData:(NSString *)jsonContent withClass:(Class)mClass withKey:(NSString *)key;

//根据json字符串解析成对象
+(id)parser:(NSString *)jsonContent withClass:(Class)mClass withKey:(NSString *)key;
+(id)parserArray:(NSString *)jsonContent withClass:(Class)mClass withKey:(NSString *)key;
+ (id)parserToDictionaryWithKey:(NSString *)key content:(NSString *)jsonContent;
@end
