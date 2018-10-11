//
//  GuardianTopViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/23.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "GuardianTopViewController.h"
#import "LevelTableView.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <MJExtension.h>
#import "ProfileViewController.h"

@interface GuardianTopViewController ()<UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *guardianArr;
@property(nonatomic,strong)LevelTableView *guardianTV;

@end

@implementation GuardianTopViewController

//守护排行
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Guardian TOP";
    [self setupUI];
    [self loadGuardianData];
}
#pragma mark - 创建UI
- (void)setupUI {
    _guardianTV = [[LevelTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _guardianTV.delegate = self;
    [self.view addSubview:_guardianTV];
}

#pragma mark - 数据获取
//获取守护排行榜
- (void)loadGuardianData {
    NSDictionary *dic = @{@"user_id":self.uid,@"page":@1,@"limit":@100};
    [DataService postWithURL:@"rest3/v1/Top/guarders" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"guarders"];
            _guardianArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
            _guardianTV.dataArr = _guardianArr;
            [_guardianTV reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserModel *model = _guardianArr[indexPath.row];
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.type = 2;
    vc.uid = model.user_id;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
