//
//  BaseDomain.m
//  MyFamework
//
//  Created by carlos on 13-4-3.
//  Copyright (c) 2013年 carlos. All rights reserved.
//

#import "BaseDomain.h"
#import "COUtils.h"

@implementation BaseDomain

-(id)initWithJson:(NSDictionary *)json{
    self = [super init];
    if (!self) {
        return self;
    }
    
    [COCommTool fillObject:self withJSONDict:json];
    
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
