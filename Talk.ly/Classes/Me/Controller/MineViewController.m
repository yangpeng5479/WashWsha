//
//  MineViewController.m
//  video
//
//  Created by 杨鹏 on 2018/5/15.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableView.h"
#import <UIViewController+MMDrawerController.h>
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import <MBProgressHUD.h>
#import "WalletModel.h"
#import <MJExtension.h>
#import "WYFileManager.h"
#import <UIImageView+WebCache.h>
#import "ProfileViewController.h"
#import "YpTabbarController.h"
#import "HomeViewController.h"
#import "GoldViewController.h"
#import "RechargeViewController.h"
#import "DiamondViewController.h"
#import "InvitecodeViewController.h"
#import "AboutMeViewController.h"
#import "UserSettingViewController.h"
#import "FollowingViewController.h"
#import "FansViewController.h"
#import "IncomeViewController.h"

@interface MineViewController ()<UITableViewDelegate>

@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)MineTableView *mineTableview;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *idLabel;
@property(nonatomic,strong)UILabel *followLabel; //已关注
@property(nonatomic,strong)UILabel *friends; //互相关注

@end

@implementation MineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMeData];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _mineTableview = [[MineTableView alloc] initWithFrame:CGRectMake(0, 20, kDrawerWidth, kScreenHeight) style:UITableViewStylePlain];
    _mineTableview.delegate = self;
    [self.view addSubview:_mineTableview];
}

#pragma mark - 数据
//获取个人详情
- (void)loadMeData {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"Loading...";
    NSDictionary *dic =@{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/user/get_my_info" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"ME:%@",data);
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"user_info"];
            UserModel *model = [UserModel mj_objectWithKeyValues:diction];
            [WYFileManager setCustomObject:model forKey:@"userModel"];
            
            [self loadWalletData];
            [_mineTableview reloadData];
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
    }];
}

//获取个人财产
- (void)loadWalletData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Wallet/get_wallet" type:1 params:dic fileData:nil success:^(id data) {
        [_hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            WalletModel *walletModel = [WalletModel mj_objectWithKeyValues:diction];
            
            _mineTableview.silverLabel.text = [NSString stringWithFormat:@"%ld",[walletModel.wallet[@"coin_total"] integerValue]];;
            _mineTableview.goldLabel.text = [NSString stringWithFormat:@"%ld",[walletModel.wallet[@"diamond_total"] integerValue]];
            _mineTableview.incomeLabel.text = [NSString stringWithFormat:@"$ %.2f",walletModel.max_withdraw];
            [_mineTableview reloadData];
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
    }];
}


#pragma mark - 点击事件
//已关注
- (void)followingAction {
    YpTabbarController *tabbarVC = (YpTabbarController *)self.mm_drawerController.centerViewController;
    UINavigationController *nav = tabbarVC.viewControllers[0];
    
    FollowingViewController *followVC = [[FollowingViewController alloc] init];
    followVC.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:followVC animated:YES];
    //push成功 关闭抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
//互相关注
- (void)followersAction {
    YpTabbarController *tabbarVC = (YpTabbarController *)self.mm_drawerController.centerViewController;
    UINavigationController *nav = tabbarVC.viewControllers[0];
    FansViewController *friendVC = [[FansViewController alloc] init];
    [nav pushViewController:friendVC animated:YES];
    //push成功 关闭抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}
#pragma mark - 代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDrawerWidth, 200)];
        view.backgroundColor = [UIColor whiteColor];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 30;
        _iconImageView.layer.masksToBounds = YES;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
        [view addSubview:_iconImageView];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:17];
        _nameLabel.text = model.name;
        _nameLabel.textColor = k51Color;
        [_nameLabel sizeToFit];
        [view addSubview:_nameLabel];
        
        _idLabel = [[UILabel alloc] init];
        _idLabel.font = [UIFont systemFontOfSize:13];
        _idLabel.textColor = k153Color;
        _idLabel.text = [NSString stringWithFormat:@"ID:%@",model.user_id];
        [_idLabel sizeToFit];
        [view addSubview:_idLabel];
        
        _followLabel = [[UILabel alloc] init];
        _followLabel.font = [UIFont systemFontOfSize:13];
        _followLabel.textColor = k153Color;
        _followLabel.text = [NSString stringWithFormat:@"%ld Following",[model.follow_info[@"star_count"] integerValue]];
        [_followLabel sizeToFit];
        [view addSubview:_followLabel];
        _followLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingAction)];
        [_followLabel addGestureRecognizer:tap1];
        
        _friends = [[UILabel alloc] init];
        _friends.font = [UIFont systemFontOfSize:13];
        _friends.textColor = k153Color;
        _friends.text = [NSString stringWithFormat:@"%ld Followers",[model.follow_info[@"follower_count"] integerValue]];
        [_friends sizeToFit];
        [view addSubview:_friends];
        _friends.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followersAction)];
        [_friends addGestureRecognizer:tap2];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.top.mas_equalTo(view.mas_top).offset(15);
            make.width.height.equalTo(@60);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(view.mas_left).offset(15);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(kSpace);
        }];
        [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(view.mas_right).offset(-kSpace);
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        }];
        [_followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kSpace);
        }];
        [_friends mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(self.followLabel.mas_right).offset(kSpace);
            make.centerY.mas_equalTo(self.followLabel.mas_centerY);
        }];
        
        return view;
    }else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDrawerWidth, 20)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kDrawerWidth-20, 0.3)];
        line.backgroundColor = kLineColor;
        [view addSubview:line];
        return view;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 150;
    }else {
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YpTabbarController *tabbarVC = (YpTabbarController *)self.mm_drawerController.centerViewController;
    UINavigationController *nav = tabbarVC.viewControllers[0];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ProfileViewController *vc = [[ProfileViewController alloc] init];
            vc.type = 1;
            vc.uid = [AccountManager sharedAccountManager].userID;
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }else if (indexPath.row == 1) {
            GoldViewController *goldVC = [[GoldViewController alloc] init];
            goldVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:goldVC animated:YES];
        }else if (indexPath.row == 2) {
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            rechargeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:rechargeVC animated:YES];
        }else {
            IncomeViewController *incomeVC = [[IncomeViewController alloc] init];
            incomeVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:incomeVC animated:YES];
        }
    }else {
        if (indexPath.row == 0) {
            UserSettingViewController *vc= [[UserSettingViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 1) {
            InvitecodeViewController *inviteVC = [[InvitecodeViewController alloc] init];
            inviteVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:inviteVC animated:YES];
            
        }else if (indexPath.row == 2) {
            AboutMeViewController *aboutVC = [[AboutMeViewController alloc] init];
            aboutVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:aboutVC animated:YES];
        }
    }
    //push成功 关闭抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {

        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
