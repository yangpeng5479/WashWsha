//
//  CommonPrex.h
//  GameTogether_iOS
//
//  Created by Mac on 16/4/21.
//  Copyright © 2016年 oyell. All rights reserved.
//

#ifndef CommonPrex_h
#define CommonPrex_h

//#import <CocoaLumberjack/DDLog.h>

#define kDrawerWidth [UIScreen mainScreen].bounds.size.width*0.7
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define IS_IPHONE_X (kScreenHeight == 812.0f) ? YES : NO
#define kNavbarHeight (IS_IPHONE_X==YES)?88.0f: 64.0f
#define kStatusBar (IS_IPHONE_X == YES)?44.0f: 20.0f
#define kTabBarHeight (IS_IPHONE_X == YES)?83.0f: 49.0f
#define kSpace 10
#define kCellSpace 5

#define kLightBgColor [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]
#define kNavColor [UIColor colorWithRed:49/255.0 green:197/255.0 blue:102/255.0 alpha:1]
#define k51Color [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define k102Color [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define k153Color [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
#define kErrorColor [UIColor colorWithRed:255/255.0 green:158/255.0 blue:158/255.0 alpha:1.0]
#define kChoiceColor [UIColor colorWithRed:102/255.0 green:206/255.0 blue:232/255.0 alpha:1.0]

#define kGreenColor [UIColor colorWithRed:80/255.0 green:160/255.0 blue:35/255.0 alpha:1.0]
#define kRedColor [UIColor colorWithRed:200/255.0 green:35/255.0 blue:50/255.0 alpha:1.0]

#define karc1 [UIColor colorWithRed:76/255.0 green:203/255.0 blue:192/255.0 alpha:1.0]
#define karc2 [UIColor colorWithRed:161/255.0 green:76/255.0 blue:205/255.0 alpha:1.0]
#define karc3 [UIColor colorWithRed:204/255.0 green:77/255.0 blue:158/255.0 alpha:1.0]
#define karc4 [UIColor colorWithRed:83/255.0 green:76/255.0 blue:205/255.0 alpha:1.0]

#define kLineColor [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]
#define kBlueColor [UIColor colorWithRed:63/255.0 green:155/255.0 blue:138/255.0 alpha:1]
#define kTipsColor [UIColor colorWithRed:238/255.0 green:133/255.0 blue:101/255.0 alpha:1]

#define UI_IS_IPHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6 (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0) // Both orientations
#define UI_IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define PPI (UI_IS_IPHONE6PLUS ? 153 : 163)
#define Height_NavContentBar 44.0f

//#define kIPAddress @"apitest.ichatly.com"
#define kIPAddress @"api2.ichatly.com"
#define BaseURL [NSString stringWithFormat:@"http://%@/",kIPAddress]

#define kUMAppkey @"58184121ae1bf8666e0025a6"

//#define kRCAppKey @"mgb7ka1nmyh8g"//生产环境
#define kRCAppKey @"e5t4ouvpegj8a"//开发环境

#define DEFAULTS [NSUserDefaults standardUserDefaults]

#endif /* CommonPrex_h */

#import "UIView+XWAddForRoundedCorner.h"
#import "UIViewExt.h"
#import "AccountManager.h"
#import <UIViewController+MMDrawerController.h>
#import "BaseBottomViewController.h"
#import "UUIDTool.h"

#if DEBUG

#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)
#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)
#else
#define NSLog(FORMAT, ...) nil
#define NSLogRect(rect) nil
#define NSLogSize(size) nil
#define NSLogPoint(point) nil
#endif


