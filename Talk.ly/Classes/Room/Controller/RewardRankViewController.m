
//
//  RewardRankViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/20.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RewardRankViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "TopthreeTableViewCell.h"
#import "RankTableViewCell.h"
#import <MBProgressHUD.h>

@interface RewardRankViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *rankTV;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSArray *rankArr;
@end

@implementation RewardRankViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Rank";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [DataService changeReturnButton:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _rankArr = [NSArray array];
    _rankTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _rankTV.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_rankTV];
    _rankTV.delegate = self;
    _rankTV.dataSource = self;
    
    MJWeakSelf;
    _rankTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadRankData];
    }];
    [self loadRankData];
}

#pragma mark - 数据
- (void)loadRankData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic = @{@"user_id":self.userid,@"page":@(self.page),@"limit":@"50"};
    [DataService postWithURL:@"rest3/v1/Livechatroom/getContributeRank" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *arr = data[@"data"];
            _rankArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
            [_rankTV reloadData];
            if (self.page == 1) {
                [_rankTV.mj_header endRefreshing];
                [_rankTV.mj_footer endRefreshing];
            }else {
                if (_rankArr.count) {
                    [_rankTV.mj_footer endRefreshing];
                }else {
                    [_rankTV.mj_footer endRefreshingWithNoMoreData];
                }
            }
            if (_rankArr.count && !_rankTV.mj_footer) {
                MJWeakSelf;
                _rankTV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    weakSelf.page++;
                    [weakSelf loadRankData];
                }];
            }
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMsg:error.description];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rankArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 3) {
        return 120;
    }else {
        return 60;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 3) {
    
            TopthreeTableViewCell *cell = [[TopthreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"top"];
            cell.model = self.rankArr[indexPath.row];
        
            if (indexPath.row == 0) {
                cell.rankbgImageView.image = [UIImage imageNamed:@"first"];
            }else if (indexPath.row == 1) {
                cell.rankbgImageView.image = [UIImage imageNamed:@"second"];
            }else {
                cell.rankbgImageView.image = [UIImage imageNamed:@"third"];
            }
        return cell;
    }else {
        RankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rank"];
        if (!cell) {
            
            cell = [[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rank"];
            cell.model = self.rankArr[indexPath.row];
            cell.topLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        }
        return cell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
