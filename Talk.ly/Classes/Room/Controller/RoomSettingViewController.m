//
//  RoomSettingViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/18.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomSettingViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "SettingsViewController.h"
#import "DataService.h"
#import <MBProgressHUD.h>
#import "RoomViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import "WYFileManager.h"

@interface RoomSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *settingTableview;
@property(nonatomic,strong)UILabel *rightNameLabel;
@property(nonatomic,strong)UILabel *rightIntroduceLabel;
@property(nonatomic,strong)UILabel *rightTopicLabel;
@end

@implementation RoomSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Room Settings";
    
    [self.settingTableview reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    _settingTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _settingTableview.delegate = self;
    _settingTableview.dataSource = self;
    _settingTableview.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_settingTableview];
}

#pragma mark - 点击事件
- (BOOL)navigationShouldPopOnBackButton {
    RoomViewController *roomVC = nil;
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[RoomViewController class]]) {
            roomVC = (RoomViewController *)VC;
            NSDictionary *roomDic = [WYFileManager getCustomObjectWithKey:@"roomInfo"];
            
            roomVC.topView.nameLabel.text = [NSString stringWithFormat:@"%@",roomDic[@"roomName"]];
            roomVC.centerView.signatureLabel.text = [NSString stringWithFormat:@"%@",roomDic[@"roomDesc"]];
            [roomVC.centerView.topicBtn setTitle:[NSString stringWithFormat:@"%@",roomDic[@"topic"]] forState:UIControlStateNormal];
        }
    }
    return YES;
}

#pragma mark - tableview's delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"setting"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.textColor = k51Color;
        [leftLabel sizeToFit];
        [cell.contentView addSubview:leftLabel];
        
        if (indexPath.row == 0) {
            
        }
        if (indexPath.row == 0) {
            _rightNameLabel = [[UILabel alloc] init];
            _rightNameLabel.font = [UIFont systemFontOfSize:16];
            _rightNameLabel.textColor = k51Color;
            _rightNameLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_rightNameLabel];
            [_rightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(cell.contentView.mas_right).offset(-kCellSpace);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                make.left.mas_equalTo(leftLabel.mas_right).offset(30);
                make.height.offset(15);
            }];
        }else if (indexPath.row == 1) {
            _rightIntroduceLabel = [[UILabel alloc] init];
            _rightIntroduceLabel.font = [UIFont systemFontOfSize:16];
            _rightIntroduceLabel.textColor = k51Color;
            _rightIntroduceLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_rightIntroduceLabel];
            [_rightIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(cell.contentView.mas_right).offset(-kCellSpace);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                make.left.mas_equalTo(leftLabel.mas_right).offset(30);
                make.height.offset(15);
            }];
        }else {
            _rightTopicLabel = [[UILabel alloc] init];
            _rightTopicLabel.font = [UIFont systemFontOfSize:16];
            _rightTopicLabel.textColor = k51Color;
            _rightTopicLabel.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_rightTopicLabel];
            [_rightTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(cell.contentView.mas_right).offset(-kCellSpace);
                make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                make.left.mas_equalTo(leftLabel.mas_right).offset(30);
                make.height.offset(15);
            }];
        }
        
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(cell.contentView.mas_left).offset(15);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        }];
        
        if (indexPath.row == 0) {
            leftLabel.text = @"Nickname";
        }else if (indexPath.row == 1) {
            leftLabel.text = @"Room Introduction";

        }else {
            leftLabel.text = @"Room Lable";
        }
    }
    NSDictionary *roomDic = [WYFileManager getCustomObjectWithKey:@"roomInfo"];
    _rightNameLabel.text = [NSString stringWithFormat:@"%@",roomDic[@"roomName"]];
    _rightIntroduceLabel.text = [NSString stringWithFormat:@"%@",roomDic[@"roomDesc"]];
    _rightTopicLabel.text = [NSString stringWithFormat:@"%@",roomDic[@"topic"]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DataService changeReturnButton:self];
    
    NSDictionary *dic = [WYFileManager getCustomObjectWithKey:@"roomInfo"];
    
    SettingsViewController *setVC = [[SettingsViewController alloc] init];
    if (indexPath.row == 1) {
        setVC.type = 1;
        setVC.text = [NSString stringWithFormat:@"%@",dic[@"roomDesc"]];
    }else if (indexPath.row == 0) {
        setVC.type = 0;
        setVC.text = [NSString stringWithFormat:@"%@",dic[@"roomName"]];
    }else {
        setVC.type = 2;
        setVC.text = [NSString stringWithFormat:@"%@",dic[@"topic"]];
    }
    
    [self.navigationController pushViewController:setVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
