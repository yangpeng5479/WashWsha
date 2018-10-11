//
//  ForgetPasswordViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/17.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "CommonPrex.h"

@interface ForgetPasswordViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *web;

@end

@implementation ForgetPasswordViewController

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
    self.navigationItem.title = @"Rcovery Password";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = @"http://api.italkly.com/Public/pages/forget_pass.html";
    _web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _web.dataDetectorTypes = UIDataDetectorTypeAll;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_web loadRequest:request];
    _web.delegate = self;
    [self.view addSubview:_web];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    
    [self.web stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.web stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
