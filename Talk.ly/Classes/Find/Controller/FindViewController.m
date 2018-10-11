//
//  FindViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FindViewController.h"
#import "LevelTableView.h"
#import "WealthTableView.h"
#import "CharmTableView.h"
#import "RoomTableView.h"
#import "DataService.h"
#import "UserModel.h"
#import <MJExtension/MJExtension.h>
#import <MBProgressHUD.h>
#import <MJRefresh.h>
#import "AccountManager.h"
#import "RoomModel.h"
#import "ChatRoomModel.h"
#import "RoomViewController.h"
#import "ProfileViewController.h"

@interface FindViewController ()<UITableViewDelegate,TYTabPagerViewDelegate>

@property(nonatomic,strong)LevelTableView *levelTV;


@property(nonatomic,strong)WealthTableView *wealthTV;
@property(nonatomic,strong)CharmTableView *charmTV;
@property(nonatomic,strong)RoomTableView *roomTV;
@property(nonatomic,strong)NSMutableArray *levelRankArr;
@property(nonatomic,strong)NSMutableArray *wealthRankArr;
@property(nonatomic,strong)NSMutableArray *charmRankArr;
@property(nonatomic,strong)NSMutableArray *roomRankArr;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,assign)NSInteger index;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleArr = [NSArray arrayWithObjects:@"Level",@"Wealth",@"Charm",@"Room", nil];
    self.type = @"active";
    [self loadRankData];
    [self.pagerView reloadData];
}

//获取用户排行
- (void)loadRankData {
    MBProgressHUD *hud;
    if (_index == 0 && _levelTV.mj_header.refreshing == NO) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }else if (_index == 1 && _wealthTV.mj_header.refreshing == NO){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }else if (_index == 2 && _charmTV.mj_header.refreshing == NO) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }
    
    NSDictionary *dic =@{@"type":_type,@"page":@1,@"limit":@100};
    [DataService postWithURL:@"rest3/v1/top/user_ranking" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if (hud) {
           [hud hideAnimated:YES];
        }
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"user_ranking"];

            if ([_type isEqualToString:@"active"]) {
                _levelRankArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
                _levelTV.dataArr = _levelRankArr;
                [_levelTV reloadData];
                [_levelTV.mj_header endRefreshing];
            }else if ([_type isEqualToString:@"wealth"]) {
                _wealthRankArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
                _wealthTV.dataArr = _wealthRankArr;
                [_wealthTV reloadData];
                [_wealthTV.mj_header endRefreshing];
            }else {
                _charmRankArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
                _charmTV.dataArr = _charmRankArr;
                [_charmTV reloadData];
                [_charmTV.mj_header endRefreshing];
            }
        }
    } failure:^(NSError *error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        [_levelTV.mj_header endRefreshing];
        [_wealthTV.mj_header endRefreshing];
        [_charmTV.mj_header endRefreshing];
    }];
}

- (void)loadRoomRankData {
    MBProgressHUD *hud;
    if (_roomTV.mj_header.refreshing == NO) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }
    NSDictionary *dic = @{@"type":@"active",@"page":@1,@"limit":@100,@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/top/chatroom_ranking" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"chatroom_list"];
            _roomRankArr = [RoomModel mj_objectArrayWithKeyValuesArray:arr];
            _roomTV.dataArr = _roomRankArr.copy;
            [_roomTV reloadData];
            [_roomTV.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        [_roomTV.mj_header endRefreshing];
        [DataService toastWithMessage:@"Error"];
    }];
}

- (void)loadEnterRoomData:(RoomModel *)roomModel {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":roomModel.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/enterChatroom" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] isEqual:@40001]) {
            //房间已关闭
            [DataService toastWithMessage:@"Room Closed"];
        }else if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            ChatRoomModel *chatModel = [ChatRoomModel mj_objectWithKeyValues:diction];
            
            if ([chatModel.chatroom.enter_limit isEqualToString:@"password"]) {
                //密码进入
                UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"Enter password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Please enter password";
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *passTF = passAlert.textFields.firstObject;
                    if ([chatModel.chatroom.enter_pass isEqualToString:passTF.text]) {
                        RoomViewController *roomVC = [[RoomViewController alloc] init];
                        roomVC.hidesBottomBarWhenPushed = YES;
                        roomVC.chatModel = chatModel;
                        roomVC.type = 3;
                        [self.navigationController pushViewController:roomVC animated:YES];
                    }
                }];
                [passAlert addAction:cancel];
                [passAlert addAction:ok];
                [self presentViewController:passAlert animated:YES completion:nil];
            }else {
                RoomViewController *roomVC = [[RoomViewController alloc] init];
                roomVC.hidesBottomBarWhenPushed = YES;
                roomVC.chatModel = chatModel;
                roomVC.type = 3;
                [self.navigationController pushViewController:roomVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Error"];
    }];
}

//tytabpageview dataSource
- (UIView *)tabPagerView:(TYTabPagerView *)tabPagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    switch (index) {
        case 0:
        {
            _type = @"active";
            _levelTV = [[LevelTableView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index] style:UITableViewStylePlain];
            _levelTV.delegate = self;
            _levelTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(loadRankData)];
            return _levelTV;
        }
            break;
        case 1:
        {
            _type = @"wealth";
            _wealthTV = [[WealthTableView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index] style:UITableViewStylePlain];
            _wealthTV.delegate = self;
            _wealthTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(loadRankData)];
            return _wealthTV;
        }
            break;
        case 2:
        {
            _type = @"charm";
            _charmTV = [[CharmTableView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index] style:UITableViewStylePlain];
            _charmTV.delegate = self;
            _charmTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(loadRankData)];
            return _charmTV;
        }
            break;
        case 3:
        {
            _roomTV = [[RoomTableView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index] style:UITableViewStylePlain];
            _roomTV.delegate = self;
            _roomTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(loadRoomRankData)];
            return _roomTV;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tabPagerView:(TYTabPagerView *)tabPagerView willAppearView:(UIView *)view forIndex:(NSInteger)index {
    _index = index;
    if (index == 1) {
        if (!_wealthRankArr) {
            _type = @"wealth";
            [self loadRankData];
        }
    }else if (index == 2){
        if (!_charmRankArr) {
            _type = @"charm";
            [self loadRankData];
        }
    }else if (index == 3) {
        [self loadRoomRankData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _roomTV) {
        RoomModel *model = _roomRankArr[indexPath.row];
        [self loadEnterRoomData:model];
    }else {
        UserModel *model;
        if (tableView == _levelTV) {
            model = _levelRankArr[indexPath.row];
        }else if (tableView == _wealthTV) {
            model = _wealthRankArr[indexPath.row];
        }else {
            model = _charmRankArr[indexPath.row];
        }
        ProfileViewController *detailVC = [[ProfileViewController alloc] init];
        detailVC.uid = model.user_id;
        detailVC.type = 2;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
