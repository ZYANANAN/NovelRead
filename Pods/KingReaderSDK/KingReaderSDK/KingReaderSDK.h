//
//  KingReaderSDK.h
//  KingReaderSDK
//
//  Created by zhuge on 16/11/14.
//
#pragma mark - ==========  说明  ==========
/*
 开卷有益SDK，即KingReaderSDK为免费使用的开放平台，包含开卷有益最新版本绝大部分功能，充值部分需要商务合作，请联系产品人员：qq：286905729（刘佳雯）  技术支持：qq：2271637488（诸革）。
 请接入方仔细阅读 README 相关说明！
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - ==========  分享类型与状态  ==========
typedef NS_ENUM(NSUInteger, KRSDKResponseState){
    KRSDKResponseState_Begin     = 0,
    KRSDKResponseState_Success,
    KRSDKResponseState_Fail,
    KRSDKResponseState_Cancel
};

typedef NS_ENUM(NSUInteger, KRSDKShareType){
    KRSDKShareType_SinaWeibo = 1,
    KRSDKShareType_WechatTimeLine,
    KRSDKShareType_WechatFriend,
    KRSDKShareType_QQFriend,
    KRSDKShareType_QZone
};

#pragma mark - ==========  SDK内部通知  ==========
//点击书架通知点击的下标index，见demo
static NSString *const KingReaderSDKTabbarClick = @"KingReaderSDKTabbarClick";

//分享相关字符串
static NSString *const KingReaderSDKShareContent = @"KingReaderSDKShareContent";
static NSString *const KingReaderSDKShareState = @"KingReaderSDKShareState";
static NSString *const KingReaderSDKShareState_Current = @"KingReaderSDKShareState_Current";
static NSString *const KingReaderSDKShareType = @"shareType";

//阅读器章节跳转通知
//刚点击
static NSString *const KingReaderSDKStartChangeChapter = @"KingReaderSDK_StartChangeChapter";
//显示章节内容
static NSString *const KingReaderSDKChangeChapterStartLoadNewPage = @"KingReaderSDK_ChangeChapterStartLoadNewPage";

//书架相关通知
//点击书架自定义的书发出通知
static NSString *const KingReaderSDKClickCustomizedBook = @"KingReaderSDK_ClickCustomizedBook";
//自定义广告:展示通知
static NSString *const KingReaderSDKCustomADShow = @"KingReaderSDK_CustomADShow";
//自定义广告:点击通知
static NSString *const KingReaderSDKCustomADClick = @"KingReaderSDK_CustomADClick";


//getBookInfoWithBookid：返回的信息通知
static NSString *const KingReaderSDKBookInfo = @"KingReaderSDKBookInfo";


//========================================================================
//========================================================================
//========================================================================

@interface KingReaderSDK : NSObject

#pragma mark - ==========  Warning && 审核 ==========
/**
 @param identifiers 内购的identifier
 Tips: 该数组来自AppStore内购的id, 内购的配置参照 SDK中 InAppStorePerchase.txt 文件.否则服务器将验证不通过。
 */
+ (void)bringInAppStoreIdentifiers:(NSArray *)identifiers;

/**
 设置是否隐藏用户付费相关字样和说明
 */
+ (void)setHiddenPayEntrance:(BOOL)hidden;


//========================================================================


#pragma mark - ==========  注册登录  ==========
/**
 判断用户是否已经登陆（绑定）
 */
+ (BOOL)isLogined;

/**用唯一标识符创建开卷SDK用户
 * @param unid 创建用户的唯一标识，友方app的用户id或者其他唯一标识符
 * @param channelId 渠道id，友方app唯一标识符，为了区分用户和收入分成，请找产品确认
 * @param block 用户登陆成功或失败的回调
 
 请务必测试此处的unid是否唯一，否则开卷SDK不保证用户的唯一性。详见demo说明！！！
 */
+ (void)loginWithUniqueId:(NSString *)unid channelId:(int)channelId completeBlock:(void (^)(NSString *error, BOOL succeed))block;

/**
 * 获取开卷SDK阅读器根视图,此跟视图只能放到navigation controller中
 */
+ (UIViewController *)rootViewController;


//========================================================================


#pragma mark - ==========  自定义UI  （条件可选设置）==========
/**
 设置navigation bar的背景颜色；如果在开卷SDK返回的时候需要设置回之前的颜色，用：self.navigationController.navigationBar.barTintColor = [UIColor XXXXColor];
 */
+ (void)setNavigationBackgroundColor:(UIColor *)color;

/**
 设置navigation 按钮颜色、navigation title颜色
 */
+ (void)setNavigationForgroundColor:(UIColor *)color;

/**
 设置tabbar背景颜色
 */
+ (void)setTabbarBackgroundColor:(UIColor *)color;

/**
 设置tabbar选中状态颜色
 */
+ (void)setTabbarSelectedColor:(UIColor *)color;

/**
 设置tabbar正常状态颜色
 */
+ (void)setTabbarNormalColor:(UIColor *)color;

/**
 *  是否隐藏返回按钮
 */
+ (void)setHiddenMainInterfaceBackButton:(BOOL)hidden;

//========================================================================

#pragma mark - ==========  添加一个item到tabBar  ==========
/**
 *  新增tabBaritem 限制与描述
 *
 *  @param title     标题
 *  @param imageName 标题对应图片
 *  @param newVC     页面显示的VC实例
 *  @param index     插入item的位置: 目前支持的位置仅有2或3,如果不传或者传入数据非2非3则默认为2
 
 Tips:
 1. 图片命名请遵循以下范例方可以显示完整效果:
 未选中: diamond@2x.png diamond@3x.png
 选中: diamond2@2x.png diamond2@3x.png
 2. 该方法调用位置一定在 [KingReaderSDK rootViewController];之前,否则无效
 3. 调用该方法一定要主动调用设置tabbar正常状态颜色和选中状态颜色等设置，否则tabbar按钮图片颜色会不一致
 */
+ (void)addTabButton:(NSString *)title imageName:(NSString *)imageName viewController:(UIViewController *)newVC atIndex:(NSInteger)index;


/**
 新增tabBaritem （该方法与上面的方法二选一）
 
 @param title 标题
 @param image 未选中图片
 @param selectedImage 选中图标
 @param newVC 页面显示的VC实例
 @param index 插入item的位置: 目前支持的位置仅有2或3,如果不传或者传入数据非2非3则默认为2
 
 Tips:
 1. 调用该方法一定要主动调用设置tabbar正常状态颜色和选中状态颜色等设置，否则tabbar按钮图片颜色会不一致
 */
+ (void)addTabButton:(NSString *)title normalImage:(UIImage *)image selectedImage:(UIImage *)selectedImage viewController:(UIViewController *)newVC atIndex:(NSInteger)index;


#pragma mark - ==========  添加两个item到tabBar  ==========
/**
 *  新增tabBaritems 限制与描述
 *  限制数组元素个数只能为2个！！！如果传入一个请换上面的方法
 *  @param titles     标题
 *  @param imageNames 标题对应图片
 *  @param newVCs     页面显示的VC实例
 请按照顺序传入数组，插入顺序开卷SDK保留前三位，后两个的顺序为数组顺序
 
 Tips:
 1. 调用该方法一定要主动调用设置tabbar正常状态颜色和选中状态颜色等设置，否则tabbar按钮图片颜色会不一致
 */
+ (void)addTabButtons:(NSArray<NSString *> *)titles imageNames:(NSArray<NSString *> *)imageNames viewControllers:(NSArray<UIViewController *> *)newVCs;


/**
 新增tabBaritems 限制与描述 （该方法与上面的方法二选一）
 
 @param titles 标题
 @param images 常态图片数组
 @param selImages 选中图片数组
 @param newVCs 页面显示的VC实例
 
 Tips:
 1. 调用该方法一定要主动调用设置tabbar正常状态颜色和选中状态颜色等设置，否则tabbar按钮图片颜色会不一致
 
 */
+ (void)addTabButtons:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)images selectedImages:(NSArray<UIImage *> *)selImages viewControllers:(NSArray<UIViewController *> *)newVCs;


/**
 *  提供免费频道的VC
 使用方法： 插入到tab作为一级页面
 *
 @param height 展示高度：根据是否有nav 和 tab自行配置
 *  @return 书城中免费书页面
 */
+ (UIViewController *)freeBooksChannelWithViewControllerHeight:(CGFloat)height;


//========================================================================


#pragma mark - ==========  书籍更新推送（小米推送服务）  ==========
/**
 *  开启小米推送服务时,需在
 - (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 中调用该方法
 *
 *  @param token deviceToken
 */
+ (void)bindDeviceTokenForMiPush:(NSData *)token;


/**
 获取当前设备注册的小米推送的id
 
 @return 小米id，便于测试使用
 */
+ (NSString *)miPushRegID;


//========================================================================


#pragma mark - ==========  书架广告  ==========

/**
 开启广点通原生广告
 以书本形式展示的原生的广告，请申请placementId时注意类型
 如果传入参数完整视为使用，如果不使用广告请不要传入参数或调用该方法
 @param appkey 应用id
 @param placementId 广告位id
 */
+ (void)usingGDTNativeAdWithAppKey:(NSString *)appkey placementId:(NSString *)placementId;

/**
 开启cps后台广告并且关闭广点通的广告
 如果调用此方法，将不再展示广点通的广告。
 @param cpsUsing 是否使用cps配置的广告
 */
+ (void)usingKRCustomAdAndCloseGDTAd:(BOOL)cpsUsing;

/**
 是否屏蔽书架签到位置的广告
 传入YES即可屏蔽广告,只展示签到和开卷推荐书籍
 */
+ (void)shieldNativeAds:(BOOL)shield;

#pragma mark - ==========  分享功能配置  ==========

/**
 分享功能使用预配置
 
 @param wxInstall 用户是否安装了微信
 @param qqInstall 用户是否安装了QQ
 
 Tips：该方法为可选方法，如果调用，不论上述参数为何，都将开启分享按钮。分享按钮默认不开启
 */

/*
 注：分享功能先只给出分享的内容字典和回调的state处理。均已通知的形式进行。SDK使用方需要进行如下操作：
 1. 注册接受通知：KingReaderSDKShareContent，并解析userInfo字典
 参数说明： shareType：分享类型, enumeration：KRSDKShareType
 
 2. 分享过程中已通知形式KingReaderSDKShareState回调参数state
 
 参见demo处理
 */
+ (void)usingShareFunctionWithWXInstall:(BOOL)wxInstall qqInstall:(BOOL)qqInstall weiboUsing:(BOOL)weibo;


/**
 手动触发隐藏分享按钮
 如果需要分享功能,不需要手动开关分享按钮的显示/隐藏,则只需要调用上面的方法即可
 如果需要控制按钮的显示隐藏需要在调用上面的方法之后才能使用该方法.
 */
+ (void)hiddenShareButtonInBookReader:(BOOL)hidden;


#pragma mark - ==========  自定制书城和书架的名称  ==========

/**
 自定制书城和书架的名称
 如果只改一个, 不改的那个就传入@"";或者nil
 
 @param city 新的书城名称
 @param shelf 新的书架名称
 @param all tabBar是否也一起改动成新的名称[默认不跟随修改]
 */
+ (void)resetBookCityTitle:(NSString *)city shelfTitle:(NSString *)shelf tabbarButtonAll:(BOOL)all;


#pragma mark - ==========  添加"图书"到书架  ==========
/**
 sdkbook 不是真正意义上的书 ,只是为了方便本地存储进行的一层包装, 不能进行账户跟随同步等功能,只能保存在本地数据库中
 
 @param bookid 只能传入标准的字符串,格式必须如下:否则出现异常,后果均自负
 /// 格式如下:12345678  "数字字符串必须大于5位" 不得出现其他字符
 /// 风险提示:
 
 @param bookName 需要在书架上展示的名称
 @param url 书架上展示的封面的URL:注意不同的书籍展示风格下应该传入不同的URL,否则可能影响展示效果
 ///风格切换在书架右键≡ 风格设置 列表样式
 @param info 备用信息, 会在点击事件的代理中传出
 */
+ (void)addSDKBookToShelfWithBookId:(NSString *)bookid bookName:(NSString *)bookName coverUrl:(NSURL *)url uniqueInfo:(NSString *)info;


/**
 获取开卷系统图书的图书信息, 请参照demo中  "自定义推荐书籍" 方法
 
 @param bid book id
 @return 图书信息
 */
+ (void)getBookInfoWithBookid:(NSString *)bid completionBlock:(void(^)(NSDictionary *result))block;


/**
 设置书架默认展示样式为列表样式， 如果不调用该方法，则展示样式为书封样式
 */
+ (void)setBookShelfDefaultShowTypeToTableView;
@end
