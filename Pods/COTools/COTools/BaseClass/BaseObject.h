//
//  BaseObject.h
//  MyFamework
//
//  Created by carlos on 13-4-3.
//  Copyright (c) 2013年 carlos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseObject : NSObject <NSCoding>

//需要忽略的key
- (NSArray *)ignoredKeys;
- (NSArray *)allPropertyNames;
@end
