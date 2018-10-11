//
//  IncomeViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/7/3.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "IncomeViewController.h"
#import "CommonPrex.h"
#import <WebKit/WebKit.h>
#import "NSDictionary+Jsonstring.h"
#import "DataService.h"


@interface IncomeViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *userWebview;

@end

@implementation IncomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Income";
    
    _userWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    if (IS_IPHONE_X) {
        _userWebview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
    }
    _userWebview.navigationDelegate = self;
    [self.view addSubview:_userWebview];
    [_userWebview.configuration.userContentController addScriptMessageHandler:self name:@"PlaySound"];

    [self isCheckingData];
}

- (void)isCheckingData {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [DataService postWithURL:@"rest3/v1/Startup/appleCheckingV2" type:1 params:nil fileData:nil success:^(id data) {
        
        NSLog(@"%@",data);
         NSString *urlStr = @"";
        NSString *v = [NSString stringWithFormat:@"%@",data[@"data"]];
        if ([v isEqualToString:app_Version]) {
            urlStr = @"http://pages.italkly.com/exchange/index.html";
        }else {
            urlStr = @"http://pages.italkly.com/Withdraw/index.html";
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [_userWebview loadRequest:request];
    } failure:^(NSError *error) {
        
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //     禁用用户选择
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:NULL];
    //     禁用长按弹出框
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:NULL];
    
    //发送token
    NSString * jsStr = [NSString stringWithFormat:@"getInfo('%@')",[AccountManager sharedAccountManager].token];
    [_userWebview evaluateJavaScript:jsStr completionHandler:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"------------------%@,%@-------------------",message.name,message.body);
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"3-----%@",message);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
