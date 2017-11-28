//  代码地址: https://github.com/CoderMJLee/TJJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>
#import <objc/message.h>

// 日志输出
#ifdef DEBUG
#define TJJRefreshLog(...) NSLog(__VA_ARGS__)
#else
#define TJJRefreshLog(...)
#endif

// 过期提醒
#define TJJRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define TJJRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define TJJRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define TJJRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 文字颜色
#define TJJRefreshLabelTextColor TJJRefreshColor(90, 90, 90)

// 字体大小
#define TJJRefreshLabelFont [UIFont boldSystemFontOfSize:14]

// 图片路径
#define TJJRefreshSrcName(file) [@"TJJRefresh.bundle" stringByAppendingPathComponent:file]
#define TJJRefreshFrameworkSrcName(file) [@"Frameworks/TJJRefresh.framework/TJJRefresh.bundle" stringByAppendingPathComponent:file]

// 常量
UIKIT_EXTERN const CGFloat TJJRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat TJJRefreshFooterHeight;
UIKIT_EXTERN const CGFloat TJJRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat TJJRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const TJJRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const TJJRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const TJJRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const TJJRefreshKeyPathPanState;

UIKIT_EXTERN NSString *const TJJRefreshHeaderLastUpdatedTimeKey;

UIKIT_EXTERN NSString *const TJJRefreshHeaderIdleText;
UIKIT_EXTERN NSString *const TJJRefreshHeaderPullingText;
UIKIT_EXTERN NSString *const TJJRefreshHeaderRefreshingText;

UIKIT_EXTERN NSString *const TJJRefreshAutoFooterIdleText;
UIKIT_EXTERN NSString *const TJJRefreshAutoFooterRefreshingText;
UIKIT_EXTERN NSString *const TJJRefreshAutoFooterNoMoreDataText;

UIKIT_EXTERN NSString *const TJJRefreshBackFooterIdleText;
UIKIT_EXTERN NSString *const TJJRefreshBackFooterPullingText;
UIKIT_EXTERN NSString *const TJJRefreshBackFooterRefreshingText;
UIKIT_EXTERN NSString *const TJJRefreshBackFooterNoMoreDataText;

// 状态检查
#define TJJRefreshCheckState \
TJJRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
