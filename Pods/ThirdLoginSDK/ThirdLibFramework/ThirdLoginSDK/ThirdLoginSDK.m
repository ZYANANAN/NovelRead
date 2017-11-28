//
//  ThirdLoginSDK.m
//  ThirdLoginSDKCreater
//
//  Created by wangbc on 16/8/17.
//  Copyright © 2016年 Shanghai Lianyou Network Technology Co., Ltd. All rights reserved.
//

#import "ThirdLoginSDK.h"
#import "ThirdLoginStorage.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "ThirdLoginDelegateHander.h"
#import "NetworkHelper.h"

@implementation ThirdLoginSDK

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wundeclared-selector"

#pragma mark - handle open url
+ (void)handleOpenURL:(NSURL *)url {
    NSString *urlStr = url.absoluteString;
    NSString *weiboStr = [NSString stringWithFormat:@"wb%@",[ThirdLoginStorage sharedStorage].weiboAppId];
    NSString *qqstr = [NSString stringWithFormat:@"tencent%@",[ThirdLoginStorage sharedStorage].QQAppid];
    if ([urlStr rangeOfString:weiboStr].location != NSNotFound) {
        //微博
        [NSClassFromString(@"WeiboSDK") performSelector:@selector(handleOpenURL:delegate:) withObject:url withObject:[ThirdLoginDelegateHander sharedInstance]];
    }
    if ([ThirdLoginStorage sharedStorage].wechatAppid.length && [urlStr hasPrefix:[ThirdLoginStorage sharedStorage].wechatAppid]) {
        //微信
        [NSClassFromString(@"WXApi") performSelector:@selector(handleOpenURL:delegate:) withObject:url withObject:[ThirdLoginDelegateHander sharedInstance]];
    }
    if ([urlStr hasPrefix:qqstr]) {
        //QQ登陆
        if ([urlStr rangeOfString:@"qzapp/mqzone"].location != NSNotFound) {
            [NSClassFromString(@"TencentOAuth") performSelector:@selector(HandleOpenURL:) withObject:url];
        } else if ([urlStr rangeOfString:@"response_from_qq"].location != NSNotFound) {
            //qq分享
            [NSClassFromString(@"QQApiInterface") performSelector:@selector(handleOpenURL:delegate:) withObject:url withObject:[ThirdLoginDelegateHander sharedInstance]];
        }
    }
    NSLog(@"%@",url);
}

#pragma mark - 初始化配置
/**
 *  设置新浪微博应用信息
 *
 *  @param appKey       应用标识
 *  @param appSecret    应用密钥
 *  @param redirectUri  回调地址
 */
+ (void)SSDKSetupSinaWeiboByAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectUri:(NSString *)redirectUri {
    Class weiboSDK = NSClassFromString(@"WeiboSDK");
    if (!weiboSDK) {
        NSLog(@"未集成新浪微博SDK");
    }
    
    [weiboSDK performSelector:@selector(registerApp:) withObject:appKey];
    
    //    [weiboSDK registerApp:appKey];
    [ThirdLoginStorage sharedStorage].weiboAppId = appKey;
    [ThirdLoginStorage sharedStorage].weiboRedirectURI = redirectUri;
}
/**
 *  设置微信(微信好友，微信朋友圈、微信收藏)应用信息
 *
 *  @param appId      应用标识
 *  @param appSecret  应用密钥
 */
+ (void)SSDKSetupWeChatByAppId:(NSString *)appId
                     appSecret:(NSString *)appSecret {
    Class weixinApi = NSClassFromString(@"WXApi");
    if (!weixinApi) {
        NSLog(@"微信SDK尚未集成");
        return;
    }
    [ThirdLoginStorage sharedStorage].wechatAppid = appId;
    [ThirdLoginStorage sharedStorage].wechatAppSecret = appSecret;
    [weixinApi performSelector:@selector(registerApp:) withObject:appId];
}

/**
 *  设置QQ应用信息b
 *
 *  @param appId      应用标识
 *  @param appSecret  应用密钥
 */
+ (void)SSDKSetupQQByAppId:(NSString *)appId
               redirectUri:(NSString *)redirectUri{
    Class qqSDK = NSClassFromString(@"TencentOAuth");
    if (!qqSDK) {
        NSLog(@"qqSDK尚未集成");
        return;
    }
    [ThirdLoginStorage sharedStorage].QQAppid = appId;
    [ThirdLoginStorage sharedStorage].QQAppRedirectURI = redirectUri;
}


#pragma mark - 第三方授权&登陆
/**
 *  平台授权
 *
 *  @param platformType       平台类型
 *  @param @param settings    授权设置,目前只接受SSDKAuthSettingKeyScopes属性设置，如新浪微博关注官方微博：@{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]}，类似“follow_app_official_microblog”这些字段是各个社交平台提供的。
 *  @param stateChangeHandler 授权状态变更回调处理
 */
+ (void)authorize:(SSDKPlatformType)platformType
         settings:(NSDictionary *)settings
   onStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler {
    if (platformType == SSDKPlatformTypeSinaWeibo) {
        //新浪微博
        [self sinaWeiboAuthWithChangedHandler:stateChangedHandler];
    } else if (platformType == SSDKPlatformTypeWechat) {
        [self weixinAuthWithChangedHandler:stateChangedHandler];
    } else if (platformType == SSDKPlatformTypeQQ) {
        [self QQAuthWithChangedHandler:stateChangedHandler];
    }
}

/**
 *  获取授权用户信息
 *
 *  @param platformType       平台类型
 *  @param stateChangeHandler 状态变更回调处理
 */
+ (void)getUserInfo:(SSDKPlatformType)platformType
     onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler {
    if (![[ThirdLoginStorage sharedStorage] isAuthorizeValidate:platformType]) {
        //如果没有授权，先去授权
        [self authorize:platformType settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                [self getUserInfo:platformType onStateChanged:stateChangedHandler];
            } else {
                if (stateChangedHandler) {
                    stateChangedHandler(state,user,error);
                }
            }
        }];
        return;
    }
    
    if (platformType == SSDKPlatformTypeSinaWeibo) {
        [self sinaWeiboGetUserInfoWithChangedHandler:stateChangedHandler];
        
    } else if (platformType == SSDKPlatformTypeWechat) {
        [self weixinGetUserInfoWithChangedHandler:stateChangedHandler];
    } else if (platformType == SSDKPlatformTypeQQ) {
        [self qqGetUserInfoWithChangedHandler:stateChangedHandler];
    }
}
#pragma mark - 取消授权
/**
 *  取消分享平台授权
 *
 *  @param platformType  平台类型
 */
+ (void)cancelAuthorize:(SSDKPlatformType)platformType {
    if (SSDKPlatformTypeSinaWeibo == platformType) {
        [ThirdLoginStorage sharedStorage].weiboUser = nil;
    } else if (SSDKPlatformTypeWechat == platformType) {
        [ThirdLoginStorage sharedStorage].wechatUser = nil;
    } else if (SSDKPlatformTypeQQ == platformType) {
        [ThirdLoginStorage sharedStorage].QQUser = nil;
    }
}

#pragma mark - 分享
/**
 *  分享内容
 *
 *  @param platformType             平台类型
 *  @param parameters               分享参数
 *  @param stateChangeHandler       状态变更回调处理
 */
+ (void)share:(SSDKShareType)shareType
   parameters:(NSMutableDictionary *)parameters
onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler {
    //标题：title，内容：content，链接url：url，图片：image
    //参数检测
    NSString *shareTitle = parameters[@"title"];
    NSString *shareContent = parameters[@"content"];
    NSURL *shareLink = parameters[@"url"];
    id img = parameters[@"image"];
    if ([img isKindOfClass:[NSString class]] && [img hasPrefix:@"http"]) {
        img = [NSURL URLWithString:img];
    }
    SSDKContentType type = [[parameters valueForKey:@"type"] integerValue];
    if (!img || (![img isKindOfClass:[NSURL class]] && ![img isKindOfClass:[UIImage class]])) {
        NSError *error = [NSError errorWithDomain:@"ThirdLoginSDKShareParamError" code:-1 userInfo:@{@"reason":@"image参数不能为空，且只支持UIImage和NSURL类型"}];
        if (stateChangedHandler) {
            stateChangedHandler(SSDKResponseStateFail,nil,error);
        }
        return;
    }
    
    if (shareType == SSDKShareTypeSinaWeibo) {
        [self sinaWeiboShareWithparameters:parameters onStateChanged:stateChangedHandler];
    } else if (shareType == SSDKShareTypeWechatTimeLine || shareType == SSDKShareTypeWechatFriend) {
        [self weixinShareWithType:shareType parameters:parameters onStateChanged:stateChangedHandler];
        
    } else if (shareType == SSDKShareTypeQQFriend || shareType == SSDKShareTypeQZone) {
        SSDKContentType type = [[parameters valueForKey:@"type"] integerValue];
        if (type == SSDKContentTypeImage) {
            [self qqImageShareWithparameters:parameters onStateChanged:stateChangedHandler shareType:shareType];
        } else if (type == SSDKContentTypeWebPage) {
            [self qqLinkShareWithparameters:parameters onStateChanged:stateChangedHandler shareType:shareType];
        }
    }
}

#pragma mark - private QQ
//QQ 授权登录
+ (void)QQAuthWithChangedHandler:(SSDKAuthorizeStateChangedHandler)changeHander {
    Class sendAuthReq = NSClassFromString(@"TencentOAuth");
    if (!sendAuthReq) {
        changeHander(SSDKResponseStateFail,nil,nil);
        return;
    }
    [ThirdLoginStorage sharedStorage].authorieChangeHander = changeHander;
    NSArray *permissions = @[@"get_user_info",
                             @"get_simple_userinfo",
                             @"add_share"];
    
    [self checkQQInit];
    
    [[ThirdLoginStorage sharedStorage].tencentOAuth authorize:permissions];
}

//获取QQ用户信息
+ (void)qqGetUserInfoWithChangedHandler:(SSDKGetUserStateChangedHandler)changeHander {
    [ThirdLoginStorage sharedStorage].authorieChangeHander = changeHander;
    [[ThirdLoginStorage sharedStorage].tencentOAuth getUserInfo];
}

//QQ分享 － 图片
+ (void)qqImageShareWithparameters:(NSMutableDictionary *)parameters
                    onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler
                         shareType:(SSDKShareType)shareType{
    [self checkQQInit];
    
    NSString *shareTitle = parameters[@"title"];
    NSString *shareContent = parameters[@"content"];
    UIImage *shareImage = parameters[@"image"];
    NSData *imageData = [self imageDataWithImage:shareImage fixedLength:5 * 1024 * 1024];
    
    SEL selector = @selector(objectWithData:previewImageData:title:description:);
    id imgObj = ((id (*)(id, SEL, id,id,id,id)) objc_msgSend)(NSClassFromString(@"QQApiImageObject"), selector,imageData,imageData,shareTitle,shareContent);
    id req = ((id (*)(id, SEL, id)) objc_msgSend)(NSClassFromString(@"SendMessageToQQReq"),  @selector(reqWithContent:),imgObj);
    SEL sendSEL = shareType == SSDKShareTypeQQFriend ? @selector(sendReq:) : @selector(SendReqToQZone:);
    ((void(*)(id, SEL,id))objc_msgSend)(NSClassFromString(@"QQApiInterface"), sendSEL,req);
    [ThirdLoginStorage sharedStorage].shareChangeHander = stateChangedHandler;
}

//QQ分享 － 链接
+ (void)qqLinkShareWithparameters:(NSMutableDictionary *)parameters
                   onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler
                        shareType:(SSDKShareType)shareType{
    [self checkQQInit];
    
    NSString *shareTitle = parameters[@"title"];
    NSString *shareContent = parameters[@"content"];
    NSURL *shareLink = parameters[@"url"];
    id shareImage = parameters[@"image"];
    NSData *imageData;
    NSURL *imageURL;
    
    id imgObj;
    if ([shareImage isKindOfClass:[UIImage class]]) {
        imageData = [self imageDataWithImage:shareImage fixedLength:32 * 1024];
        SEL selector = @selector(objectWithURL: title: description: previewImageData:);
        imgObj = ((id (*)(id, SEL, id,id,id,id)) objc_msgSend)(NSClassFromString(@"QQApiNewsObject"), selector,shareLink,shareTitle,shareContent,imageData);
    } else if ([shareImage isKindOfClass:[NSURL class]]) {
        imageURL = shareImage;
        SEL selector = @selector(objectWithURL: title: description: previewImageURL:);
        imgObj = ((id (*)(id, SEL, id,id,id,id)) objc_msgSend)(NSClassFromString(@"QQApiNewsObject"), selector,shareLink,shareTitle,shareContent,imageURL);
    }
    
    id req = ((id (*)(id, SEL, id)) objc_msgSend)(NSClassFromString(@"SendMessageToQQReq"),  @selector(reqWithContent:),imgObj);
    SEL sendSEL = shareType == SSDKShareTypeQQFriend ? @selector(sendReq:) : @selector(SendReqToQZone:);
    ((void(*)(id, SEL,id))objc_msgSend)(NSClassFromString(@"QQApiInterface"), sendSEL,req);
    [ThirdLoginStorage sharedStorage].shareChangeHander = stateChangedHandler;
}

+ (void) checkQQInit {
    if (![ThirdLoginStorage sharedStorage].tencentOAuth) {
        [ThirdLoginStorage sharedStorage].tencentOAuth = [[NSClassFromString(@"TencentOAuth") alloc] initWithAppId:[ThirdLoginStorage sharedStorage].QQAppid
                                                                                                       andDelegate:[ThirdLoginDelegateHander sharedInstance]];
        
    }
}

#pragma mark - private 微信
+ (void)weixinAuthWithChangedHandler:(SSDKAuthorizeStateChangedHandler)changeHander {
    Class sendAuthReq = NSClassFromString(@"SendAuthReq");
    if (!sendAuthReq) {
        changeHander(SSDKResponseStateFail,nil,nil);
        return;
    }
    [ThirdLoginStorage sharedStorage].authorieChangeHander = changeHander;
    id req = [[sendAuthReq alloc] init];
    [req setValue:@"snsapi_userinfo" forKey:@"scope"];
    [NSClassFromString(@"WXApi") performSelector:@selector(sendReq:) withObject:req];
    
}

+ (void)weixinGetUserInfoWithChangedHandler:(SSDKGetUserStateChangedHandler)changeHander {
    SSDKUser *weixinUser = [ThirdLoginStorage sharedStorage].wechatUser;
    NSString *openid = [weixinUser.credential.rawData valueForKey:@"openid"];
    NSString *accessToken = weixinUser.credential.token;
    NSString *urlForUserInfo = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken,openid];
    [NetworkHelper requestWithUrl:urlForUserInfo completeBlock:^(NSDictionary *userInfoJson, NSError *error) {
        NSString *uid = [userInfoJson valueForKey:@"openid"];
        //        {
        //            city = "Pudong New District";
        //            country = CN;
        //            headimgurl = "http://wx.qlogo.cn/mmopen/bSb5dSzPn0KicD3kMibLGCfe3lgLzia5JOZoejibXSvPNhWZZ0AibNI87vO7quNVqJVk0zXf5icydyFsDycxRGeEdUIg/0";
        //            language = "zh_CN";
        //            nickname = "\U738b\U70b3\U806a";
        //            openid = "odE4CuFUI_rwJwfjX16PP-2Ok7o8";
        //            privilege =     (
        //            );
        //            province = Shanghai;
        //            sex = 1;//值为1时是男性，值为2时是女性，值为0时是未知
        //            unionid = "o3AmWjo2AcYuMZqkG0P-i1qfxm2Y";
        //        }
        if (!uid.length) {
            if (changeHander) {
                changeHander(SSDKResponseStateFail,nil,error);
            }
        } else {
            SSDKUser *weixinUser = [ThirdLoginStorage sharedStorage].wechatUser;
            weixinUser.nickname = [userInfoJson valueForKey:@"nickname"];
            weixinUser.icon = [userInfoJson valueForKey:@"headimgurl"];
            if ([[userInfoJson valueForKey:@"sex"] integerValue] == 1) {
                weixinUser.gender = SSDKGenderMale;
            } else if ([[userInfoJson valueForKey:@"sex"] integerValue] == 2) {
                weixinUser.gender = SSDKGenderFemale;
            } else if ([[userInfoJson valueForKey:@"sex"] integerValue] == 0) {
                weixinUser.gender = SSDKGenderUnknown;
            }
        }
        [ThirdLoginStorage sharedStorage].wechatUser = weixinUser;
        if (changeHander) {
            changeHander(SSDKResponseStateSuccess,weixinUser,nil);
        }
        
    }];
}

+ (void)weixinShareWithType:(SSDKShareType)SSDKShareType
                 parameters:(NSMutableDictionary *)parameters
             onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler {
    NSString *shareTitle = parameters[@"title"];
    NSString *shareContent = parameters[@"content"];
    NSURL *shareLink = parameters[@"url"];
    id img = parameters[@"image"];
    UIImage *shareImage;
    if (img && [img isKindOfClass:[UIImage class]]) {
        shareImage = img;
    } else if (img && [img isKindOfClass:[NSURL class]]) {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:(NSURL*)img]];
    }
    SSDKContentType type = [[parameters valueForKey:@"type"] integerValue];
    int scene = 0;
    if (SSDKShareType == SSDKShareTypeWechatTimeLine) {
        scene = 1;
    }
    if (type == SSDKContentTypeWebPage) {
        id media = [[NSClassFromString(@"WXMediaMessage") alloc] init];
        [media setValue:shareTitle forKey:@"title"];
        [media setValue:shareContent forKey:@"description"];
        //图片必须在32k以内
        [media setValue:[self imageDataWithImage:shareImage fixedLength:32 * 1024] forKey:@"thumbData"];
        id webpageObject = [[NSClassFromString(@"WXWebpageObject") alloc] init];
        [webpageObject setValue:shareLink.absoluteString forKey:@"webpageUrl"];
        [media setValue:webpageObject forKey:@"mediaObject"];
        
        id req = [[NSClassFromString(@"SendMessageToWXReq") alloc] init];
        [req setValue:@(scene) forKey:@"scene"];
        [req setValue:@(NO) forKey:@"bText"];
        [req setValue:media forKey:@"message"];
        
        [ThirdLoginStorage sharedStorage].shareChangeHander = stateChangedHandler;
        
        [NSClassFromString(@"WXApi") performSelector:@selector(sendReq:) withObject:req];
    } else if (type == SSDKContentTypeImage) {
        id media = [[NSClassFromString(@"WXMediaMessage") alloc] init];
        [media setValue:shareTitle forKey:@"title"];
        [media setValue:shareContent forKey:@"description"];
        //图片必须在32k以内
        [media setValue:[self imageDataWithImage:shareImage fixedLength:32 * 1024] forKey:@"thumbData"];
        id imageObject = [[NSClassFromString(@"WXImageObject") alloc] init];
        //分享的图片在10M以内
        [imageObject setValue:[self imageDataWithImage:shareImage fixedLength:10 * 1024 * 1024] forKey:@"imageData"];
        [media setValue:imageObject forKey:@"mediaObject"];
        
        id req = [[NSClassFromString(@"SendMessageToWXReq") alloc] init];
        [req setValue:@(scene) forKey:@"scene"];
        [req setValue:@(NO) forKey:@"bText"];
        [req setValue:media forKey:@"message"];
        
        [ThirdLoginStorage sharedStorage].shareChangeHander = stateChangedHandler;
        
        [NSClassFromString(@"WXApi") performSelector:@selector(sendReq:) withObject:req];
    }
}
#pragma mark - private 新浪微博
+ (void)sinaWeiboAuthWithChangedHandler:(SSDKAuthorizeStateChangedHandler)stateChangedHandler {
    Class wbAuthorizeRequestClass = NSClassFromString(@"WBAuthorizeRequest");
    if (!wbAuthorizeRequestClass) {
        NSLog(@"微博SDK未集成！！！");
        return;
    }
    [ThirdLoginStorage sharedStorage].authorieChangeHander = stateChangedHandler;
    //        WBAuthorizeRequest *req = [WBAuthorizeRequest request];
    //微博开放平台第三方应用scope，多个scrope用逗号分隔
    //scope为空，默认没有任何高级权限
    //        req.scope = nil;
    //        [WeiboSDK sendRequest:req];
    id req = [wbAuthorizeRequestClass performSelector:@selector(request)];
    [req performSelector:@selector(setRedirectURI:) withObject:[ThirdLoginStorage sharedStorage].weiboRedirectURI];
    [NSClassFromString(@"WeiboSDK") performSelector:@selector(sendRequest:) withObject:req];
}

+ (void)sinaWeiboGetUserInfoWithChangedHandler:(SSDKGetUserStateChangedHandler)stateChangedHandler {
    //新浪微博获取用户信息
    //        + (WBHttpRequest *)requestForUserProfile:(NSString*)aUserID
    //    withAccessToken:(NSString*)accessToken
    //    andOtherProperties:(NSDictionary*)otherProperties
    //    queue:(NSOperationQueue*)queue
    //    withCompletionHandler:(WBRequestHandler)handler;
    NSString *userid = [ThirdLoginStorage sharedStorage].weiboUser.uid;
    NSString *token = [ThirdLoginStorage sharedStorage].weiboUser.credential.token;
    NSString *uid = [ThirdLoginStorage sharedStorage].weiboUser.uid;
    NSString *url = @"https://api.weibo.com/2/users/show.json";
    NSString *httpMethod = @"GET";
    if (!token.length || !uid.length) {
        return;
    }
    NSDictionary *params = @{@"access_token":token,@"uid":uid};
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    void (^completeBlock)(id request,id result, NSError *error) = ^(id request,id result, NSError *error){
        if ([result isKindOfClass:[NSDictionary class]]) {
            SSDKUser *user = [ThirdLoginStorage sharedStorage].weiboUser;
            user.nickname = [result valueForKey:@"screen_name"];
            user.icon = [result valueForKey:@"profile_image_url"];
            user.rawData = request;
            //m--男，f--女,n未知
            if ([[result valueForKey:@"gender"] isEqualToString:@"m"]) {
                user.gender = SSDKGenderMale;
            } else if ([[result valueForKey:@"gender"] isEqualToString:@"f"]) {
                user.gender = SSDKGenderFemale;
            } else {
                user.gender = SSDKGenderUnknown;
            }
            [ThirdLoginStorage sharedStorage].weiboUser = user;
            if (stateChangedHandler) {
                stateChangedHandler(SSDKResponseStateSuccess,user,nil);
            }
        } else {
            if (stateChangedHandler) {
                stateChangedHandler(SSDKResponseStateFail,nil,error);
            }
        }
    };
    SEL selector = @selector(requestWithAccessToken:url:httpMethod:params:queue:withCompletionHandler:);
    NSMethodSignature *sig = [NSClassFromString(@"WBHttpRequest") methodSignatureForSelector:selector];
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setSelector:selector];
    [invo setTarget:NSClassFromString(@"WBHttpRequest")];
    [invo setArgument:&token atIndex:2];
    [invo setArgument:&url atIndex:3];
    [invo setArgument:&httpMethod atIndex:4];
    [invo setArgument:&params atIndex:5];
    [invo setArgument:&queue atIndex:6];
    [invo setArgument:&completeBlock atIndex:7];
    [invo invoke];
}

+ (void)sinaWeiboShareWithparameters:(NSMutableDictionary *)parameters
                      onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler {
    //    NSString *shareTitle = parameters[@"title"];
    NSString *shareContent = parameters[@"content"];
    //微博分享的内容，必须小于140个字符
    if (shareContent.length >= 140) {
        shareContent = [NSString stringWithFormat:@"%@...",[shareContent substringToIndex:136]];
    }
    if (shareContent.length == 0) {
        shareContent = @" ";
    }
    //    NSURL *shareLink = parameters[@"url"];
    id theShareImage = parameters[@"image"];
    UIImage *shareImage;
    if ([theShareImage isKindOfClass:[UIImage class]]) {
        shareImage = theShareImage;
    } else if ([theShareImage isKindOfClass:[NSURL class]]) {
        shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:theShareImage]];
    }
    //调用微博的分享接口
    id wbImageObject = [[NSClassFromString(@"WBImageObject") alloc] init];
    //图片大小小于5M
    NSData *imageData = [self imageDataWithImage:shareImage fixedLength:1024 * 1024 * 5];
    [wbImageObject setValue:imageData forKey:@"imageData"];
    void (^completeBlock)(id request,id result, NSError *error) = ^(id request,id result, NSError *error){
        if ([result isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            //成功
            if (stateChangedHandler) {
                stateChangedHandler(SSDKResponseStateSuccess,result,nil);
            }
        } else {
            if (stateChangedHandler) {
                stateChangedHandler(SSDKResponseStateFail,nil,error);
            }
        }
    };
    [ThirdLoginStorage sharedStorage].shareChangeHander = stateChangedHandler;
    NSString *accessToken = [ThirdLoginStorage sharedStorage].weiboUser.credential.token;
    
    id messageObject = [NSClassFromString(@"WBMessageObject") performSelector:@selector(message)];
    [messageObject setValue:shareContent forKey:@"text"];
    [messageObject setValue:wbImageObject forKey:@"imageObject"];
    
    id authRequest = [[NSClassFromString(@"WBAuthorizeRequest") alloc] init];
    [authRequest setValue:[ThirdLoginStorage sharedStorage].weiboRedirectURI forKey:@"redirectURI"];
    
    SEL selector = @selector(requestWithMessage:authInfo:access_token:);
    NSMethodSignature *sig = [NSClassFromString(@"WBSendMessageToWeiboRequest") methodSignatureForSelector:selector];
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setSelector:selector];
    [invo setTarget:NSClassFromString(@"WBSendMessageToWeiboRequest")];
    [invo setArgument:&messageObject atIndex:2];
    [invo setArgument:&authRequest atIndex:3];
    [invo setArgument:&accessToken atIndex:4];
    [invo invoke];

    //WBSendMessageToWeiboRequest
    id  __unsafe_unretained request = nil;
    [invo getReturnValue:&request];
    
    [NSClassFromString(@"WeiboSDK") performSelector:@selector(sendRequest:) withObject:request];
    
}

#pragma mark - 工具方法
+ (NSData *)imageDataWithImage:(UIImage *)image fixedLength:(NSInteger)byte {
    CGFloat compressRate = 0.9;
    NSData *imgData = UIImageJPEGRepresentation(image, compressRate);
    while (imgData && imgData.length > byte) {
        compressRate = byte * 1.0 / imgData.length * compressRate;
        imgData = UIImageJPEGRepresentation(image, compressRate);
        if (compressRate < 0.01 && imgData.length > byte) {
            //UIImageJPEGRepresentation有一个最小压缩率，如果在最小压缩率情况下图片依然过大，则需要对图片进行缩放（缩放50%）
            CGSize imgSize = CGSizeMake(image.size.width / 2.0, image.size.height / 2.0);
            if (imgSize.width <= 0) {
                imgSize.width = 1;
            }
            if (imgSize.height <= 0) {
                imgSize.height = 1;
            }
            UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0);
            
            [image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            compressRate = 0.9;
        }
    }
    return imgData;
}

#pragma clang diagnostic pop

@end
