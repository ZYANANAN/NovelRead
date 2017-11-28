//
//  UUIDHandler.h
//  WifiPlus
//
//  Created by carlos on 13-8-12.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UUIDHandler : NSObject
//获取uuid
+(NSString *)uuid;

+(NSString *)macaddress;
+(NSString *)idfa;
+(NSString *)idfv;
+(NSString *)openUdid;

+(NSString *)uniqueIdfa;

+(void)clearKeyChain;

@end
