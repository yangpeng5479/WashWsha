//
//  LoginViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import "RegisteViewController.h"
#import "ForgetPasswordViewController.h"
#import <MJExtension.h>
#import <UMMobClick/MobClick.h>
#import <CommonCrypto/CommonDigest.h>
#import "WYFileManager.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UITextField *emailTF;
@property(nonatomic,strong)UITextField *passTF;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)UILabel *tipsLabel;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIView *loginAnimView;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
//登录时加一个看不见的蒙版，让控件不能再被点击
@property (nonatomic,strong) UIView *HUDView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg"]];
    self.view.contentMode = UIViewContentModeScaleToFill;

    [DataService changeReturnButton:self];
    [self setupUI];
}

- (void)setupUI {
    
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
    _emailTF.tag = 20;
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
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:@"Forget Password?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetBtn addTarget:self action:@selector(forgetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(bottomLineLabel.mas_right);
        make.top.mas_equalTo(bottomLineLabel.mas_bottom).offset(2*kSpace);
        make.width.offset(110);
        make.height.offset(15);
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
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setTitle:@"Sign In" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = kBlueColor;
    _loginBtn.layer.cornerRadius = 22;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_bgview.mas_centerX);
        make.height.offset(44);
        make.width.offset(250);
        make.top.mas_equalTo(bottomLineLabel.mas_bottom).offset(110);
    }];
}

#pragma mark - 点击事件
- (void)closeBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//登录按钮变圆
- (void)loginbtnAnimate {
    self.loginAnimView = [[UIView alloc] initWithFrame:self.loginBtn.frame];
    self.loginAnimView.layer.cornerRadius = 10;
    self.loginAnimView.layer.masksToBounds = YES;
    self.loginAnimView.frame = self.loginBtn.frame;
    self.loginAnimView.backgroundColor = self.loginBtn.backgroundColor;
    [_bgview addSubview:self.loginAnimView];
    self.loginBtn.hidden = YES;//把view从宽的样子变圆
    CGPoint centerPoint = self.loginAnimView.center;
    CGFloat radius = MIN(self.loginBtn.frame.size.width, self.loginBtn.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.loginAnimView.frame = CGRectMake(0, 0, radius, radius);
        self.loginAnimView.center = centerPoint;
        self.loginAnimView.layer.cornerRadius = radius/2;
        self.loginAnimView.layer.masksToBounds = YES;
        
    }completion:^(BOOL finished) {
        
        //给圆加一条不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 1.5;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = self.loginBtn.backgroundColor.CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        self.shapeLayer.path = path.CGPath;
        [self.loginAnimView.layer addSublayer:self.shapeLayer];
        
        //让圆转圈，实现"加载中"的效果
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [self.loginAnimView.layer addAnimation:baseAnimation forKey:nil];
    }];
}
//登录失败左右摆动 动画
- (void)leftAndRight {
    self.loginBtn.hidden = NO;
    [self.HUDView removeFromSuperview];
    self.HUDView = nil;
    [self.loginAnimView removeFromSuperview];
    [self.loginAnimView.layer removeAllAnimations];
    
    //给按钮添加左右摆动的效果(关键帧动画)
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.loginAnimView.layer.position;
    //这个参数就是值变化的数组
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 10, point.y)],
                        
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 10, point.y)],
                        
                        [NSValue valueWithCGPoint:point]];
    //timingFunction意思是动画执行的效果(这个属性玩HTML+CSS的童鞋应该很熟悉吧)
    //kCAMediaTimingFunctionEaseInEaseOut表示淡入淡出
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    [self.loginBtn.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}
//登录按钮
- (void)loginBtnAction {
    if ([_emailTF.text isEqualToString:@""] || [_passTF.text isEqualToString:@""]) {
        _tipsLabel.hidden = NO;
        _tipsLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-caveat" bounds:CGRectMake(0, -2, 12, 12) str:@"Password is wrong. Please re-enter it."];
        return;
    }
    self.HUDView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.HUDView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.HUDView];
    [self loginbtnAnimate];
    
    NSDictionary *dic = @{@"email":self.emailTF.text,@"passmd5":[self passwordMD5:self.passTF.text],@"device_id":[UUIDTool getUUIDInKeychain]};
    [DataService postWithURL:@"rest3/v1/user/login" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            
            NSDictionary *dictionAry = data[@"data"][@"user_info"];
            UserModel *model = [UserModel mj_objectWithKeyValues:dictionAry];
            [DataService storePersonalInfoWithModel:model];
            [[AccountManager sharedAccountManager] loadGiftData];
            [MobClick profileSignInWithPUID:model.user_id provider:@"91110105MA019PL76Q"];
            [self loginSuccess];
            
        }else if ([data[@"status"] integerValue] == 20002) {
            
            [DataService toastWithMsg:@"Email Not Exist"];
            [self leftAndRight];
        }else if ([data[@"status"] integerValue] == 20003) {
            
            [DataService toastWithMsg:@"Password Error"];
            [self leftAndRight];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Network Error"];
        [self leftAndRight];
    }];
}
- (void)loginSuccess {
    [self.HUDView removeFromSuperview];
    self.HUDView = nil;
    [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseBottomViewController alloc] init];
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

//忘记密码
- (void)forgetBtnAction {
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

//手势响应收回键盘
- (void)tapAction {
    
    [_emailTF resignFirstResponder];
    [_passTF resignFirstResponder];
    
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

#pragma mark - textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loginBtnAction];
    [self tapAction];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:_tap];
    }
    return YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
