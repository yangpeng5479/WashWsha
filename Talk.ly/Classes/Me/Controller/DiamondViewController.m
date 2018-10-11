//
//  DiamondViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "DiamondViewController.h"
#import <MBProgressHUD.h>
#import "CommonPrex.h"
#import "DataService.h"
#import "UserModel.h"
#import "AccountManager.h"
#import <MJExtension.h>
#import <Masonry.h>
#import "TakecashOutViewController.h"
#import "ExchangeGoldViewController.h"


@interface DiamondViewController ()

@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong)UILabel *diamondLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,assign)float coupon;

@end

@implementation DiamondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadWalletData];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Income";
    [self setupUI];
    [DataService changeReturnButton:self];
    NSLog(@"%@",[AccountManager sharedAccountManager].token);
}

#pragma mark - 更新UI
- (void)setupUI {
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.layer.cornerRadius = kCellSpace;
    imageview.layer.masksToBounds = YES;
    imageview.image = [UIImage imageNamed:@"bluecard"];
    [self.view addSubview:imageview];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view.mas_left).offset(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-35);
        make.top.mas_equalTo(self.view.mas_top).offset(kNavbarHeight+20);
        make.height.offset(200);
    }];
    
    _diamondLabel = [[UILabel alloc] init];
    _diamondLabel.font = [UIFont systemFontOfSize:24];
    _diamondLabel.textColor = [UIColor whiteColor];
    [_diamondLabel sizeToFit];
    [imageview addSubview:_diamondLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = [UIFont systemFontOfSize:24];
    _moneyLabel.textColor = [UIColor whiteColor];
    [_moneyLabel sizeToFit];
    [imageview addSubview:_moneyLabel];
    
    [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(imageview.mas_centerX);
        make.top.mas_equalTo(imageview.mas_top).offset(30);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(imageview.mas_centerX);
        make.top.mas_equalTo(_diamondLabel.mas_bottom).offset(30);
    }];
    
    UIImageView *aoImageView = [[UIImageView alloc] init];
    aoImageView.image = [UIImage imageNamed:@"goldexchangebg"];
    aoImageView.userInteractionEnabled = YES;
    [self.view addSubview:aoImageView];
    
    [aoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(imageview.mas_bottom).offset(-50);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    UIButton *cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cashBtn.backgroundColor = kNavColor;
    cashBtn.layer.cornerRadius = kCellSpace;
    [cashBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cashBtn setTitle:@"Take out the cash" forState:UIControlStateNormal];
    [cashBtn addTarget:self action:@selector(takeOutCashAction) forControlEvents:UIControlEventTouchUpInside];
    cashBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [aoImageView addSubview:cashBtn];
    
    [cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(aoImageView.mas_centerX);
        make.top.mas_equalTo(aoImageView.mas_top).offset(60);
        make.height.offset(45);
        make.width.offset(150);
    }];
    NSString *str = @"Withdrawal instructions:\n01. The minimum cash amount of 50 US dollars, the application is successful, the official staff will be 3 to 7 working days to complete the review and remittance operation\n02. iChat.ly using Western Union. Please confirm that you can receive payment through Western Union\n03. Pick up iChat.ly does not charge any fees. However, Western Union will charge remittance service fees, this part of the user needs to be borne, if the cash withdrawal costs are not enough to pay the cash withdrawal fee. Will not pass the review remittance. Deduction coupon will be refunded to Talk.ly account\n04. Western Union official website fee inquiry";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kCellSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    UILabel *miaoshuLabel = [[UILabel alloc] init];
    miaoshuLabel.textColor = k102Color;
    miaoshuLabel.font = [UIFont systemFontOfSize:12];
    miaoshuLabel.numberOfLines = 0;
    miaoshuLabel.attributedText = attributedString;
    miaoshuLabel.textAlignment = NSTextAlignmentLeft;
    [miaoshuLabel sizeToFit];
    [aoImageView addSubview:miaoshuLabel];
    [miaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(aoImageView.mas_left).offset(15);
        make.right.mas_equalTo(aoImageView.mas_right).offset(-15);
        make.top.mas_equalTo(cashBtn.mas_bottom).offset(30);
        
    }];
    
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-45, kScreenWidth, 0.5)];
//    lineLabel.backgroundColor = kLineColor;
//    [self.view addSubview:lineLabel];
//
//    UILabel *exchangeLabel = [[UILabel alloc] init];
//    exchangeLabel.textColor = kNavColor;
//    exchangeLabel.font = [UIFont systemFontOfSize:18];
//    exchangeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigUSdollar" bounds:CGRectMake(0, -5, 25, 25) str:@"Gold exchange"];
//    exchangeLabel.userInteractionEnabled = YES;
//    exchangeLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:exchangeLabel];
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exchangeAction:)];
//    [exchangeLabel addGestureRecognizer:tap];
//
//    [exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.top.mas_equalTo(lineLabel.mas_bottom);
//        make.bottom.mas_equalTo(self.view.mas_bottom);
//    }];
}

#pragma mark - 获取数据
//获取个人财产
- (void)loadWalletData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Withdraw/get_withdraw_info" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            _diamondLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigdiamond" bounds:CGRectMake(0, -3, 25, 20) str:[NSString stringWithFormat:@"%ld",[diction[@"coupon_total"] integerValue]]];
            _moneyLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-whitebigUSdollar" bounds:CGRectMake(0, -3, 25, 25) str:[NSString stringWithFormat:@"%.2f",[diction[@"can_withdraw_money"] floatValue]]];
            _coupon = [diction[@"can_withdraw_money"] floatValue];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark - 点击事件
- (void)takeOutCashAction {
    if (_coupon >= 10.00) {
        TakecashOutViewController *cashVC = [[TakecashOutViewController alloc] init];
        [self.navigationController pushViewController:cashVC animated:YES];
    }else {
        [DataService toastWithMsg:@"Balance not enough"];
    }
}
- (void)exchangeAction:(UIGestureRecognizer *)sender {
    
    ExchangeGoldViewController *vc = [[ExchangeGoldViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
