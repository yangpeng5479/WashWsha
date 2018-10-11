//
//  TakecashOutViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/10.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "TakecashOutViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface TakecashOutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *cashTableView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)UILabel *diamondLabel;
@property(nonatomic,strong)UILabel *drawLabel;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *numberTF;
@property(nonatomic,strong)UILabel *miaoshuLabel;

@end

@implementation TakecashOutViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadWalletData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Take out cash";
    self.view.backgroundColor = [UIColor whiteColor];
    _titleArr = @[@"Point volume balance",@"Withdrawal Amount",@"International",@"Name",@"Phone",@"ID number"];
    [self.view addSubview:self.cashTableView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = kNavColor;
    [confirmBtn setTitle:@"Confirm the application" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.offset(45);
    }];
}
- (UITableView *)cashTableView {
    if (!_cashTableView) {
        _cashTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _cashTableView.showsVerticalScrollIndicator = NO;
        _cashTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cashTableView.dataSource = self;
        _cashTableView.delegate = self;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenClick)];
        [_cashTableView addGestureRecognizer:recognizer];
    }
    return _cashTableView;
}

#pragma mark - 获取数据
- (void)loadWalletData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Withdraw/get_withdraw_info" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            _diamondLabel.text = [NSString stringWithFormat:@"%ld",[diction[@"coupon_total"] integerValue]];
            _drawLabel.text = [NSString stringWithFormat:@"$%.2f",[diction[@"can_withdraw_money"] floatValue]];
            _locationLabel.text = [NSString stringWithFormat:@"%@",diction[@"country_code"]];
            [_cashTableView reloadData];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark - tableview's delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] init];
    
    NSString *str = @"Withdrawal instructions:\n01. The minimum cash amount of 50 US dollars, the application is successful, the official staff will be 3 to 7 working days to complete the review and remittance operation\n02. iChat.ly using Western Union. Please confirm that you can receive payment through Western Union\n03. Pick up iChat.ly does not charge any fees. However, Western Union will charge remittance service fees, this part of the user needs to be borne, if the cash withdrawal costs are not enough to pay the cash withdrawal fee. Will not pass the review remittance. Deduction coupon will be refunded to Talk.ly account\n04. Western Union official website fee inquiry\n05.Be sure to fill in a real and effective name/phone number/ID to avoid the cash withdrawal failure or abnormalities.";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kCellSpace];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    
    _miaoshuLabel = [[UILabel alloc] init];
    _miaoshuLabel.textColor = k102Color;
    _miaoshuLabel.font = [UIFont systemFontOfSize:12];
    _miaoshuLabel.numberOfLines = 0;
    _miaoshuLabel.attributedText = attributedString;
    _miaoshuLabel.textAlignment = NSTextAlignmentLeft;
    [_miaoshuLabel sizeToFit];
    [view addSubview:_miaoshuLabel];
    [_miaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(view.mas_left).offset(15);
        make.right.mas_equalTo(view.mas_right).offset(-15);
        make.top.mas_equalTo(view.mas_top).offset(15);
        
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cash"];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cash"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = _titleArr[indexPath.row];
        titleLabel.textColor = k102Color;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        [cell addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(cell.mas_left).offset(15);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43.7, kScreenWidth, 0.3)];
        lineLabel.backgroundColor = kLineColor;
        [cell addSubview:lineLabel];
        
        if (indexPath.row == 0) {
            _diamondLabel = [[UILabel alloc] init];
            _diamondLabel.textColor = k51Color;
            _diamondLabel.font = [UIFont systemFontOfSize:15];
            [_diamondLabel sizeToFit];
            [cell addSubview:_diamondLabel];
            
            [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.right.mas_equalTo(cell.mas_right).offset(-15);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }else if (indexPath.row == 1) {
            _drawLabel = [[UILabel alloc] init];
            _drawLabel.textColor = k51Color;
            _drawLabel.font = [UIFont systemFontOfSize:15];
            [_drawLabel sizeToFit];
            [cell addSubview:_drawLabel];
            [_drawLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.right.mas_equalTo(cell.mas_right).offset(-15);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }else if (indexPath.row == 2) {
            _locationLabel = [[UILabel alloc] init];
            _locationLabel.textColor = k51Color;
            _locationLabel.font = [UIFont systemFontOfSize:15];
            [_locationLabel sizeToFit];
            [cell addSubview:_locationLabel];
            [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.right.mas_equalTo(cell.mas_right).offset(-15);
                make.centerY.mas_equalTo(cell.mas_centerY);
            }];
        }else if (indexPath.row == 3) {
            
            _nameTF = [[UITextField alloc] init];
            _nameTF.placeholder = @"Please fill in the real name";
            _nameTF.textAlignment = NSTextAlignmentRight;
            _nameTF.font = [UIFont systemFontOfSize:15];
            _nameTF.textColor = k51Color;
            [cell addSubview:_nameTF];
            [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).offset(-15);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.left.mas_equalTo(titleLabel.mas_right).offset(kSpace);
                make.height.offset(30);
            }];
        }else if (indexPath.row == 4) {
            _phoneTF = [[UITextField alloc] init];
            _phoneTF.placeholder = @"Please fill in the real phone number";
            _phoneTF.textAlignment = NSTextAlignmentRight;
            _phoneTF.font = [UIFont systemFontOfSize:15];
            _phoneTF.textColor = k51Color;
            _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
            [cell addSubview:_phoneTF];
            [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).offset(-15);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.left.mas_equalTo(titleLabel.mas_right).offset(kSpace);
                make.height.offset(30);
            }];
        }else {
            _numberTF = [[UITextField alloc] init];
            _numberTF.placeholder = @"Please fill in the identification number";
            _numberTF.textAlignment = NSTextAlignmentRight;
            _numberTF.font = [UIFont systemFontOfSize:15];
            _numberTF.textColor = k51Color;
            [cell addSubview:_numberTF];
            [_numberTF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).offset(-15);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.left.mas_equalTo(titleLabel.mas_right).offset(kSpace);
                make.height.offset(30);
            }];
        }
    }
    return cell;
}
- (void)screenClick {
    [_nameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
    [_numberTF resignFirstResponder];
}

- (void)confirmAction {
    if ([_nameTF.text isEqualToString:@""]) {
        [DataService toastWithMessage:@"Name cannot be empty"];
        return;
    }
    if ([_phoneTF.text isEqualToString:@""]) {
        [DataService toastWithMessage:@"Phone number cannot be empty"];
        return;
    }
    if ([_numberTF.text isEqualToString:@""]) {
        [DataService toastWithMessage:@"ID number cannot be empty"];
        return;
    }
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"withdraw_money":_drawLabel.text,@"firstname":_nameTF.text,@"country":_locationLabel.text,@"phone_number":_phoneTF.text,@"card_id":_numberTF.text};
    [DataService postWithURL:@"rest3/v1/Withdraw/withdraw" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"Success"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Error"];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
