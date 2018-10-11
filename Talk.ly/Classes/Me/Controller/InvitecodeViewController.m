//
//  InvitecodeViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/25.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "InvitecodeViewController.h"
#import <WebKit/WebKit.h>
#import "CommonPrex.h"

@interface InvitecodeViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *inviteWebview;
@end

@implementation InvitecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Bind invite code";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _inviteWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _inviteWebview.navigationDelegate = self;
    [self.view addSubview:_inviteWebview];
    
//    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"invitation" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [_inviteWebview loadHTMLString:html baseURL:baseURL];
    [_inviteWebview.configuration.userContentController addScriptMessageHandler:self name:@"PlaySound"];
    
    NSString *urlStr = @"http://api.italkly.com/Public/getShare/invitation.html";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_inviteWebview loadRequest:request];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    //     禁用用户选择
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:NULL];
    //     禁用长按弹出框
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:NULL];
    
    //发送token
    NSString * jsStr = [NSString stringWithFormat:@"getInfo('%@')",[AccountManager sharedAccountManager].token];
    [_inviteWebview evaluateJavaScript:jsStr completionHandler:nil];
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
