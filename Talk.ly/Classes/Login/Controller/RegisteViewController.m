//
//  RegisteViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RegisteViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import "SettingInfoViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface RegisteViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UITextField *emailTF;
@property(nonatomic,strong)UITextField *passTF;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UILabel *tipsLabel;
@property(nonatomic,strong)UILabel *miaoshuLabel;
@property(nonatomic,strong)UIButton *loginBtn;

@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg"]];
    self.view.contentMode = UIViewContentModeScaleToFill;
    
    [self setupUI];
}

- (void)setupUI {
    
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-60)];
    _bgview.backgroundColor = [UIColor whiteColor];
    _bgview.layer.cornerRadius = 2*kSpace;
    _bgview.layer.masksToBounds = YES;
    [self.view addSubview:_bgview];
    
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
    signInLabel.text = @"Sign Up";
    [signInLabel sizeToFit];
    [_bgview addSubview:signInLabel];
    
    [signInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.top.mas_equalTo(_bgview.mas_top).offset(100);
    }];
    
    //email
    UIView *emailBgview = [[UIView alloc] init];
    emailBgview.backgroundColor = [UIColor clearColor];
    [_bgview addSubview:emailBgview];
    [emailBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(signInLabel.mas_bottom).offset(40);
        make.height.offset(30);
    }];
    UIImageView *emailImageview = [[UIImageView alloc] init];
    emailImageview.image = [UIImage imageNamed:@"email"];
    [emailBgview addSubview:emailImageview];
    [emailImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(emailBgview.mas_left);
        make.centerY.mas_equalTo(emailBgview.mas_centerY);
        make.width.offset(25);
        make.height.offset(20);
    }];
    
    _emailTF = [[UITextField alloc] init];
    _emailTF.placeholder = @"Email";
    _emailTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailTF.delegate = self;
    _emailTF.borderStyle = UITextBorderStyleNone;
    _emailTF.keyboardType = UIKeyboardTypeASCIICapable;
    _emailTF.textColor = k51Color;
    _emailTF.font = [UIFont systemFontOfSize:15];
    [emailBgview addSubview:_emailTF];
    [_emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(emailImageview.mas_right).offset(kSpace);
        make.top.mas_equalTo(emailBgview.mas_top);
        make.right.mas_equalTo(emailBgview.mas_right).offset(-25);
        make.bottom.mas_equalTo(emailBgview.mas_bottom);
    }];
    
    UILabel *topLineLabel = [[UILabel alloc] init];
    topLineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:topLineLabel];
    [topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(emailBgview.mas_left);
        make.right.mas_equalTo(emailBgview.mas_right);
        make.top.mas_equalTo(emailBgview.mas_bottom).offset(kSpace+kCellSpace);
        make.height.offset(2);
    }];
    
    //password
    UIView *passBgview = [[UIView alloc] init];
    passBgview.backgroundColor = [UIColor clearColor];
    [_bgview addSubview:passBgview];
    [passBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(topLineLabel.mas_bottom).offset(40);
        make.height.offset(30);
    }];
    
    UIImageView *passImageView = [[UIImageView alloc] init];
    passImageView.image = [UIImage imageNamed:@"password"];
    [passBgview addSubview:passImageView];
    [passImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(passBgview.mas_left);
        make.centerY.mas_equalTo(passBgview.mas_centerY);
        make.width.height.equalTo(@25);
    }];
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setImage:[UIImage imageNamed:@"icon-Closeeyes"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(showPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    [passBgview addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(passBgview.mas_right);
        make.centerY.mas_equalTo(passBgview.mas_centerY);
        make.width.height.equalTo(@20);
    }];
    
    _passTF = [[UITextField alloc] init];
    _passTF.placeholder = @"Password";
    _passTF.delegate = self;
    _passTF.borderStyle = UITextBorderStyleNone;
    _passTF.secureTextEntry = YES;
    _passTF.keyboardType = UIKeyboardTypeASCIICapable;
    _passTF.font = [UIFont systemFontOfSize:15];
    [_passTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [passBgview addSubview:_passTF];
    [_passTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(passImageView.mas_right).offset(kSpace);
        make.right.mas_equalTo(showBtn.mas_left).offset(-kCellSpace);
        make.centerY.mas_equalTo(passBgview.mas_centerY);
        make.height.offset(30);
    }];
    
    UILabel *bottomLineLabel = [[UILabel alloc] init];
    bottomLineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:bottomLineLabel];
    [bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(passBgview.mas_left);
        make.right.mas_equalTo(passBgview.mas_right);
        make.top.mas_equalTo(passBgview.mas_bottom).offset(kSpace+kCellSpace);
        make.height.offset(2);
    }];
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    _tipsLabel.textColor = kTipsColor;
    [_tipsLabel sizeToFit];
    _tipsLabel.hidden = YES;
    [_bgview addSubview:_tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(bottomLineLabel.mas_bottom).offset(50);
        make.centerX.mas_equalTo(_bgview.mas_centerX);
    }];
    
    _miaoshuLabel = [[UILabel alloc] init];
    _miaoshuLabel.textColor = k153Color;
    _miaoshuLabel.font = [UIFont systemFontOfSize:15];
    _miaoshuLabel.numberOfLines = 0;
    _miaoshuLabel.textAlignment = NSTextAlignmentLeft;
    _miaoshuLabel.text = @"1.pleace enter your email;\n2.after the email verification is\nsuccessful,receive 10 silvers reward";
    [_miaoshuLabel sizeToFit];
    [_bgview addSubview:_miaoshuLabel];
    [_miaoshuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(bottomLineLabel.mas_left).offset(kSpace);
        make.right.mas_equalTo(bottomLineLabel.mas_right).offset(-kSpace);
        make.top.mas_equalTo(bottomLineLabel.mas_bottom).offset(15);
    }];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"Next" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = kBlueColor;
    _loginBtn.layer.cornerRadius = 22;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bgview.mas_centerX);
        make.height.offset(44);
        make.width.offset(250);
        make.top.mas_equalTo(bottomLineLabel.mas_bottom).offset(200);
    }];
    
    UIButton *signInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInBtn setTitle:@"Have an Account? Sign In" forState:UIControlStateNormal];
    [signInBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    signInBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [signInBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:signInBtn];
}

#pragma mark - 事件
- (void)closeBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loginBtnAction:(UIButton *)sender {
    if ([_emailTF.text isEqualToString:@""]) {
        [DataService toastWithMsg:@"Please enter Email address"];
        return;
    }
    if ([_passTF.text isEqualToString:@""]) {
        [DataService toastWithMsg:@"Please enter your password"];
        return;
    }
    
    [self verificationEmail:sender];
}

- (void)showPasswordAction:(UIButton *)sender {
    if (!sender.selected) {
        
        
        _passTF.secureTextEntry = NO;
        
        NSString *string = _passTF.text;
        _passTF.text = @"";
        _passTF.text = string;
        
        [sender setImage:[UIImage imageNamed:@"icon-eye"] forState:UIControlStateNormal];
        sender.selected = YES;
    }else {
        
        _passTF.secureTextEntry = YES;
        
        [sender setImage:[UIImage imageNamed:@"icon-Closeeyes"] forState:UIControlStateNormal];
        sender.selected = NO;
    }
}

//手势响应收回键盘
- (void)tapAction {
    
    [_emailTF resignFirstResponder];
    [_passTF resignFirstResponder];
    
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

//MD5加密
- (NSString *)passwordMD5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}
#pragma mark - 数据获取
//验证email
- (void)verificationEmail:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    NSDictionary *dic = @{@"email":_emailTF.text};
    [DataService postWithURL:@"rest3/v1/user/existEmail" type:1 params:dic fileData:nil success:^(id data) {
        sender.userInteractionEnabled = YES;
        if ([data[@"status"] integerValue] == 1) {
            BOOL isexist = [data[@"data"][@"exist_email"] boolValue];
            if (isexist == YES) {
                [DataService toastWithMsg:@"Email Exist"];
            }else {
                
                SettingInfoViewController *setVC = [[SettingInfoViewController alloc] init];
//                setVC.emailStr = _emailTF.text;
                setVC.passwordStr = [self passwordMD5:_passTF.text];
                [self.navigationController pushViewController:setVC animated:YES];
            }
        }else {
            [DataService toastWithMessage:@"Network Error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Network Error"];
        sender.userInteractionEnabled = YES;
    }];
}

#pragma mark - textField代理方法
- (void)textFieldDidChange:(id)sender {
    
    if (_passTF.text.length > 20) {
        _miaoshuLabel.hidden = YES;
        _tipsLabel.hidden = NO;
        _tipsLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-caveat" bounds:CGRectMake(0, -2, 12, 12) str:@"8~20 characters"];
        _passTF.text = [_passTF.text substringToIndex:20];
    }else if (_passTF.text.length <8) {
        _miaoshuLabel.hidden = YES;
        _tipsLabel.hidden = NO;
        _tipsLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-caveat" bounds:CGRectMake(0, -2, 12, 12) str:@"8~20 characters"];
    }else {
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([pred evaluateWithObject:_passTF.text]) {
            _tipsLabel.hidden = YES;
            _tipsLabel.text = @"";
            _miaoshuLabel.hidden = NO;
        }else {
            _miaoshuLabel.hidden = YES;
            _tipsLabel.hidden = NO;
            _tipsLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-caveat" bounds:CGRectMake(0, -2, 12, 12) str:@"Please choose a more secure password"];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:_tap];
    }
    if (textField == _passTF) {
        if ([_tipsLabel.text isEqualToString:@""] && ![_emailTF.text isEqualToString:@""]) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _emailTF) {
        if ([_emailTF.text isEqualToString:@""]) {
            _miaoshuLabel.hidden = NO;
            _tipsLabel.hidden = YES;
            _tipsLabel.text = @"";
            return;
        }
        _miaoshuLabel.hidden = YES;
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if( [emailTest evaluateWithObject:_emailTF.text]){
            NSLog(@"恭喜！您输入的邮箱验证合法");
            _miaoshuLabel.hidden = NO;
            _tipsLabel.hidden = YES;
            _tipsLabel.text = @"";
            
        }else{
            _tipsLabel.hidden = NO;
            _tipsLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-caveat" bounds:CGRectMake(0, -2, 12, 12) str:@"Please enter Email address"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
