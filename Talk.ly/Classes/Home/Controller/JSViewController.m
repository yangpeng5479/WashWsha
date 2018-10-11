//
//  JSViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/20.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "JSViewController.h"
#import "CommonPrex.h"
#import <WebKit/WebKit.h>
#import "DataService.h"
#import "NSDictionary+Jsonstring.h"
#import "WYFileManager.h"

@interface JSViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *userWebview;

@end

@implementation JSViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Share";
    
    _userWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    if (IS_IPHONE_X) {
        _userWebview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
    }
    _userWebview.navigationDelegate = self;
    [self.view addSubview:_userWebview];
    [_userWebview.configuration.userContentController addScriptMessageHandler:self name:@"PlaySound"];
    
    NSString *urlStr = @"http://api.italkly.com/Public/sharePage/index.html";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_userWebview loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //     禁用用户选择
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:NULL];
    //     禁用长按弹出框
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:NULL];
//
    //发送邀请码
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    NSString *str = [NSString stringWithFormat:@"%@",model.invite_info[@"invite_code"]];
    NSString * jsStr = [NSString stringWithFormat:@"getInfo('%@')",str];
    [_userWebview evaluateJavaScript:jsStr completionHandler:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"%@,%@",message.name,message.body);
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"3-----%@",message);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
