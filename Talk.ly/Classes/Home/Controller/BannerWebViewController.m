//
//  BannerWebViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/10/10.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BannerWebViewController.h"
#import <WebKit/WebKit.h>
#import "CommonPrex.h"

@interface BannerWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *bannerWebview;

@end

@implementation BannerWebViewController

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
    self.navigationItem.title = self.title;
    
    _bannerWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    if (IS_IPHONE_X) {
        _bannerWebview.frame = CGRectMake(0, 88, kScreenWidth, kScreenHeight-88);
    }
    _bannerWebview.navigationDelegate = self;
    [self.view addSubview:_bannerWebview];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.pageurl]];
    [_bannerWebview loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //     禁用用户选择
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:NULL];
    //     禁用长按弹出框
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:NULL];
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
