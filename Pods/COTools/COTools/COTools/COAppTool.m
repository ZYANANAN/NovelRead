//
//  COAppTool.m
//  COTools
//
//  Created by carlos on 13-9-20.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "COAppTool.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#include <netdb.h>

@implementation COAppTool
//获取应用名
+(NSString *)appName
{
    NSBundle*bundle =[NSBundle mainBundle];
    NSDictionary*info =[bundle infoDictionary];
    NSString*prodName =[info objectForKey:@"CFBundleDisplayName"];
    return prodName;
}
//获取版本号
+(NSString *)appVersionName
{
    NSBundle*bundle =[NSBundle mainBundle];
    NSDictionary*info =[bundle infoDictionary];
    //    CLog(@"info = %@",info);
    NSString*prodName =[info objectForKey:@"CFBundleShortVersionString"];
    return prodName;
}
//评论url
+ (NSString *)commonUrl:(NSString *)appId{
    return [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appId];
}
//appurl
+ (NSString *)appUrl:(NSString *)appId{

    return [NSString stringWithFormat:@"https://itunes.apple.com/us/app/zhang-shang-wen-zhou/id%@?ls=1&mt=8",appId];
}

static const char * __jb_app = NULL;

+ (NSString *) localIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    
    if (success == 0)
    {
        temp_addr = interfaces;
        
        while(temp_addr != NULL)
        {
            // check if interface is en0 which is the wifi connection on the iPhone
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return address;
}

@end
