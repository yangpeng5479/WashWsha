//
//  PrivateViewController.m
//  iChat.ly
//
//  Created by 杨鹏 on 2018/5/16.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "PrivateViewController.h"
#import "CommonPrex.h"

@interface PrivateViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *priWebview;
@end

@implementation PrivateViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"User privacy policy";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = @"http://iichatly.com/private/agreement.html";
    _priWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _priWebview.dataDetectorTypes = UIDataDetectorTypeAll;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_priWebview loadRequest:request];
    _priWebview.delegate = self;
    [self.view addSubview:_priWebview];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    
    [self.priWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.priWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
