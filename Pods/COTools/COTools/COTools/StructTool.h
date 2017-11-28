//
//  StructTool.h
//  KingReader
//
//  Created by     on 15/11/25.
//  Copyright © 2015年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#ifndef StructTool_h
#define StructTool_h

#define NSRangeZero NSMakeRange(0, 0)

NSRange NSRangeIntersection(NSRange range0, NSRange range1);
NSRange NSRangeUnion(NSRange range0, NSRange range1);
bool NSRangeContainIndex(NSRange range, NSInteger index);
bool NSRangeEqualToRange(NSRange range0, NSRange range1);

#endif /* StructTool_h */
