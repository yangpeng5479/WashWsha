//
//  FansViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/30.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FansViewController.h"
#import "FansTableViewCell.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <MBProgressHUD.h>

@interface FansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *friendTV;

@property(nonatomic,strong)NSMutableArray *dataSourceArr;

@property(nonatomic,assign)int page;

@end

@implementation FansViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Fans";
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    [self setupUI];
    [self requestData];
}

- (void)setupUI {
    
    _friendTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _friendTV.dataSource = self;
    _friendTV.delegate = self;
    _friendTV.backgroundColor = [UIColor clearColor];
    _friendTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _friendTV.showsVerticalScrollIndicator = NO;
    _friendTV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_friendTV];
    MJWeakSelf;
    _friendTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    _friendTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestData];
    }];
}

- (void)requestData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"page":@(self.page),@"limit":@10};
    [DataService postWithURL:@"rest3/v1/follow/get_follower_list" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        NSArray *arr = data[@"data"][@"follower_list"];
        _dataSourceArr = [FollowModel mj_objectArrayWithKeyValuesArray:arr];
        [_friendTV.mj_header endRefreshing];
        [_friendTV.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [_friendTV.mj_header endRefreshing];
        [_friendTV.mj_footer endRefreshing];
    }];
}

#pragma mark - 代理 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
    if (!cell) {
        cell = [[FansTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friend"];
        cell.unFollowBtn.tag = 1000+indexPath.row;
        [cell.unFollowBtn addTarget:self action:@selector(unfollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.model = self.dataSourceArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
