//
//  ActivityRulesViewController.m
//  iTalk.ly
//
//  Created by 杨鹏 on 2018/5/18.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ActivityRulesViewController.h"
#import "PrivateViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"

@interface ActivityRulesViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *priWebview;
@end

@implementation ActivityRulesViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Privacy Agreement";
    self.view.backgroundColor = [UIColor whiteColor];
    [DataService changeReturnButton:self];
    
    CGFloat h = 0;
    if (IS_IPHONE_X) {
        h = 88;
    }else {
        h = 64;
    }
    NSString *urlStr = @"http://www.italkly.com/private/activity.html";
    _priWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, kScreenHeight-130-h)];
    _priWebview.dataDetectorTypes = UIDataDetectorTypeAll;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [_priWebview loadRequest:request];
    _priWebview.delegate = self;
    [self.view addSubview:_priWebview];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = k153Color;
    label.text = @"2018 © Vcoze";
    [label sizeToFit];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kSpace);
    }];
    
    UIButton *privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [privateBtn setTitle:@"<User privacy policy>" forState:UIControlStateNormal];
    [privateBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:144/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [privateBtn addTarget:self action:@selector(privateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateBtn];
    [privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(50);
        make.right.mas_equalTo(self.view.mas_right).offset(-50);
        make.height.offset(15);
        make.bottom.mas_equalTo(label.mas_top).offset(-kSpace);
    }];
    
    UILabel *jieshiLabel = [[UILabel alloc] init];
    jieshiLabel.font = [UIFont systemFontOfSize:15];
    jieshiLabel.text = @"Vcoze All activities have nothing to do with device manufacturer Apple.";
    jieshiLabel.textColor = [UIColor colorWithRed:255/255.0 green:144/255.0 blue:0/255.0 alpha:1];
    jieshiLabel.numberOfLines = 2;
    jieshiLabel.textAlignment = NSTextAlignmentCenter;
//    [jieshiLabel sizeToFit];
    [self.view addSubview:jieshiLabel];
    [jieshiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(_priWebview.mas_bottom).offset(kSpace);
        make.bottom.mas_equalTo(privateBtn.mas_top).offset(-kSpace);
    }];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    
    [self.priWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [self.priWebview stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
}

- (void)privateBtnAction {
    PrivateViewController *vc = [[PrivateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
