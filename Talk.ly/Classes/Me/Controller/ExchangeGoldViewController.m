//
//  ExchangeGoldViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/25.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ExchangeGoldViewController.h"
#import "AccountManager.h"
#import "DataService.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "YPHeaderFooterView.h"
#import "GoldModel.h"
#import <MJExtension.h>

@interface ExchangeGoldViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *goldTableview;
@property(nonatomic,strong)NSMutableArray *payMarr;
@property(nonatomic,strong)NSMutableArray *getGoldMarr;
@property(nonatomic,strong)NSMutableArray *modelMarr;
@property(nonatomic,assign)NSInteger gold;

@end

@implementation ExchangeGoldViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadWalletData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Gold";
    _payMarr = [NSMutableArray array];
    _getGoldMarr = [NSMutableArray array];
    
    [self.view addSubview:self.goldTableview];
}

#pragma mark - 更新UI
//懒加载
- (UITableView *)goldTableview {
    if (!_goldTableview) {
        _goldTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _goldTableview.backgroundColor = [UIColor whiteColor];
        _goldTableview.showsVerticalScrollIndicator = NO;
        _goldTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goldTableview.dataSource = self;
        _goldTableview.delegate = self;
        [_goldTableview registerClass:[YPHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    }
    return _goldTableview;
}
- (void)setupUI {
    
}

#pragma mark - 获取数据
//获取官方兑换列表
- (void)loadWalletData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Exchange/get_official_exchange_coupon" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSLog(@"%@",data);
            _gold = [data[@"data"][@"wallet"][@"diamond_total"] integerValue];
            NSArray *arr = data[@"data"][@"exchange_items"];
            _modelMarr = [GoldModel mj_objectArrayWithKeyValuesArray:arr];
            
            [_modelMarr sortUsingComparator:^NSComparisonResult(GoldModel *obj1, GoldModel *obj2) {
                if (obj2.order_no < obj1.order_no) {
                    return NSOrderedDescending;
                }else {
                    return NSOrderedAscending;
                }
            }];
            _getGoldMarr = [NSMutableArray array];
            _payMarr = [NSMutableArray array];
            for (GoldModel *model in _modelMarr) {
                
                [_getGoldMarr addObject:model.get_diamond_total];
                [_payMarr addObject:model.pay_coupon_total];
            }
            [_goldTableview reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc] init];
    }else {
        YPHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
        // 覆盖文字
        header.text = @"Diamond Exchange";
        return header;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.01;
    }else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//为了上面的方法有效果 ios11 必须实现下面方法
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 200;
    }else {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else {
        return _getGoldMarr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gold_h"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.layer.cornerRadius = kCellSpace;
        imageview.layer.masksToBounds = YES;
        imageview.image = [UIImage imageNamed:@"goldcard"];
        [cell addSubview:imageview];
        
        UILabel *goldLabel = [[UILabel alloc] init];
        goldLabel.font = [UIFont systemFontOfSize:24];
        goldLabel.textColor = [UIColor whiteColor];
        goldLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigUSdollar" bounds:CGRectMake(0, -2, 25, 25) str:[NSString stringWithFormat:@"%ld",_gold]];
        [goldLabel sizeToFit];
        [imageview addSubview:goldLabel];
        
        UIImageView *aoImageView = [[UIImageView alloc] init];
        aoImageView.image = [UIImage imageNamed:@"exchangeforgoldbg"];
        [cell addSubview:aoImageView];
        
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(cell.mas_left).offset(35);
            make.right.mas_equalTo(cell.mas_right).offset(-35);
            make.top.mas_equalTo(cell.mas_top).offset(20);
            make.bottom.mas_equalTo(cell.mas_bottom);
        }];
        [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(imageview.mas_centerX);
            make.top.mas_equalTo(imageview.mas_top).offset(60);
        }];
        [aoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(cell.mas_left);
            make.right.mas_equalTo(cell.mas_right);
            make.bottom.mas_equalTo(imageview.mas_bottom).offset(-0.5);
            make.height.offset(50);
        }];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 199.5, kScreenWidth, 0.5)];
        lineLabel.backgroundColor = kLineColor;
        [cell addSubview:lineLabel];
        
        return cell;
        
    }else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gold"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //图片
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.image = [UIImage imageNamed:@"icon-USdollar"];
        [cell addSubview:iconImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(cell.mas_left).offset(kSpace);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        
        //显示金额
        UILabel *coinLabel = [[UILabel alloc] init];
        [coinLabel sizeToFit];
        coinLabel.font = [UIFont systemFontOfSize:15];
        coinLabel.text = [NSString stringWithFormat:@"%@ Gold",[_getGoldMarr objectAtIndex:indexPath.row]];
        coinLabel.textColor = k102Color;
        [cell addSubview:coinLabel];
        
        [coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(iconImageView.mas_right).offset(kSpace);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        
        //支付按钮
        UIButton *payBtn = [[UIButton alloc] init];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [payBtn setTitleColor:kNavColor forState:UIControlStateNormal];
        payBtn.backgroundColor = [UIColor whiteColor];
        [payBtn setTitle:[NSString stringWithFormat:@"%@ Diamond",_payMarr[indexPath.row]] forState:UIControlStateNormal];
        [payBtn.titleLabel sizeToFit];
        payBtn.tag = 700+indexPath.row;
        payBtn.layer.cornerRadius = 15;
        payBtn.layer.borderColor = kNavColor.CGColor;
        payBtn.layer.borderWidth = 1;
        [payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:payBtn];
        
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-10);
            make.width.offset(150);
            make.height.offset(30);
        }];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, 0.5)];
        lineLabel.backgroundColor = kLineColor;
        [cell addSubview:lineLabel];
        
        return cell;
    }
}


#pragma mark - 点击事件
- (void)payAction:(UIButton *)sender {
    GoldModel *model = _modelMarr[sender.tag-700];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"official_exchange_item_id":model.official_exchange_coupon_id};
    [DataService postWithURL:@"rest3/v1/Exchange/exchange_coupon_to_diamond" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"Exchange Success"];
            [self loadWalletData];
        }else if ([data[@"status"] integerValue] == 30006) {
            [DataService toastWithMessage:@"Insufficient balance"];
        }
    } failure:^(NSError *error) {
        
    }];
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
