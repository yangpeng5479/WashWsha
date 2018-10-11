//
//  AboutMeViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/3.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "AboutMeViewController.h"
#import <Masonry.h>
#import "CommonPrex.h"
#import "DataService.h"
#import "ActivityRulesViewController.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"About";
    self.view.backgroundColor = [UIColor whiteColor];
    [DataService changeReturnButton:self];
    [self setupUI];
}

- (void)setupUI {
    
    NSString *app_Version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *app_Name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    UIImageView *logoImageview = [[UIImageView alloc] init];
    logoImageview.image = [UIImage imageNamed:@"icon-60"];
    logoImageview.layer.cornerRadius = kCellSpace;
    logoImageview.layer.masksToBounds = YES;
    [self.view addSubview:logoImageview];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:18];
    nameLabel.textColor = k51Color;
    nameLabel.text = app_Name;
    [nameLabel sizeToFit];
    [self.view addSubview:nameLabel];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.textColor = k153Color;
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.text = app_Version;
    [versionLabel sizeToFit];
    [self.view addSubview:versionLabel];
    
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.font = [UIFont systemFontOfSize:22];
    contactLabel.text = @"CONTACT US";
    contactLabel.textColor = kBlueColor;
    [contactLabel sizeToFit];
    [self.view addSubview:contactLabel];
    
    UILabel *emailLabel = [[UILabel alloc] init];
    emailLabel.font = [UIFont systemFontOfSize:18];
    emailLabel.text = @"Email: account@italkly.com";
    emailLabel.textColor = k51Color;
    [emailLabel sizeToFit];
    [self.view addSubview:emailLabel];
    
    UILabel *rulesLabel = [[UILabel alloc] init];
    rulesLabel.text = @"OFFICIAL RULES";
    rulesLabel.font = [UIFont systemFontOfSize:22];
    rulesLabel.textColor = kBlueColor;
    [rulesLabel sizeToFit];
    rulesLabel.userInteractionEnabled = YES;
    [self.view addSubview:rulesLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rulesAction)];
    [rulesLabel addGestureRecognizer:tap];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.textColor = k153Color;
    bottomLabel.numberOfLines = 0;
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.text = @"Copyright©2017 Beijing Chengzhong New Entertainment CO., Ltd";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [bottomLabel sizeToFit];
    [self.view addSubview:bottomLabel];
    
    [logoImageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(150);
        make.width.offset(80);
        make.height.offset(80);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(logoImageview.mas_bottom).offset(kSpace);
        make.centerX.mas_equalTo(logoImageview.mas_centerX);
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(kSpace);
        make.centerX.mas_equalTo(nameLabel.mas_centerX);
    }];
    
    [contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(50);
        make.top.mas_equalTo(versionLabel.mas_bottom).offset(50);
    }];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(contactLabel.mas_left);
        make.top.mas_equalTo(contactLabel.mas_bottom).offset(kSpace);
    }];
    [rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(contactLabel.mas_left);
        make.top.mas_equalTo(emailLabel.mas_bottom).offset(30);
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(2*kSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-2*kSpace);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kSpace);
    }];
    
}

- (void)rulesAction {
    ActivityRulesViewController *vc = [[ActivityRulesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
