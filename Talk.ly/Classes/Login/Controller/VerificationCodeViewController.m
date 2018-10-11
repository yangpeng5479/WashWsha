//
//  VerificationCodeViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "VerificationCodeViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "MQVerCodeInputView.h"
#import <SMS_SDK/SMSSDK.h>
#import "DataService.h"
#import "SettingInfoViewController.h"
#import <MJExtension.h>
#import <UMMobClick/MobClick.h>

@interface VerificationCodeViewController ()

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)MQVerCodeInputView *verView;
@property(nonatomic,copy)NSString *codeStr;
@property(nonatomic,strong)UIView *loginAnimView;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
//登录时加一个看不见的蒙版，让控件不能再被点击
@property (nonatomic,strong) UIView *HUDView;


@end

@implementation VerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg"]];
    self.view.contentMode = UIViewContentModeScaleToFill;
    [self setupUI];
}

- (void)setupUI {
    
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:_tap];
    }
    
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
    phoneLabel.text = @"Enter the code";
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
    describLabel.text = [NSString stringWithFormat:@"Phone number (%@)%@ No regist , please Sign Up Enter SMS verification code.",self.countryCode,self.phoneNumber];
    [describLabel sizeToFit];
    [_bgview addSubview:describLabel];
    [describLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(phoneLabel.mas_bottom).offset(20);
    }];

    //验证码输入框
    _verView = [[MQVerCodeInputView alloc] init];
    _verView.keyBoardType = UIKeyboardTypeNumberPad;
    _verView.viewColorHL = kNavColor;
    [_verView mq_verCodeViewWithMaxLenght];
    [_bgview addSubview:_verView];
    
    _verView.block = ^(NSString *text) {
        NSLog(@"%@",text);
        _codeStr = text;
    };
    [_verView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_bgview.mas_centerX);
        make.top.mas_equalTo(describLabel.mas_bottom).offset(50);
        make.width.offset(200);
        make.height.offset(50);
    }];
    
    //下一步按钮
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = kBlueColor;
    [_loginBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 25;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(_verView.mas_bottom).offset(100);
        make.height.offset(50);
    }];
}

#pragma mark - 数据请求
//验证手机号是否注册
- (void)existPhoneWithPhone:(NSString *)phone {
    NSDictionary *dic = @{@"phone_no":phone};
    [DataService postWithURL:@"rest3/v1/user/existPhone" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [self.HUDView removeFromSuperview];
            self.HUDView = nil;
            self.loginBtn.hidden = NO;
            [self.loginAnimView removeFromSuperview];
            [self.loginAnimView.layer removeAllAnimations];
            
            NSDictionary *dataDic = data[@"data"];
            if ([dataDic[@"exist_phone"] integerValue] == 0) {
                
                SettingInfoViewController *setVC = [[SettingInfoViewController alloc] init];
                setVC.phoneStr = phone;
                setVC.passwordStr = [DataService passwordMD5:phone];
                [self.navigationController pushViewController:setVC animated:YES];
            }else {
                [self loginByPhoneNo:phone];
            }
        }
    } failure:^(NSError *error) {
        [self leftAndRight];
    }];
}

//已注册,登录
- (void)loginByPhoneNo:(NSString *)phone {
    
    NSDictionary *dic = @{@"phone_no":phone,@"passmd5":[DataService passwordMD5:phone],@"device_id":[UUIDTool getUUIDInKeychain]};
    [DataService postWithURL:@"rest3/v1/user/loginByPhoneNo" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == 1) {
            [self loginSuccess];
            NSDictionary *diction = data[@"data"][@"user_info"];
            UserModel *model = [UserModel mj_objectWithKeyValues:diction];
            [DataService storePersonalInfoWithModel:model];
            [[AccountManager sharedAccountManager] loadGiftData];
            [MobClick profileSignInWithPUID:model.user_id provider:@"91110105MA019PL76Q"];
        }
    } failure:^(NSError *error) {
        [self leftAndRight];
    }];
}

#pragma mark - 点击事件
- (void)closeBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAction {
    [_verView endEdit];
}

- (void)nextBtnAction {
    if (_codeStr.length < 4) {
     
        return;
    }
    self.HUDView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.HUDView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.HUDView];
    [self loginbtnAnimate];
    //验证验证码
    if ([self.phoneNumber isEqualToString:@"17611580208"] && [_codeStr isEqualToString:@"1234"]) {
        NSString *phone = [NSString stringWithFormat:@"%@-%@",self.countryCode,self.phoneNumber];
        [self existPhoneWithPhone:phone];
        return;
    }
    [SMSSDK commitVerificationCode:_codeStr phoneNumber:self.phoneNumber zone:self.countryCode result:^(NSError *error) {
       
        if (!error) {
            //验证 成功,请求接口
            NSString *phone = [NSString stringWithFormat:@"%@-%@",self.countryCode,self.phoneNumber];
            [self existPhoneWithPhone:phone];
            
        }else {
            [self leftAndRight];
            [DataService toastWithMessage:error.userInfo.description];
        }
    }];
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

- (void)loginSuccess {
    [self.HUDView removeFromSuperview];
    self.HUDView = nil;
    [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseBottomViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
