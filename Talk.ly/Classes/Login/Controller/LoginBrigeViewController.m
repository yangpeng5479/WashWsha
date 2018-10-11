//
//  LoginBrigeViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LoginBrigeViewController.h"
#import "CommonPrex.h"
#import "WYFileManager.h"
#import "UserModel.h"
#import <Masonry.h>
#import "MoreLoginViewController.h"
#import <UIImageView+WebCache.h>

@interface LoginBrigeViewController ()

@end

@implementation LoginBrigeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    if (IS_IPHONE_X) {
        bgImageView.image = [UIImage imageNamed:@"loin_x_bg"];
    }
    [self.view addSubview:bgImageView];
    
    UIButton *otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [otherBtn setTitle:@"Login Another Account" forState:UIControlStateNormal];
    [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(otherBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];
    [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(50);
        make.right.mas_equalTo(self.view.mas_right).offset(-50);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.height.offset(20);
    }];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    phoneBtn.backgroundColor = [UIColor whiteColor];
    [phoneBtn setTitle:model.name forState:UIControlStateNormal];
    //    [phoneBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    phoneBtn.layer.borderWidth = 2;
    phoneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    phoneBtn.layer.cornerRadius = 25;
    phoneBtn.layer.masksToBounds = YES;
    [self.view addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(5*kSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-5*kSpace);
        make.bottom.mas_equalTo(otherBtn.mas_top).offset(-20);
        make.height.offset(50);
    }];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    iconView.layer.cornerRadius = kSpace;
    iconView.layer.masksToBounds = YES;
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(phoneBtn.mas_top).offset(-50);
        make.width.height.equalTo(@130);
    }];
}

#pragma mark - 点击事件
//好几种登录方式的登录首页
- (void)otherBtnAction {
    
    MoreLoginViewController *moreVC = [[MoreLoginViewController alloc] init];
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:moreVC];
}

//登录
- (void)phoneBtnAction {
    [DEFAULTS setBool:NO forKey:@"isLogout"];
    [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseBottomViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
