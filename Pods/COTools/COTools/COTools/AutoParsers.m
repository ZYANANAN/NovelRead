//
//  AutoParsers.m
//  WitWenZhou
//
//  Created by carlos on 13-3-26.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//


#import "AutoParsers.h"
#import "BaseDomain.h"
@implementation AutoParsers
+(NSArray *)parserData:(NSString *)jsonContent withClass:(Class)mClass withKey:(NSString *)key
{
    NSError *error = nil;
    if (!jsonContent) {
        return nil;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonContent dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed \r\n");
        return nil;
    }
    
    NSArray *arr = [json objectForKey:key];
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *eachItem in arr) {
        //        DLog(@"%@",eachItem);
        BaseDomain *domain = [[mClass alloc]initWithJson:eachItem];
        [result addObject:domain];
    } 
    
    return result;
}

//根据json字符串解析成对象
+(id)parser:(NSString *)jsonContent withClass:(Class)mClass withKey:(NSString *)key{
    
    NSError *error = nil;
    if (!jsonContent) {
        return nil;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonContent dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed \r\n");
        return nil;
    }

    if (key) {
        json = [json objectForKey:key];
    }
    BaseDomain *domain = [[mClass alloc]initWithJson:json];
    return domain;
}

//根据json字符串解析成对象集合
+(id)parserArray:(NSString *)jsonContent withClass:(Class)mClass withKey:(NSString *)key{
    
    NSError *error = nil;
    if (!jsonContent) {
        return nil;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonContent dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed \r\n");
        return nil;
    }
    
    NSMutableArray *domainArray = [NSMutableArray array];
    if (key) {
        NSArray *objArray = [json objectForKey:key];
        for(int i=0;i<objArray.count;i++){
            NSDictionary *objDictionary = [NSDictionary dictionaryWithDictionary:[objArray objectAtIndex:i]];
            BaseDomain *domain = [[mClass alloc]initWithJson:objDictionary];
            [domainArray addObject:domain];
        }
    }
    return domainArray;
}

+ (id)parserToDictionaryWithKey:(NSString *)key content:(NSString *)jsonContent
{
    NSError *error = nil;
    if (!jsonContent) {
        return nil;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonContent dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (json == nil) {
        NSLog(@"json parse failed \r\n");
        return nil;
    }
    if ([json allKeys].count) {
        return [json valueForKey:key];
    }
    return nil;
}
@end
