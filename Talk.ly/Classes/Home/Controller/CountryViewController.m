//
//  CountryViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CountryViewController.h"
#import "CountryRoomListTableview.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <MBProgressHUD.h>
#import <MJExtension.h>
#import "RoomModel.h"

@interface CountryViewController ()

@property(nonatomic,strong)CountryRoomListTableview *countryListTV;
@property(nonatomic,strong)NSMutableArray *roomListArr;
@end

@implementation CountryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = kNavColor;;
    self.navigationItem.title = self.countryName;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadCountryRoomListData];

    
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
    _countryListTV = [[CountryRoomListTableview alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_countryListTV];
}

#pragma mark - DATA
//国家 房间列表
- (void)loadCountryRoomListData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic =@{@"page":@1,@"limit":@20,@"country_id":self.countryID};
    [DataService postWithURL:@"rest3/v1/Country/chatroomsByCountry" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"countryList:%@",data);
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"topic_list"];
            _roomListArr = [RoomModel mj_objectArrayWithKeyValuesArray:arr];
            _countryListTV.dataArr = _roomListArr;
            [_countryListTV reloadData];
        }
        [hud hideAnimated:YES];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Error"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
