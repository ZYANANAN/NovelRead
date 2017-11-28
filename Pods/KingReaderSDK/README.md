0. KingReaderSDK iOS SDK说明文档
1. 概述
2. 集成SDK
3. 重要API详解
4. 快速问答
5. 技术支持

# 本说明文档仅仅是介绍SDK使用， 具体接入方法的使用请务必参照 KingReaderSDK.h 文件
# 本说明文档仅仅是介绍SDK使用， 具体接入方法的使用请务必参照 KingReaderSDK.h 文件
# 本说明文档仅仅是介绍SDK使用， 具体接入方法的使用请务必参照 KingReaderSDK.h 文件

# KingReaderSDK iOS SDK说明文档
## 概述
本文档面向iOS开发者。开卷有益iOS平台的SDK是为了让第三方更方便调用API接口而服务的产品。第三方不再需要复杂的验证，通过SDK的对接后直接调用API就可实现图书信息的浏览及图书阅读等功能。

## SDK相关信息
KingReaderSDK基于线上版本【开卷有益 v2.6.9】进行开发，保留【开卷有益】绝大部分功能，SDK接入方可以先去AppStore下载最新版本的App熟悉相关的功能和业务。 
[开卷有益iTunes地址](https://itunes.apple.com/cn/app/kai-juan-you-yi/id513822899?mt=8)

** SDK唯一有效更新地址**
https://git.zhuishushenqi.com/zhuge/KingReaderSDK
【pod集成时请不要指定版本号】

## SDK更新信息
- 2017-10-10
    此次更新无新功能增加，修复了iOS11中的部分小问题

- 2017-06-06 
    此次更新podfile需要添加对应的信息，接入了防止劫持的HTTPDNS：
    source 'https://github.com/aliyun/aliyun-specs.git'
    pod 'AlicloudHTTPDNS'

    添加部分特性功能【仅限指定合作方使用】
    
- 2017-04-06 KingReaderSDK 2.7.0
    添加cps后台配置广告的相关功能：目前广告有三种添加方式，接入方可以自选其中任意的方式进行配置
    cps账号等问题请联系产品或市场。

- 2017-03-27 KingReaderSDK 2.6.0
    添加推荐书籍功能,参照demo中 getBookInfoWithBookid:
    如有疑问请联系开发人员处理

- 2017-02-22 KingReaderSDK 2.5.0
    - 新增API: 用户可以根据要求添加"书"到书架,可以接受点击时间的处理:

- 2017-01-10 KingReaderSDK 2.4.0
    - 新版本将FMDB改成Pod管理, 所以Podfile需要更新!!!
    - 添加微信支付打开微信App和回调的说明(请查看demo中的集成说明)
    - 兼容iOS7.1以上版本(注: 2.4.0以后的版本将从iOS8开始兼容)
    - 请查看: info.plist中: URL types/LSApplicationQueriesSchemes
    - AppDelegate和ViewController

- 2016-12-20 KingReaderSDK 2.3.0
    - 添加内购功能，用于帮助审核(API请查看DEMO与.h说明)
    - 注：提交审核时setHiddenPayEntrance:YES;
    - 审核完毕时发布线上时：setHiddenPayEntrance:NO;

- 2016-12-16 KingReaderSDK 2.2.0
    - 添加分享功能, 此部分功能请查看demo

- 2016-12-13 KingReaderSDK 2.1.0
    - 添加广点通广告

- 2016-12-08
    - 修复部分bug,增加对iPad的支持

- 2016-12-06 
    - 小米推送功能（书籍更新推送通知）
    - 部分API变更（需要重新改变方法名）
    - 横屏bug解决（见demo中appdelegate.m）
    - 添加关于Unid的错误示例，以及建议方案

- 2016-11-14 
    - KingReaderSDK 2.0新版发布

# 集成SDK
SDK兼容最低系统版本为iOS8.0。
- 导入头文件 #import "KingReaderSDK.h"
- SDK2.0版本：Link Binary With Library中添加 AddressBook.framework 否则会出现报错。
- 用户自定义相关设置（此处代码不完整，请运行demo查看
- 本SDK对应一个Demo，用户可以自行参照Demo进行开发，但Demo不保证非SDK业务代码或设置的正确性，开发者请自行处理相关内容。
- 由于SDK依赖的第三方库很多，所以推荐使用cocoapods来集成开卷有益SDK
> 请参考SDK Demo进行设置

# 重要API详解
### 关于Apple审核相关配置
SDK内部具有购买和支付相关功能,SDK提供三方支付,已保证用户进行消费SDK内部产品.内购功能只允许用于帮助审核通过. 开卷有益团队要求SDK使用方必须遵守以下支付规定:
- 不得以任何方式接入涉及开卷产品的支付功能,接入方自己的产品不作此要求
- 线上发布应用[distribution]或分发[adhoc]的App不允许使用内购功能(下面会详细介绍).

```
//Method1：可选方法,根据InAppStorePerchase.txt传入有效数组;
+ (void)bringInAppStoreIdentifiers:(NSArray *)identifiers;

//Method2: 必选方法,提交AppStore审核时设置为YES，发布应用时选择NO;
+ (void)setHiddenPayEntrance:(BOOL)hidden;
```
以上两个方法,如果SDK接入方不打算使用内购以帮助顺利通过审核,可以只用Method2,但是必须遵守上述的描述. Method1如果需要使用,则必须在Method2调用之前进行调用,否则SDK内部无法判断接入方的真实意图,可能导致设置失效.


### 用户注册及登录
```
//unid 创建用户的唯一标识，友方app的用户id或者其他唯一标识符
//channelId 渠道id，友方app唯一标识符，请找产品确认
//block 用户登陆成功或失败的回调
+ (void)loginWithUniqueId:(NSString *)unid channelId:(int)channelId completeBlock:(void (^)(NSString *error, BOOL succeed))block;
```
此处出现过用户id不唯一导致创建新用户失败的情况,请各位接入方注意:
1.此处不要单纯的传入idfa,因为用户可能关闭了权限,会导致idfa获取不到的情况.
2.如果有多个app的用户,请根据不同的bundleid进行进一步区分,否则可能出现推广的用户数量和开卷服务器数量不一致的情况,此处的unid是开卷用户的唯一识别标示.请各位务必保证每一个用户的每一个app都是唯一的ID.
3.SDK demo提供了一种可行的方案供接入方参考.具体参照demo文件

### 添加新的item
```
//Method1
+ (void)addTabButton:(NSString *)title imageName:(NSString *)imageName viewController:(UIViewController *)newVC atIndex:(NSInteger)index;

//Method2
+ (void)addTabButton:(NSString *)title normalImage:(UIImage *)image selectedImage:(UIImage *)selectedImage viewController:(UIViewController *)newVC atIndex:(NSInteger)index;

//Method3
+ (void)addTabButtons:(NSArray<NSString *> *)titles imageNames:(NSArray<NSString *> *)imageNames viewControllers:(NSArray<UIViewController *> *)newVCs;

//Method4
+ (void)addTabButtons:(NSArray<NSString *> *)titles normalImages:(NSArray<UIImage *> *)images selectedImages:(NSArray<UIImage *> *)selImages viewControllers:(NSArray<UIViewController *> *)newVCs;

```
以上方法用户接入方接入自己的view controller, Method1 & Method2为添加一个页面 Method3 & Method4为添加两个页面. 
开卷在设置navigation的时候进行了特殊处理,所以新增页面的导航栏item请在view  will appear中进行设置,并且先调用:
```
self.tabBarController.navigationItem.leftBarButtonItems = nil;
self.tabBarController.navigationItem.rightBarButtonItems = nil;
```

### 小米推送
```
+ (void)bindDeviceTokenForMiPush:(NSData *)token;
```
SDK内部集成了小米推送功能,如果接入方需要使用小米推送书籍更新,请自行注册小米推送账号,并且集成pod
`pod 'MiPushSDK',        :git => 'https://git.oschina.net/kingreader/MiPushSDK.git'`
相对应的代码和配置参见demo AppDelegate和plist文件
Tag：集成完毕之后需要通知我方，开通相关推送的服务器权限。


### 关于广告
SDK内部集成了广告功能，书架上签到位有开卷自己的广告，SDK提供了屏蔽API。另外开卷SDK有广点通的广告功能，接入方可自行申请账号进行接入，相关API如下：
```
+ (void)usingKRCustomAdAndCloseGDTAd:(BOOL)cpsUsing;

+ (void)usingGDTNativeAdWithAppKey:(NSString *)appkey placementId:(NSString *)placementId;

+ (void)shieldNativeAds:(BOOL)shield;
```

### 分享功能
```
+ (void)usingShareFunctionWithWXInstall:(BOOL)wxInstall qqInstall:(BOOL)qqInstall weiboUsing:(BOOL)weibo;

+ (void)hiddenShareButtonInBookReader:(BOOL)hidden;
```
分享功能先只给出分享的内容字典和回调的state处理。均已通知的形式进行。SDK使用方需要注册通知。如果需要手动触发隐藏/显示分享按钮
分享功能需要进行配置 URL type和 LSApplicationQueriesSchemes 接入方自行处理。

### 添加"图书"到书架 
```
+ (void)addSDKBookToShelfWithBookId:(NSString *)bookid bookName:(NSString *)bookName coverUrl:(NSURL *)url uniqueInfo:(NSString *)info;
```
SDK提供一个加入书架的入口并且将点击回调事件通过通知进行传递，用户可以自己处理点击事件。书架上的数有封面和列表两种展示方式。
需要传入的参数为 
- bookid：因为开卷本身有此参数，为保证id不同请尽量将此ID特殊化
- bookname: 书架需要显示的书名或者title
- url: 书架书的封面URL地址
- info：接入方需要开卷保存的信息，以string形式传递，例如需要跳转的地址等

# 通知解释
SDK内部会发送并且接受一些通知,以辅助接入方开发相关功能：如下
```
//点击TabBar通知点击的下标index
KingReaderSDKTabbarClick

//分享相关字符串
//分享的内容
KingReaderSDKShareContent
//分享状态
KingReaderSDKShareState
//分享当前状态:[有对应的枚举:KRSDKResponseState]
KingReaderSDKShareState_Current
//分享的类型[有对应的枚举:KRSDKShareType]
KingReaderSDKShareType

//阅读器章节跳转-刚点击
KingReaderSDKStartChangeChapter
//阅读器章节跳转-开始显示章节内容
KingReaderSDKChangeChapterStartLoadNewPage

//点击书架自定义的书发出通知
KingReaderSDKClickCustomizedBook
```

# 快速问答

- Q：SDK支持的支付方式
- A：SDK审核期间可以隐藏收费信息，做成免费版本，也可以使用内购以帮助审核，但是版本发布的时候只允许使用开卷提供的网页支付。开卷为接入方开通了后台查看每日用户支付收入情况，请联系产品询问。


- Q：SDK团队的工作时间
- A：SDK团队工作时间为：周一至周五 9:00 ~ 21:00，周末时间理论上不进行技术支持。


- Q：审核被拒怎么办？
- A：请根据实际情况确定是否为SDK内部的问题，如果是SDK处理未达到审核要求请及时联系技术人员【qq：2271637488】


- Q：怎样快速接入提高开发效率?
- A：请仔细查看KingReaderSDK.h， KingReaderSDKDemo，以及相关文档，如有疑问请联系技术支持人员。


- Q：内购获取商品信息失败，怎么办？
- A：首先查看你iTunes里面商品是否正常，其次查看税务信息，银行信息是否填写完整，如果上述正常，请联系开发人员。


- Q：好多广告相关的API，他们都怎么用？
- A：目前提供给接入方的添加广告API有三个，分别是cps后台，广电通和本地写入的方式：
    - cps后台配置，接入方可以直接使用cps进行后台配置，输入正确的信息，，使用下方的API：

    `+ (void)usingKRCustomAdAndCloseGDTAd:(BOOL)cpsUsing;`
    
    - 广点通SDK接入，使用下方的API：
    
    `+ (void)usingGDTNativeAdWithAppKey:(NSString *)appkey placementId:(NSString *)placementId;`
    
    - 主动写入广告相关信息，使用下方API：
    
    `+ (void)addSDKBookToShelfWithBookId:(NSString *)bookid bookName:(NSString *)bookName coverUrl:(NSURL *)url uniqueInfo:(NSString *)info;`

    - 开卷本身书架上签到的地方会有广告展示，如果希望屏蔽该广告，可以使用：
    
    `+ (void)shieldNativeAds:(BOOL)shield;`


- Q：API是在登录前调用还是在登录后调用？
- A：一般来说，如果此API涉及到接入方channelID需要在登录后调用。 具体可以参照Demo，或咨询开发人员


# 技术支持
商务&产品支持联系qq：286905729（刘）  
技术支持开发人员qq：2271637488（诸革-iOS开发）

## 申明
App名字请避免使用“开卷有益”、“开卷小说”、“追书神器”、“追书小说”等开卷有益团队的相关或相似App名称。另外请不要侵犯其他小说类App的相关权益，请各位接入方注意。
