//
//  FriendRequestViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FriendRequestViewController.h"
#import "FriendRequestTableViewCell.h"
#import "CommonPrex.h"
#import "YPHeaderFooterView.h"
#import "DataService.h"
#import <MJExtension.h>
#import "AccountManager.h"
#import "UserModel.h"
#import "ProfileViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "DefaultView.h"


@interface FriendRequestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *friendRequestTV;
@property(nonatomic,strong)NSMutableArray *fansMarr;
@property(nonatomic,strong)NSMutableArray *friendMarr;
@property(nonatomic,strong)DefaultView *defaultView;

@end

@implementation FriendRequestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Friend Request";
    self.view.backgroundColor = [UIColor whiteColor];
    _friendRequestTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _friendRequestTV.showsVerticalScrollIndicator = NO;
    _friendRequestTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _friendRequestTV.rowHeight = 90;
    _friendRequestTV.delegate = self;
    _friendRequestTV.dataSource = self;
    [_friendRequestTV registerClass:[YPHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.view addSubview:_friendRequestTV];
    _friendRequestTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(getFrienRequestAndFansdData)];
    
    [self getFrienRequestAndFansdData];
}

- (DefaultView *)defaultView {
    if (!_defaultView) {
        
        _defaultView = [[DefaultView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _defaultView.imageview.image = [UIImage imageNamed:@"friendrequest"];
        _defaultView.tipsLabel.text = @"You don't have a friend request yet";
        [_defaultView.coverControl addTarget:self action:@selector(getFrienRequestAndFansdData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultView;
}

#pragma mark - 数据获取
- (void)getFrienRequestAndFansdData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"type":@"follower",@"page":@1,@"limit":@100};
    [DataService postWithURL:@"rest3/v1/Notice/get_notice_list" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        [_friendRequestTV.mj_header endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *followersArr = data[@"data"][@"followers"];
            NSArray *friendsArr = data[@"data"][@"friends"];
            _fansMarr = [UserModel mj_objectArrayWithKeyValuesArray:followersArr];
            _friendMarr = [UserModel mj_objectArrayWithKeyValuesArray:friendsArr];
            
            if (_fansMarr.count == 0 || _friendMarr.count == 0) {
                [self.view addSubview:self.defaultView];
            }else {
                if (_defaultView) {
                    [_defaultView removeFromSuperview];
                    _defaultView = nil;
                }
            }
            [_friendRequestTV reloadData];
        }else {
            [self.view addSubview:self.defaultView];
        }
    } failure:^(NSError *error) {
        [_friendRequestTV.mj_header endRefreshing];
        [hud hideAnimated:YES];
        [self.view addSubview:self.defaultView];
    }];
}

//添加好友
- (void)addFriendData:(NSInteger)index {
    UserModel *model = _fansMarr[index];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"star_user_id":model.user_id};
    [DataService postWithURL:@"rest3/v1/follow/follow" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [_fansMarr removeObjectAtIndex:index];
            [_friendMarr addObject:model];
            [_friendRequestTV reloadData];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Follow Error"];
    }];
}

#pragma mark - taleview's datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _fansMarr.count;
    }else {
        return _friendMarr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSString *str = [NSString stringWithFormat:@"%ld",indexPath.section];
        FriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            
            cell = [[FriendRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.followBtn.tag = indexPath.row;
        [cell.followBtn addTarget:self action:@selector(followBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.fansModel = _fansMarr[indexPath.row];
        return cell;
    }else {
        NSString *str = [NSString stringWithFormat:@"%ld",indexPath.section];
        FriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            
            cell = [[FriendRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.friendModel = _friendMarr[indexPath.row];
        return cell;
    }
    
}

#pragma mark - tableview's delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (_fansMarr.count == 0) {
            return [[UIView alloc] init];
        }else {
            YPHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
            header.text = @"New Request";
            return header;
        }
    }else {
        if (_friendMarr.count > 0) {
            YPHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
            header.text = @"Processed Request";
            return header;
        }else {
            return [[UIView alloc] init];
        }
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_fansMarr.count > 0) {
            return 45;
        }else {
            return 0.1;
        }
    }else {
        if (_friendMarr.count > 0) {
            return 45;
        }else {
            return 0.1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//为了上面的方法有效果 ios11 必须实现下面方法
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileViewController *personVC = [[ProfileViewController alloc] init];
    if (indexPath.section == 0) {
        UserModel *model = _fansMarr[indexPath.row];
        personVC.uid = model.user_id;
        personVC.type = 2;
        
    }else {
        UserModel *model = _friendMarr[indexPath.row];
        personVC.uid = model.user_id;
    }
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - touch
- (void)followBtnClick:(UIButton *)sender {
    [self addFriendData:sender.tag];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
