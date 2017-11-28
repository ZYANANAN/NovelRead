//
//  BaseObject.m
//  MyFamework
//
//  Created by carlos on 13-4-3.
//  Copyright (c) 2013年 carlos. All rights reserved.
//

#import "BaseObject.h"
#import <objc/runtime.h>

@implementation BaseObject

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self codeDataWithCoder:aDecoder isEncoding:YES];
    }
    return self;
}

//需要忽略的key
- (NSArray *)ignoredKeys {
    //子类需要重写此方法
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self codeDataWithCoder:aCoder isEncoding:NO];
}

- (void)codeDataWithCoder:(NSCoder *)coder isEncoding:(BOOL)isEncoding
{
    Class cls = [self class];
    do {
        unsigned int numberOfIvars = 0;
        Ivar *ivars = class_copyIvarList(cls, &numberOfIvars);
        NSArray *ignoredKeys = [self ignoredKeys];
        for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++)
        {
            Ivar const ivar = *p;
            const char *ivar_type = ivar_getTypeEncoding(ivar);
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            //忽略不需要保存的property
            if ([ignoredKeys containsObject:key]) {
                continue;
            }
            if (isEncoding) {
                NSObject* value = nil;
                
                //For bool value
                if (strcmp(ivar_type, "c") == 0) {
                    BOOL boolVal = [coder decodeBoolForKey:key];
                    value = [NSNumber numberWithBool:boolVal];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                    //For NSInteger value
                } else if(strcmp(ivar_type, "i") == 0) {
                    NSInteger intVal = [coder decodeIntegerForKey:key];
                    value = [NSNumber numberWithInteger:intVal];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                }
                // d for double
                else if (strcmp(ivar_type, "d") == 0) {
                    value = [coder decodeObjectForKey:key];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                } else if (strcmp(ivar_type, "f") == 0) {
                    // f for float
                    value = [coder decodeObjectForKey:key];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                } else if (strcmp(ivar_type, "q") == 0) {
                    // q for nsinteger
                    value = [coder decodeObjectForKey:key];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                } else if(strcmp(ivar_type, "B") == 0) {
                    BOOL boolVal = [coder decodeBoolForKey:key];
                    value = [NSNumber numberWithBool:boolVal];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                } else if (strcmp(ivar_type, "Q") == 0) {
                    // q for enum
                    value = [coder decodeObjectForKey:key];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                } else if (strcmp(ivar_type, "I") == 0) {
                    // i for enum
                    value = [coder decodeObjectForKey:key];
                    if (!value) {
                        continue;
                    }
                    [self setValue:value forKey:key];
                } else {
                    value = [coder decodeObjectForKey:key];
                    
//                    if(value)
//                    {
//                        NSString* st_property_type = [NSString stringWithCString:ivar_type encoding:NSUTF8StringEncoding];
//                        if( [st_property_type hasPrefix:@"@\""] && [st_property_type hasSuffix:@"\""] && st_property_type.length > 3 )
//                        {
//                            NSRange range = NSMakeRange(2, st_property_type.length - 3);
//                            st_property_type = [st_property_type substringWithRange:range];
//                        }
//                        Class cls_property = NSClassFromString(st_property_type);
//                        Class cls_value = [value class];
//                        
//                        if ( cls_property == cls_value || [cls_property isSubclassOfClass:cls_value] || [cls_value isSubclassOfClass:cls_property] )
//                        {
                            [self setValue:value forKey:key];
//                        }
//                    }
                }
            } else {
                //For bool value
                if (strcmp(ivar_type, "c") == 0) {
                    BOOL boolVal = [(NSNumber*)[self valueForKey:key] boolValue];
                    [coder encodeBool:boolVal forKey:key];
                    //For NSInteger value
                } else if(strcmp(ivar_type, "i") == 0) {
                    NSInteger intVal = [(NSNumber*)[self valueForKey:key] intValue];
                    [coder encodeInteger:intVal forKey:key];
                } else if(strcmp(ivar_type, "B") == 0) {
                    BOOL boolVal = [(NSNumber*)[self valueForKey:key] boolValue];
                    [coder encodeBool:boolVal forKey:key];
                } else {
                    [coder encodeObject:[self valueForKey:key] forKey:key];
                }
            }
        }
        free(ivars);
        cls = [cls superclass];
    } while (cls != [NSObject class]);
}

- (NSArray *)allPropertyNames {
    NSMutableArray *result = [NSMutableArray array];
    
    Class cls = [self class];
    do {
        unsigned int numberOfIvars = 0;
        Ivar *ivars = class_copyIvarList(cls, &numberOfIvars);
        for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++)
        {
            Ivar const ivar = *p;
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if (key.length) {
                [result addObject:key];
            }
        }
        free(ivars);
        cls = [cls superclass];
    } while (cls != [NSObject class]);
        
    return result;
}
@end
