//
//  NewGiftsViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/28.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "NewGiftsViewController.h"
#import "CommonPrex.h"
#import <MJExtension.h>
#import "DataService.h"
#import "AccountManager.h"
#import "NoticeGiftModel.h"
#import "GiftModel.h"
#import "NewGiftTableViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "DefaultView.h"

@interface NewGiftsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *giftTableView;
@property(nonatomic,strong)NSMutableArray *noticeGiftMarr;
@property(nonatomic,strong)DefaultView *defatView;

@end

@implementation NewGiftsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"New Gifts";
    [self.view addSubview:self.giftTableView];
    [self getNoticeGiftData];
}

- (UITableView *)giftTableView {
    if (!_giftTableView) {
        
        _giftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _giftTableView.delegate = self;
        _giftTableView.dataSource = self;
        _giftTableView.showsVerticalScrollIndicator = NO;
        _giftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _giftTableView.tableFooterView = [[UIView alloc] init];
        _giftTableView.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(getNoticeGiftData)];
    }
    return _giftTableView;
}

- (DefaultView *)defatView {
    if (!_defatView) {
        _defatView = [[DefaultView alloc] initWithFrame:self.view.bounds];
        _defatView.imageview.image = [UIImage imageNamed:@"newgifts"];
        _defatView.tipsLabel.text = @"You have no gift yet";
        [_defatView.coverControl addTarget:self action:@selector(getNoticeGiftData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defatView;
}

#pragma mark - 获取数据
- (void)getNoticeGiftData {
    
    MBProgressHUD *hud = nil;
    if (_giftTableView.mj_header.refreshing == NO) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"type":@"gift",@"page":@1,@"limit":@100};
    [DataService postWithURL:@"rest3/v1/Notice/get_notice_list" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        [_giftTableView.mj_header endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"notice_list"];
            _noticeGiftMarr = [NoticeGiftModel mj_objectArrayWithKeyValuesArray:arr];
            if (_noticeGiftMarr.count == 0) {
                [self.view addSubview:self.defatView];
            }else {
                if (_defatView) {
                    
                    [_defatView removeFromSuperview];
                    _defatView = nil;
                }
            }
            for (NoticeGiftModel *model in _noticeGiftMarr) {
                for (GiftModel *giftmodel in [AccountManager sharedAccountManager].giftModelMarr) {
                    if ([model.gift_info.gift_key isEqualToString:giftmodel.gift_key]) {
                        model.gift_info.gift_image_key = giftmodel.gift_image_key;
                    }
                }
            }
            [_giftTableView reloadData];
        }else {
            [self.view addSubview:self.defatView];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [_giftTableView.mj_header endRefreshing];
        [self.view addSubview:self.defatView];
    }];
}

#pragma mark - tableview's delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _noticeGiftMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newgift"];
    if (!cell) {
        
        cell = [[NewGiftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newgift"];
    }
    cell.noticeGiftModel = _noticeGiftMarr[indexPath.row];
    
    cell.thankBtn.tag = 300+indexPath.row;
    cell.backGiftBtn.tag = 400+indexPath.row;
    
    [cell.thankBtn addTarget:self action:@selector(thankBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.backGiftBtn addTarget:self action:@selector(backGiftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

#pragma mark - 点击事件
- (void)thankBtnAction:(UIButton *)sender {
    
    NoticeGiftModel *model = _noticeGiftMarr[sender.tag - 300];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"notice_id":model.notice_id};
    [DataService postWithURL:@"rest3/v1/Notice/thanks" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"Success"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Error"];
    }];
}

- (void)backGiftBtnAction:(UIButton *)sender {
    NSLog(@"%ld",sender.tag);
    NoticeGiftModel *model = _noticeGiftMarr[sender.tag - 400];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"gift_key":model.gift_info.gift_key,@"gift_count":@"1",@"to_user_id":model.send_user.user_id};
    [DataService postWithURL:@"rest3/v1/Gift/give_gift" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"Success"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Error"];
    }];
}
@end
