//
//  FollowingViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/30.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FollowingViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import "FollowModel.h"
#import "FollowTableViewCell.h"
#import <MBProgressHUD.h>


@interface FollowingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *followTV;

@property(nonatomic,strong)NSArray *dataSourceArr;

@property(nonatomic,assign)int page;

@end

@implementation FollowingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataService changeReturnButton:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Following";
    self.page = 1;
    [self setupUI];
    [self requestData];
}

- (void)setupUI {
    
    _followTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _followTV.dataSource = self;
    _followTV.delegate = self;
    _followTV.backgroundColor = [UIColor clearColor];
    _followTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _followTV.showsVerticalScrollIndicator = NO;
    _followTV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_followTV];
    
    MJWeakSelf;
    _followTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
    _followTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page++;
        [weakSelf requestData];
    }];
}

- (void)requestData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading";
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"page":@(self.page),@"limit":@10};
    [DataService postWithURL:@"rest3/v1/follow/get_star_list" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        NSArray *arr = data[@"data"][@"star_list"];
        _dataSourceArr = [FollowModel mj_objectArrayWithKeyValuesArray:arr];
        [_followTV.mj_header endRefreshing];
        [_followTV.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [_followTV.mj_header endRefreshing];
        [_followTV.mj_footer endRefreshing];
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
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"follow"];
    if (!cell) {
        cell = [[FollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"follow"];
        cell.unFollowBtn.tag = 500+indexPath.row;
        [cell.unFollowBtn addTarget:self action:@selector(unfollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.model = _dataSourceArr[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
