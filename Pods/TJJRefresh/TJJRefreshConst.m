//  代码地址: https://github.com/CoderMJLee/TJJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat TJJRefreshHeaderHeight = 54.0;
const CGFloat TJJRefreshFooterHeight = 44.0;
const CGFloat TJJRefreshFastAnimationDuration = 0.25;
const CGFloat TJJRefreshSlowAnimationDuration = 0.4;

NSString *const TJJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const TJJRefreshKeyPathContentInset = @"contentInset";
NSString *const TJJRefreshKeyPathContentSize = @"contentSize";
NSString *const TJJRefreshKeyPathPanState = @"state";

NSString *const TJJRefreshHeaderLastUpdatedTimeKey = @"TJJRefreshHeaderLastUpdatedTimeKey";

NSString *const TJJRefreshHeaderIdleText = @"下拉可以刷新";
NSString *const TJJRefreshHeaderPullingText = @"松开立即刷新";
NSString *const TJJRefreshHeaderRefreshingText = @"正在刷新数据中...";

NSString *const TJJRefreshAutoFooterIdleText = @"点击或上拉加载更多";
NSString *const TJJRefreshAutoFooterRefreshingText = @"正在加载更多的数据...";
NSString *const TJJRefreshAutoFooterNoMoreDataText = @"已经全部加载完毕";

NSString *const TJJRefreshBackFooterIdleText = @"上拉可以加载更多";
NSString *const TJJRefreshBackFooterPullingText = @"松开立即加载更多";
NSString *const TJJRefreshBackFooterRefreshingText = @"正在加载更多的数据...";
NSString *const TJJRefreshBackFooterNoMoreDataText = @"已经全部加载完毕";