//
//  SecurityUtils.m
//  WifiPlus_iOS
//
//  Created by carlos on 13-11-26.
//  Copyright (c) 2013年 carlosk. All rights reserved.
//

#import "SecurityUtils.h"


@implementation SecurityUtils
//加密
+ (NSString *)encode:(NSString *)content{
    const char *contentChar = [content UTF8String];
    char *enCodecontentChar =encodeC(contentChar);
    NSString * encodeContent = [NSString stringWithUTF8String:enCodecontentChar];
    free(enCodecontentChar);
    return encodeContent;
}

//解密
+ (NSString *)decode:(NSString *)content{
    if (nil == content) {
        return @"";
    }
    const char *enCodecontentChar = [content UTF8String];
    char *deCodecontentChar =decodeC(enCodecontentChar);
    NSString * decodeContent = [NSString stringWithUTF8String:deCodecontentChar];
    free(deCodecontentChar);
    return decodeContent;
}

#pragma mark - 新加密算法
//加密
+ (NSString *)httpEncode3:(NSString *)content
{
    const char *contentChar = [content UTF8String];
    char *enCodecontentChar = httpEncode3C(contentChar);
    //NSString * encodeContent = [NSString stringWithUTF8String:enCodecontentChar];
    NSString * encodeContent = [[NSString alloc] initWithBytes:enCodecontentChar length:strlen(enCodecontentChar) encoding:NSUTF8StringEncoding];
    free(enCodecontentChar);
    return encodeContent;
}

//解密
+ (NSString *)httpDecode3:(NSString *)content
{
    if (!content.length) {
        return @"";
    }
    const char *enCodecontentChar = [content UTF8String];
    char *deCodecontentChar = httpDecode3C(enCodecontentChar);
    //NSString * decodeContent = [NSString stringWithUTF8String:deCodecontentChar];
    NSString * decodeContent = [[NSString alloc] initWithBytes:deCodecontentChar length:strlen(deCodecontentChar) encoding:NSUTF8StringEncoding];
    free(deCodecontentChar);
    return decodeContent;
}

#include <stdio.h>
const char base1[] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

#pragma mark - C public method
//加密
char *encodeC(const char *content){
    int i = 0;
	int j = strlen(content);
    
	//先做byte的转换
	char *tempContent = (char *) malloc(j + 1);
	for (i = 0; i < j; i++) {
		tempContent[i] = content[j - i - 1];
	}
	tempContent[j]='\0';
	//把传入的值转换成字符串
    
	char *enc = base64_encode(tempContent, j);
	free(tempContent);
    
	int lenght = strlen(enc);
	//加入偶数的char
	char *results = (char*) malloc(lenght * 2 + 1); //申请一块内存         //+"\0"
	for (i = 0; i < lenght * 2; i++) {
		if (i % 2 == 0) {
			results[i] = enc[i / 2];
		} else {
			results[i] = base1[rand() % strlen(base1)];
		}
	}
	free(enc);
    
	results[lenght*2]='\0';
    return results;
}
//解密
char *decodeC(const char *content){
    int len = strlen(content);
    
	//去掉偶数的char
	char *results = (char*) malloc(len / 2 + 1); //申请一块内存         //+"\0"
    
	for (int i = 0; i < len; i++) {
		if (i % 2 == 0) {
			results[(i / 2)] = content[i];
		}
	}
	results[len/2] = '\0';
    
	char *dec = base64_decode(results, strlen(results));
	free(results);
    
	int j = strlen(dec);
	char * rtn = (char *) malloc(j + 1);
	int i = 0;
	for (i = 0; i < j; i++) {
		rtn[i] = dec[j - i - 1];
	}
	free(dec);
    
	rtn[j]='\0';
    return rtn;
}

//加密
char *httpEncode3C(const char *content){
    int i = 0;
    int j = 0;
    int index1 = 0;
    int index2 = 0;
    const char *base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    char *baseChar = (char *) malloc(11 + 1);
    for (i = 0; i < 11; i++) {
        baseChar[i] = base64EncodeChars[arc4random() % 65];
    }
    baseChar[11] = '\0';
    //1先做翻转
	int strLength = strlen(content);
	char *revertedContent = (char *) malloc(strLength + 1);
	for (i = 0; i < strLength; i++) {
		revertedContent[i] = content[strLength - i - 1];
	}
	revertedContent[strLength]='\0';
    //2base64转换
    char *base64Content = base64_encode(revertedContent, strLength);
    free(revertedContent);
    //3原来字符序号和新字符序号 相加 除65取余  为 新字符
    char *changedContent = (char *)malloc(strlen(base64Content) + 1);
    for (i = 0; i < strlen(base64Content); i++) {
        j = i % 11;
        index1 = index(base64EncodeChars, base64Content[i]) - base64EncodeChars;
        index2 = index(base64EncodeChars, baseChar[j]) - base64EncodeChars;
        changedContent[i] = base64EncodeChars[(index1 + index2) % 65];
    }
    changedContent[strlen(base64Content)] = '\0';
    free(base64Content);
    //4生成11位随机串加到2-13位
    strLength = strlen(changedContent) + 11 + 1;
    char *result = (char *)malloc(strLength);
    for (i = 0; i < strLength - 1; i++) {
        if (i < 2) {
            result[i] = changedContent[i];
        } else if (i >= 2 && i < 13) {
            result[i] = baseChar[i - 2];
        } else {
            result[i] = changedContent[i - 11];
        }
    }
    result[strLength - 1] = '\0';
    free(changedContent);
    free(baseChar);
    return result;
}
//解密
char *httpDecode3C(const char *content){
    const char *base64EncodeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    char *baseChar = (char *) malloc(11 + 1);
    int i = 0;
    int j = 0;
    int length = 0;
    int index1 = 0;
    int index2 = 0;
    //1去掉2-12位的值
    length = strlen(content) - 11;
    char *removed2_14 = (char *)malloc(length + 1);
    int contentStrLength = strlen(content);
    for (i = 0; i < contentStrLength; i++) {
        if (i < 2) {
            removed2_14[i] = content[i];
        } else if (i >=2 && i <=12) {
            baseChar[i - 2] = content[i];
        } else {
            removed2_14[i - 11] = content[i];
        }
    }
    removed2_14[length] = '\0';
    baseChar[11] = '\0';
    //2打乱
    length = strlen(removed2_14);
    char *changedStr = (char *)malloc(length + 1);
    int removed2_14strLength = strlen(removed2_14);
    for (i = 0; i < removed2_14strLength; i++) {
        j = i % 11;
        index1 = index(base64EncodeChars, removed2_14[i]) - base64EncodeChars;
        index2 = index(base64EncodeChars, baseChar[j]) - base64EncodeChars;
        changedStr[i] = base64EncodeChars[(index1 - index2 + 65) % 65];
    }
    changedStr[length] = '\0';
    free(removed2_14);
    //3base64
    char *base64Str = base64_decode(changedStr,strlen(changedStr));
    free(changedStr);
    //4反转
    length = strlen(base64Str);
    char *result = (char *)malloc(length + 1);
    for (i = 0; i < length; i++) {
        result[i] = base64Str[length - i - 1];
    }
    result[length] = '\0';
    free(base64Str);
    free(baseChar);
    return result;
}


#pragma mark - c private method
char *base64_encode(const char* data, int data_len) {
	//int data_len = strlen(data);
	int prepare = 0;
	int ret_len;
	int temp = 0;
	char *ret = NULL;
	char *f = NULL;
	int tmp = 0;
	char changed[4];
	int i = 0;
	ret_len = data_len / 3;
	temp = data_len % 3;
	if (temp > 0) {
		ret_len += 1;
	}
	ret_len = ret_len * 4 + 1;
	ret = (char *) malloc(ret_len);
    
	if (ret == NULL) {
		printf("No enough memory.\n");
	}
	memset(ret, 0, ret_len);
	f = ret;
	while (tmp < data_len) {
		temp = 0;
		prepare = 0;
		memset(changed, '\0', 4);
		while (temp < 3) {
			//printf("tmp = %d\n", tmp);
			if (tmp >= data_len) {
				break;
			}
			prepare = ((prepare << 8) | (data[tmp] & 0xFF));
			tmp++;
			temp++;
		}
		prepare = (prepare << ((3 - temp) * 8));
		//printf("before for : temp = %d, prepare = %d\n", temp, prepare);
		for (i = 0; i < 4; i++) {
			if (temp < i) {
				changed[i] = 0x40;
			} else {
				changed[i] = (prepare >> ((3 - i) * 6)) & 0x3F;
			}
			*f = base1[changed[i]];
			//printf("%.2X", changed[i]);
			f++;
		}
	}
	*f = '\0';
    
	return ret;
    
}
/* */
static char find_pos(char ch) {
	char *ptr = (char*) strrchr(base1, ch); //the last position (the only) in base[]
	return (ptr - base1);
}
/* */
char *base64_decode(const char *data, int data_len) {
	int ret_len = (data_len / 4) * 3;
	int equal_count = 0;
	char *ret = NULL;
	char *f = NULL;
	int tmp = 0;
	int temp = 0;
	char need[3];
	int prepare = 0;
	int i = 0;
	if (*(data + data_len - 1) == '=') {
		equal_count += 1;
	}
	if (*(data + data_len - 2) == '=') {
		equal_count += 1;
	}
	if (*(data + data_len - 3) == '=') {	//seems impossible
		equal_count += 1;
	}
	switch (equal_count) {
        case 0:
            ret_len += 4;	//3 + 1 [1 for NULL]
            break;
        case 1:
            ret_len += 4;	//Ceil((6*3)/8)+1
            break;
        case 2:
            ret_len += 3;	//Ceil((6*2)/8)+1
            break;
        case 3:
            ret_len += 2;	//Ceil((6*1)/8)+1
            break;
	}
	ret = (char *) malloc(ret_len);
	if (ret == NULL) {
		printf("No enough memory.\n");
	}
	memset(ret, 0, ret_len);
	f = ret;
	while (tmp < (data_len - equal_count)) {
		temp = 0;
		prepare = 0;
		memset(need, 0, 4);
		while (temp < 4) {
			if (tmp >= (data_len - equal_count)) {
				break;
			}
			prepare = (prepare << 6) | (find_pos(data[tmp]));
			temp++;
			tmp++;
		}
		prepare = prepare << ((4 - temp) * 6);
		for (i = 0; i < 3; i++) {
			if (i == temp) {
				break;
			}
			*f = (char) ((prepare >> ((2 - i) * 8)) & 0xFF);
			f++;
		}
	}
	*f = '\0';
	return ret;
}

@end
