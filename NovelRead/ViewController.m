//
//  ViewController.m
//  NovelRead
//
//  Created by 张闫 on 2017/11/14.
//  Copyright © 2017年 Yanan. All rights reserved.
//

#import "ViewController.h"

#import "KingReaderSDK.h"
#import "ThirdLoginSDK.h"
//此处为使用idfa的SDK用户调用，如不使用请勿import
#import <AdSupport/ASIdentifierManager.h>
#define kBaseHeight [[UIScreen mainScreen]bounds].size.height
#define APP_statusBar_HEIGHT         [[UIApplication sharedApplication] statusBarFrame].size.height
#define APP_Tabbar_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define APP_NAV_HEIGHT            APP_statusBar_HEIGHT+44
#define APP_Security_Height       20
#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

@interface ViewController ()
{
    NSTimer *timer;
      int initialTimer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,APP_SCREEN_WIDTH , kBaseHeight)];
    imgV.image = [UIImage imageNamed:@"750"];
    [self.view addSubview:imgV];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(autoShowMainVC:) userInfo:nil repeats:YES];

    initialTimer=4;
    self.navigationController.navigationBarHidden= NO;
//    self.navigationController.navigationBar.barStyle  = UIBarStyleDefault;
//    self.navigationController.navigationBar.barTintColor =[UIColor colorWithRed:247/255.0 green:247/255.0 blue:248/255.0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   
    
    //不展示广告
    NSString *appKey = @"1104781853";
    NSString *placementId = @"1080612788041069";
    [KingReaderSDK usingGDTNativeAdWithAppKey:appKey placementId:placementId];
    [self haveFun];
    
}
//内购
-(void)haveFun{
    NSString *appUniqueId = @"XXXXX";
    NSArray *originIdentifiers = @[@"com.kingreader.6yuan", @"com.kingreader.18yuan", @"com.kingreader.30yuan", @"com.kingreader.108yuan", @"com.kingreader.30vip.sale", @"com.kingreader.30tvip", @"com.kingreader.90tvip", @"com.kingreader.180tvip", @"com.kingreader.360tvip"];
    NSMutableArray *identifiers = [NSMutableArray array];
    for (NSString *str in originIdentifiers) {
        [identifiers addObject:[appUniqueId stringByAppendingString:str]];
    }
    //请注意下面两个API的调用顺序,如果期望审核期间使用内购提高过审概率,需要如下设置:
    [KingReaderSDK bringInAppStoreIdentifiers:identifiers];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *pub_dt = [formatter dateFromString:@"2017-11-30 00:00:00"];
    NSDate *startTime = [NSDate date];
    NSTimeInterval secs = [pub_dt timeIntervalSinceDate:startTime];
    if (secs>0) {
        [KingReaderSDK setHiddenPayEntrance:YES];//审核期间必须打开
    }else{
        [KingReaderSDK setHiddenPayEntrance:NO];//过审核后上线时一定要设置
    }
    
    
    
    //过审核后上线时一定要设置
    //    [KingReaderSDK setHiddenPayEntrance:NO];
    
}
-(void)autoShowMainVC:(NSTimer *)timer{
    
    if (initialTimer==0) {
       
        [self stopTimer];
    }else{
        initialTimer--;
        
    }
}

-(void)stopTimer{
    
    if(timer){
        [timer invalidate];
        if (![KingReaderSDK isLogined]) {
            NSString *unid = @"---SDK用户传入的Unid(请查看 pragma mark - 错误示例)";
            unid = [self getVaildUnid];
            //unid的传入请务必保证唯一性，请看错误的示例和建议方案！！！
            [KingReaderSDK loginWithUniqueId:unid channelId:588 completeBlock:^(NSString *error, BOOL succeed) {
                if (succeed) {
                    [KingReaderSDK usingKRCustomAdAndCloseGDTAd:YES];
                    
                }
             
              
                
                [self getBookInfoWithBookid:@"1229021"];
                UIViewController *vc = [KingReaderSDK rootViewController];
                   [KingReaderSDK setHiddenMainInterfaceBackButton:YES];
                [KingReaderSDK setNavigationBackgroundColor:[UIColor whiteColor]];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }else{

            UIViewController *vc = [KingReaderSDK rootViewController];
            [KingReaderSDK setHiddenMainInterfaceBackButton:YES];

            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
}
-(void)dealloc{
    if (timer) {
        [timer invalidate];
        timer=nil;
    }
}

#pragma mark - ==========  添加SDK内部通知监听  ==========
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:KingReaderSDKTabbarClick object:nil];
    [KingReaderSDK usingShareFunctionWithWXInstall:YES qqInstall:YES weiboUsing:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShareContent:) name:KingReaderSDKShareContent object:nil];
}

- (void)handleNotification:(NSNotification *)notice {
    NSNumber *index = notice.object;
    NSLog(@"index=%@",index);
}
- (void)handleShareContent:(NSNotification *)notice {
    if ([notice.name isEqualToString:KingReaderSDKShareContent]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:notice.userInfo];
        KRSDKShareType type = [[dict valueForKey:KingReaderSDKShareType] integerValue];
        [ThirdLoginSDK share:(SSDKShareType)type parameters:dict onStateChanged:^(SSDKResponseState state, NSDictionary *userData, NSError *error) {
            NSDictionary *userInfo = @{KingReaderSDKShareState_Current : @(state)};
            dispatch_async(dispatch_get_main_queue(), ^{//保证通知的发送与接收在同一线程内。
                [[NSNotificationCenter defaultCenter] postNotificationName:KingReaderSDKShareState object:nil userInfo:userInfo];
            });
        }];
    }
}
//可选方案如下：
//使用bundleID+channelID+idfv+注册时间来保证唯一性
//此处存储unid可以考虑keychain存储。
- (NSString *)getVaildUnid {
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   
        NSInteger num = arc4random() / 99999999;
        return [[bundleID stringByAppendingString:idfv] stringByAppendingString:[NSString stringWithFormat:@"%ld", num]];
    
    return [[bundleID stringByAppendingString:idfv] stringByAppendingString:[self fetchTimeNow:588]];
}
- (NSString *)fetchTimeNow:(int)channelID {
    //demo的channelID=99，用户可以自己传入自己的channelID
    NSString *date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd-hh:mm:ss:SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"-%d-%@", channelID, date];
    return timeNow;
}
/**
 >>> 针对需要添加一本默认的书籍到书籍第一位置的方法
 这里可以根据一本书的ID获取相关的信息, 并且接入方需要将此信息写入txt文件,并且命名为 recommend.txt
 将此文件直接放置在main bundle中以方便SDK读取相关信息.
 以上信息也可通过抓包工具获取,这里写成本地文件是为了防止用户即时请求失败导致的第一本书无法达到预期目的
 
 信息的填写可以参照demo中的recommend.txt文件中进行对应 key的value值替换即可,请不要修改文件的格式或者编码格式.
 
 1.SDK内部会首先获取接入方在开卷SDK后台配置的书籍信息,添加到书籍.
 >> 此处的配置根据接入方的渠道号进行设置.
 
 2.然后会读取本地的推荐书籍,并将此书放置在第一位置进行推荐.
 
 此方法只是为了获取bookID对应书籍信息的方便提供的API,实际代码中可以不包含.只要用来获取信息就可以了,因为要传入token,所以请在登录完成之后获取信息.
 */
- (void)getBookInfoWithBookid:(NSString *)bookid {
    [KingReaderSDK getBookInfoWithBookid:@"1187814" completionBlock:^(NSDictionary *result) {
        NSLog(@"当前请求的book信息= %@", result);
        //注: 此处的信息就是需要加入到本地文件的书籍信息
        //只需要将resultStr打印并且移除vs这部分
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
