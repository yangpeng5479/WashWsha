//
//  FriendsViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FriendsViewController.h"
#import "CommonPrex.h"
#import "FriendsTableView.h"
#import "DataService.h"
#import <MJExtension.h>
#import "UserModel.h"
#import <MBProgressHUD.h>

@interface FriendsViewController ()

@property(nonatomic,strong)FriendsTableView *friendTV;
@property(nonatomic,strong)NSMutableArray *friendsArr;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Friends";
    [self loadFriendsData];
    [self setupUI];
}

- (void)setupUI {
    
    _friendTV = [[FriendsTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _friendTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(loadFriendsData)];
    [self.view addSubview:_friendTV];
}

#pragma mark - DATA
//获取朋友列表
- (void)loadFriendsData {
    MBProgressHUD *hud;
    if (_friendTV.mj_header.isRefreshing == NO) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }
    NSDictionary *dict = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/follow/get_friend_list" type:1 params:dict fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if (hud) {
           [hud hideAnimated:YES];
        }
        [_friendTV.mj_header endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"friend_list"];
            _friendsArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
            _friendTV.dataArr = _friendsArr;
            [_friendTV reloadData];
        }
    } failure:^(NSError *error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        [_friendTV.mj_header endRefreshing];
        [DataService toastWithMessage:@"Error"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
