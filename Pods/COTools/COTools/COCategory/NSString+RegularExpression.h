//
//  NSString+RegularExpression.h
//  RegularExpression
//
//  Created by abraham on 14-2-27.
//  Copyright (c) 2014年 Abraham Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegularExpression)

- (NSString *)subStringWithRegularExpression:(NSString *)regular;
- (NSString*)encodedURLParameterString;
@end
