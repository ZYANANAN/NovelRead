//
//  StructTool.m
//  KingReader
//
//  Created by     on 15/11/25.
//  Copyright © 2015年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StructTool.h"

NSRange NSRangeIntersection(NSRange range0, NSRange range1) {
    NSInteger end0 = range0.location + range0.length;
    NSInteger end1 = range1.location + range1.length;
    if (end0 <= range1.location) {
        return NSRangeZero;
    }
    if (end1 <= range0.location) {
        return NSRangeZero;
    }
    NSInteger maxStart = ((range0.location > range1.location) ? range0.location : range1.location);
    NSInteger minEnd = ((end0 < end1) ? end0 : end1);
    return NSMakeRange(maxStart, minEnd - maxStart);
}

NSRange NSRangeUnion(NSRange range0, NSRange range1) {
    if (NSRangeEqualToRange(range0, range1)) {
        return range0;
    }
    NSInteger end0 = range0.location + range0.length;
    NSInteger end1 = range1.location + range1.length;
    if (NSRangeIntersection(range0, range1).length == 0) {
        return NSRangeZero;
    }
    NSInteger start = (range0.location > range1.location ? range1.location : range0.location);
    NSInteger end = (end0 > end1 ? end0 : end1);
    return NSMakeRange(start, end - start);
}

bool NSRangeContainIndex(NSRange range, NSInteger index) {
    if (index < range.location + range.length && index >= range.location) {
        return YES;
    }
    return NO;
}

bool NSRangeEqualToRange(NSRange range0, NSRange range1) {
    if (range0.location != range1.location) {
        return NO;
    }
    if (range0.length != range1.length) {
        return NO;
    }
    return YES;
}