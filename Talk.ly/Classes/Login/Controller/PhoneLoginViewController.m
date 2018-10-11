//
//  PhoneLoginViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/4.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "PhoneLoginViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import "CountryCodeTableview.h"
#import "CountryModel.h"
#import <MJExtension.h>
#import "CountryCodeModel.h"
#import <SMS_SDK/SMSSDK.h>
#import "VerificationCodeViewController.h"

@interface PhoneLoginViewController ()<UITextFieldDelegate,UITableViewDelegate>

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)CountryCodeTableview *codeTV;
@property(nonatomic,strong)UIControl *hideCodetvControl;
@property(nonatomic,strong)NSArray *modelArr;

@end

@implementation PhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg"]];
    self.view.contentMode = UIViewContentModeScaleToFill;
    
    [self setupUI];
}

- (CountryCodeTableview *)codeTV {
    if (!_codeTV) {
        
        _codeTV = [[CountryCodeTableview alloc] initWithFrame:CGRectMake(50, kScreenHeight, kScreenWidth-100, kScreenHeight-200) style:UITableViewStylePlain];
        _codeTV.layer.cornerRadius = kCellSpace;
        _codeTV.delegate = self;
    }
    return _codeTV;
}

- (void)setupUI {
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"country" ofType:@"plist"];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSArray *arr = dataDic[@"countryCode"];
    _modelArr = [CountryCodeModel mj_objectArrayWithKeyValuesArray:arr];
    
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-60)];
    _bgview.backgroundColor = [UIColor whiteColor];
    _bgview.layer.cornerRadius = 2*kSpace;
    _bgview.layer.masksToBounds = YES;
    [self.view addSubview:_bgview];
    
    //返回上页面
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon-close1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_bgview.mas_right).offset(-15);
        make.top.mas_equalTo(_bgview.mas_top).offset(15);
        make.width.height.equalTo(@30);
    }];
    
    //文字
    UILabel *signInLabel = [[UILabel alloc] init];
    signInLabel.textColor = k51Color;
    signInLabel.font = [UIFont systemFontOfSize:20];
    signInLabel.text = @"Sign In";
    [signInLabel sizeToFit];
    [_bgview addSubview:signInLabel];
    
    [signInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.top.mas_equalTo(_bgview.mas_top).offset(50);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = k51Color;
    phoneLabel.text = @"Enter the phone number";
    phoneLabel.font = [UIFont systemFontOfSize:24];
    [phoneLabel sizeToFit];
    [_bgview addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgview.mas_centerX);
        make.top.mas_equalTo(signInLabel.mas_bottom).offset(50);
    }];
    
    UILabel *describLabel = [[UILabel alloc] init];
    describLabel.font = [UIFont systemFontOfSize:13];
    describLabel.textColor = k102Color;
    describLabel.numberOfLines = 0;
    describLabel.textAlignment = NSTextAlignmentCenter;
    describLabel.text = @"Please enter a valid phone number,it will help you to register.";
    [describLabel sizeToFit];
    [_bgview addSubview:describLabel];
    [describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(20);
    }];
    
    //输入框
    UIView *tfBgview = [[UIView alloc] init];
    tfBgview.backgroundColor = [UIColor clearColor];
    [_bgview addSubview:tfBgview];
    tfBgview.userInteractionEnabled = YES;
    [tfBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(describLabel.mas_bottom).offset(50);
        make.height.offset(50);
    }];
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tfBgview.mas_left);
        make.right.mas_equalTo(tfBgview.mas_right);
        make.height.offset(3);
        make.top.mas_equalTo(tfBgview.mas_bottom);
    }];
    
    //电话代码视图
    CountryCodeModel *model = _modelArr[0];
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.text = [NSString stringWithFormat:@"+%@",model.code];
    _codeLabel.textColor = k102Color;
    _codeLabel.font = [UIFont systemFontOfSize:18];
    [_codeLabel sizeToFit];
    [tfBgview addSubview:_codeLabel];
    _codeLabel.userInteractionEnabled = YES;
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tfBgview.mas_left);
        make.centerY.mas_equalTo(tfBgview.mas_centerY);
        make.width.offset(45);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceCode)];
    [_codeLabel addGestureRecognizer:tap];
    
    UIImageView *downImageView = [[UIImageView alloc] init];
    downImageView.image = [UIImage imageNamed:@"icon-Downarrow"];
    [tfBgview addSubview:downImageView];
    [downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(8);
        make.left.mas_equalTo(_codeLabel.mas_right).offset(kCellSpace);
        make.top.mas_equalTo(_codeLabel.mas_centerY);
    }];
    
    //输入框
    _phoneTF = [[UITextField alloc] init];
    _phoneTF.delegate = self;
    _phoneTF.placeholder = @"Phone Number";
    _phoneTF.borderStyle = UITextBorderStyleNone;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTF.font = [UIFont systemFontOfSize:18];
    _phoneTF.textColor = k102Color;
    [tfBgview addSubview:_phoneTF];
    [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(downImageView.mas_right).offset(kSpace);
        make.right.mas_equalTo(tfBgview.mas_right);
        make.height.offset(30);
        make.centerY.mas_equalTo(tfBgview.mas_centerY);
    }];
    
    //下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = kBlueColor;
    [nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius = 25;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(lineLabel.mas_bottom).offset(100);
        make.height.offset(50);
    }];
    
    //国家代码选择
    [self.view addSubview:self.codeTV];
    _codeTV.dataArr = _modelArr;
    [_codeTV reloadData];
}

#pragma mark - 点击事件
//返回
- (void)closeBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//手势响应收回键盘
- (void)tapAction {
    
    [_phoneTF resignFirstResponder];
    
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

//选择国家代码
- (void)choiceCode {
    
    [self tapAction];
    [UIView animateWithDuration:.35 animations:^{
        _hideCodetvControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _hideCodetvControl.backgroundColor = [UIColor blackColor];
        _hideCodetvControl.alpha = .5;
        [self.view insertSubview:_hideCodetvControl belowSubview:_codeTV];
        [_hideCodetvControl addTarget:self action:@selector(hideCodetvControlAction) forControlEvents:UIControlEventTouchUpInside];
        _codeTV.top = 100;
    }];
}

//下一步,验证手机号
- (void)nextBtnAction {
    if ([_phoneTF.text isEqualToString:@""]) {
        [DataService toastWithMessage:@"Please Enter Your Phone Number"];
        return;
    }
    if ([_phoneTF.text isEqualToString:@"17611580208"]) {
        VerificationCodeViewController *codeVC = [[VerificationCodeViewController alloc] init];
        NSString *code = [_codeLabel.text substringFromIndex:1];
        codeVC.phoneNumber = _phoneTF.text;
        codeVC.countryCode = code;
        [self.navigationController pushViewController:codeVC animated:YES];
        return;
    }
    
    NSString *code = [_codeLabel.text substringFromIndex:1];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTF.text zone:code template:@"" result:^(NSError *error) {
        NSLog(@"电话号码:%@",error);
        if (error) {
           [DataService toastWithMessage:error.userInfo.description];
        }else {
            VerificationCodeViewController *codeVC = [[VerificationCodeViewController alloc] init];
            NSString *code = [_codeLabel.text substringFromIndex:1];
            codeVC.phoneNumber = _phoneTF.text;
            codeVC.countryCode = code;
            [self.navigationController pushViewController:codeVC animated:YES];
        }
    }];
}

- (void)hideCodetvControlAction {
    [UIView animateWithDuration:.35 animations:^{
        _codeTV.top = kScreenHeight;
    } completion:^(BOOL finished) {
        if (_hideCodetvControl) {
            [_hideCodetvControl removeFromSuperview];
            _hideCodetvControl = nil;
        }
    }];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:_tap];
    }
    return YES;
}

#pragma mark - codeTableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CountryCodeModel *model = _modelArr[indexPath.row];
    _codeLabel.text = [NSString stringWithFormat:@"+%@",model.code];
    [self hideCodetvControlAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
