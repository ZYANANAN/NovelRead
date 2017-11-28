//
//  UUIDHandler.m
//  WifiPlus
//
//  Created by carlos on 13-8-12.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "UUIDHandler.h"
//#import "COKeyChainHandler.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "SFHFKeychainUtilsKingReader.h"
@implementation UUIDHandler
#define kUUIDKey @"kUUIDKey"
//获取uuid
+(NSString *)uuid{
    NSString *value = nil;
    value = [self idfa];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        value = [self idfa];
    }else {
        value = [self macaddress];
    }
    return value;
}

+(NSString *)openUdid
{
    return @"openudid";
}

+ (NSString *)idfa {
    char data[20];
    for (int x=0;x<20;data[x++] = (char)('a' + (arc4random_uniform(26))));
    int time = (int)[[NSDate date] timeIntervalSince1970];
    NSString *arcStr = [[NSString alloc] initWithBytes:data length:20 encoding:NSUTF8StringEncoding];
    NSString *idfa = [NSString stringWithFormat:@"yk%@%d",arcStr,time];
    return idfa;
}

+ (NSString *)uniqueIdfa {
    NSString *uniqueIdfa = [SFHFKeychainUtilsKingReader getPasswordForUsername:@"uniqueIdfa" andServiceName:@"KingReader" error:nil];
    if (uniqueIdfa == nil) {
        NSString *idfa = [UUIDHandler idfa];
        [SFHFKeychainUtilsKingReader storeUsername:@"uniqueIdfa" andPassword:idfa forServiceName:@"KingReader" updateExisting:YES error:nil];
        return idfa;
    } else {
        return uniqueIdfa;
    }
}

+(void)clearKeyChain {
    [SFHFKeychainUtilsKingReader deleteItemForUsername:@"uniqueIdfa" andServiceName:@"KingReader" error:nil];
}

+(NSString *)idfv
{
    //CLog(@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]);
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
#pragma mark MAC
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
+ (NSString *)macaddress
{
	int                    mib[6];
	size_t                len;
	char                *buf;
	unsigned char        *ptr;
	struct if_msghdr    *ifm;
	struct sockaddr_dl    *sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) {
		//printf("Error: if_nametoindex error/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
		//printf("Error: sysctl, take 1/n");
		return NULL;
	}
	
	if ((buf = malloc(len)) == NULL) {
		//printf("Could not allocate memory. error!/n");
		return NULL;
	}
	
	if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
		//printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	// NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}

@end
