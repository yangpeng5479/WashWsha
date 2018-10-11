//
//  MessageViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableView.h"
#import "CommonPrex.h"
#import "FriendRequestViewController.h"
#import "DataService.h"
#import "NewGiftsViewController.h"
#import <MJExtension.h>
#import "NoticeSystemModel.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface MessageViewController ()<UITableViewDelegate>

@property(nonatomic,strong)MessageTableView *messageTV;
@property(nonatomic,strong)NSMutableArray *systemNoticeMarr;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Message";
    [self setupUI];
    [self getNoticeData];
}

- (void)setupUI {
    
    _messageTV = [[MessageTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _messageTV.delegate = self;
    _messageTV.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(getNoticeData)];
    [self.view addSubview:_messageTV];
}

#pragma mark - 获取消息
- (void)getNoticeData {
    
    MBProgressHUD *hud = nil;
    if (_messageTV.mj_header.refreshing == NO) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"Loading...";
    }
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"page":@1,@"limit":@100,@"type":@"sys"};
    [DataService postWithURL:@"rest3/v1/Notice/get_notice_list" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        [_messageTV.mj_header endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"notice_list"];
            _systemNoticeMarr = [NoticeSystemModel mj_objectArrayWithKeyValuesArray:arr];
            _messageTV.dataArr = _systemNoticeMarr.copy;
            [_messageTV reloadData];
        }
    } failure:^(NSError *error) {
        [_messageTV.mj_header endRefreshing];
        if (hud) {
            [hud hideAnimated:YES];
        }
        [DataService toastWithMessage:@"Error"];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 70;
    }else {
        NoticeSystemModel *model = _systemNoticeMarr[indexPath.row-2];

        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:model.content];
        
        NSRange allRange = [model.content rangeOfString:model.content];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:allRange];
        
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor]range:allRange];
        
        CGFloat titleHeight;
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        // 获取label的最大宽度
        CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX)options:options context:nil];
        
        titleHeight = ceilf(rect.size.height);
        
        return titleHeight + 90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DataService changeReturnButton:self];
    if (indexPath.row == 0) {
        FriendRequestViewController *friendVC = [[FriendRequestViewController alloc] init];
        friendVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendVC animated:YES];
    }else if (indexPath.row == 1) {
        NewGiftsViewController *newGiftVC = [[NewGiftsViewController alloc] init];
        newGiftVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newGiftVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
