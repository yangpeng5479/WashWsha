
//
//  AppDelegate.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonPrex.h"
#import <UserNotifications/UserNotifications.h>
#import "DataService.h"
#import "AccountManager.h"
#import "GiftModel.h"
#import <MJExtension.h>
#import <UMMobClick/MobClick.h>
#import "LoginViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MoreLoginViewController.h"
#import "LoginBrigeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <JPush/JPUSHService.h>
#import "BaseBottomViewController.h"
#import <FBSDKAppEvents.h>
#import "WYFileManager.h"




@interface AppDelegate ()<JPUSHRegisterDelegate>

@property(nonatomic,strong)NSMutableArray *tempGiftListMarr;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString *usertoken = [DEFAULTS objectForKey:@"token"];
    BOOL isLogout = [DEFAULTS boolForKey:@"isLogout"];
    if (!usertoken && !isLogout) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[MoreLoginViewController alloc] init]];
        self.window.rootViewController = nav;
    }else if (usertoken && !isLogout) {
        self.window.rootViewController = [[BaseBottomViewController alloc] init];
    }else if (usertoken && isLogout) {
        self.window.rootViewController = [[LoginBrigeViewController alloc] init];
    }
    
//    self.window.rootViewController = [[GuideViewController alloc] init];

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"cd71c5e0f0c23e373e268f8f"
                          channel:@"App Store"
                 apsForProduction:YES];
    
    
    [self loadGiftData];
    
    //初始化sharesdk
    NSArray *arr = @[@(SSDKPlatformTypeFacebook)];
    [ShareSDK registerActivePlatforms:arr onImport:^(SSDKPlatformType platformType) {
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
    }];
    
    //初始化友盟
    UMConfigInstance.appKey = @"5ad6b093f43e4878bf0000d2";
    UMConfigInstance.channelId = nil;
    [MobClick startWithConfigure:UMConfigInstance];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    NSString *uid = [DEFAULTS objectForKey:@"userid"];
    if (uid) {
        [MobClick profileSignInWithPUID:uid provider:@"91110105MA019PL76Q"];
        [DataService HTTPTimeData];
    }
    //测试
    [MobClick setLogEnabled:YES];
    
    if (!launchOptions) {
        [self _clearAllNotifications];
    }
    
    [AccountManager sharedAccountManager].locationDic = [WYFileManager getCustomObjectWithKey:@"location"];
    if ([AccountManager sharedAccountManager].locationDic == nil) {
        [AccountManager sharedAccountManager].locationDic = @{@"city":@"Unknow",@"latitude":@"",@"longitude":@""};
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    NSString *pushToken = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [DEFAULTS setObject:pushToken forKey:@"push"];
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    [self _clearAllNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    NSLog(@"%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self _clearAllNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6Z
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)_clearAllNotifications {
    
    //    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

//更新检查
- (void)updateCheck {
    NSString *pushtoken = [DEFAULTS objectForKey:@"push"];
    if ([pushtoken isEqualToString:@""] || !pushtoken) {
        pushtoken = @"";
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *deviceUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSDictionary *dic = @{@"device_id":deviceUUID,@"device_name":deviceName,@"device_version":sysVersion,@"device_language":@"en",@"app_version":appVersion,@"app_type":@"iOS",@"app_bundle_id":@"italk",@"latitude":[AccountManager sharedAccountManager].locationDic[@"latitude"],@"longitude":[AccountManager sharedAccountManager].locationDic[@"longitude"],@"push_token":pushtoken};
    [DataService postWithURL:@"rest3/v1/Startup/init" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"updateCheck:%@",data);
        NSDictionary *infoDic = data[@"data"];
        float app = [infoDic[@"version"] floatValue];
        if (app > [appVersion floatValue]) {
            if ([infoDic[@"force_update"] boolValue]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Update Tips" message:infoDic[@"info"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *update = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/vcoze/id1392171229?mt=8"]];
                }];
                [alert addAction:update];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadGiftData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"giftList.plist"];
    
    _tempGiftListMarr = [NSMutableArray arrayWithContentsOfFile:filePath];
    if ([DEFAULTS objectForKey:@"token"]) {
        NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
        [DataService postWithURL:@"rest3/v1/Gift/get_gift_list" type:1 params:dic fileData:nil success:^(id data) {
            NSLog(@"%@",data);
            
            NSMutableArray *arr = data[@"data"][@"gift_list"];
            _tempGiftListMarr = [NSMutableArray arrayWithArray:arr];
            [_tempGiftListMarr writeToFile:filePath atomically:YES];
            [AccountManager sharedAccountManager].giftListMarr = _tempGiftListMarr;
           [AccountManager sharedAccountManager].giftModelMarr = [GiftModel mj_objectArrayWithKeyValuesArray:_tempGiftListMarr];
            for (int i = 0; i < [AccountManager sharedAccountManager].giftModelMarr.count; ++i) {
                GiftModel *model = [AccountManager sharedAccountManager].giftModelMarr[i];
                model.gift_image_key = [AccountManager sharedAccountManager].imageArr[i];
//                NSLog(@"appdelegate ==== =====%@",model.gift_image_key);
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self updateCheck];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    [self updateCheck];
}




@end
