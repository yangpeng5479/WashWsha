//
//  MoreLoginViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/4.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "MoreLoginViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import "PhoneLoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "LoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WYFileManager.h"
#import <MBProgressHUD.h>
#import <MJExtension.h>
#import <UMMobClick/MobClick.h>
#import "SettingInfoViewController.h"
#import "PrivateViewController.h"


@interface MoreLoginViewController ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)NSDictionary *locationDic;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)UIButton *phoneBtn;

@end

@implementation MoreLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [DataService changeReturnButton:self];
    
    //创建大背景
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgImageView.image = [UIImage imageNamed:@"login_bg"];
    if (IS_IPHONE_X) {
        bgImageView.image = [UIImage imageNamed:@"loin_x_bg"];
    }
    [self.view addSubview:bgImageView];
    //获取定位信息
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
    _geocoder = [[CLGeocoder alloc] init];
    
    [self creatView];
    [self isCheckingData];
}

- (void)isCheckingData {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [DataService postWithURL:@"rest3/v1/Startup/appleCheckingV2" type:1 params:nil fileData:nil success:^(id data) {
    
        NSLog(@"%@",data);
        NSString *v = [NSString stringWithFormat:@"%@",data[@"data"]];
        if ([v isEqualToString:app_Version]) {
            _phoneBtn.hidden = YES;
        }else {
            _phoneBtn.hidden = NO;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)creatView {
    
    //用户权限
    UILabel *priLabel = [[UILabel alloc] init];
    priLabel.text = @"By continuing agree to the agreement";
    priLabel.textColor = [UIColor whiteColor];
    priLabel.font = [UIFont systemFontOfSize:12];
    [priLabel sizeToFit];
    [self.view addSubview:priLabel];
    [priLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-45);
    }];
    
    UIButton *privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [privateBtn setTitle:@"User privacy policy" forState:UIControlStateNormal];
    [privateBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:144/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    privateBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [privateBtn addTarget:self action:@selector(privateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privateBtn];
    [privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(50);
        make.right.mas_equalTo(self.view.mas_right).offset(-50);
        make.height.offset(15);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-25);
    }];
    
    //创建第三方登录按钮
    NSArray *imageArr = @[@"Facebook",@"twitter",@"e-mail",@"google",@"ins"];
    NSMutableArray *buttonArr = [NSMutableArray array];
    for (int i = 0; i < 5; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.tag = 800+i;
        [self.view addSubview:btn];
        [buttonArr addObject:btn];
        [btn addTarget:self action:@selector(thirdLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    [buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:45 leadSpacing:35 tailSpacing:35];
    [buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-70);
        make.height.offset(45);
    }];
    
    UILabel *otherLabel = [[UILabel alloc] init];
    otherLabel.text = @"--------------- Other Login Methods ---------------";
    otherLabel.font = [UIFont systemFontOfSize:12];
    otherLabel.textColor = [UIColor whiteColor];
    [otherLabel sizeToFit];
    [self.view addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-140);
    }];
    
    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    phoneBtn.backgroundColor = [UIColor whiteColor];
    [_phoneBtn setTitle:@"Login with phone" forState:UIControlStateNormal];
//    [phoneBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
    _phoneBtn.layer.borderWidth = 2;
    _phoneBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _phoneBtn.layer.cornerRadius = 25;
    _phoneBtn.layer.masksToBounds = YES;
    _phoneBtn.hidden = YES;
    [self.view addSubview:_phoneBtn];
    [_phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left).offset(5*kSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(-5*kSpace);
        make.bottom.mas_equalTo(otherLabel.mas_top).offset(-50);
        make.height.offset(50);
    }];
}

#pragma mark - 第三方登录
- (void)thirdLoginAction:(UIButton *)sender {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"Loading...";
    switch (sender.tag) {
        case 800:
        {
            [self configureLoadData:SSDKPlatformTypeFacebook];
        }
            break;
        case 801:
        {
            [self configureLoadData:SSDKPlatformTypeTwitter];
        }
            break;
        case 802:
            //邮箱登录
        {
            LoginViewController *emailVC = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:emailVC animated:YES];
            [_hud hideAnimated:YES];
        }
            break;
        case 803:
        {
            [self configureLoadData:SSDKPlatformTypeGooglePlus];
        }
            
            break;
        case 804:
        {
            [self configureLoadData:SSDKPlatformTypeInstagram];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)configureLoadData:(SSDKPlatformType)platformType {
    
    [ShareSDK cancelAuthorize:platformType];
    [ShareSDK authorize:platformType settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess){
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            NSLog(@"gender=%ld",user.gender);
            NSLog(@"rawdata=%@",user.rawData);
            NSString *str = @"";
            if (platformType == SSDKPlatformTypeFacebook) {
                str = @"facebook";
            }else if (platformType == SSDKPlatformTypeTwitter) {
                str = @"twitter";
            }else if (platformType == SSDKPlatformTypeGooglePlus) {
                str = @"google";
            }else if (platformType == SSDKPlatformTypeInstagram) {
                str = @"instagram";
            }
            
            [self determineWhetherTheOpenPlatformIsRegistered:str Uid:user.uid Name:user.nickname];
            
        }else if (state == SSDKResponseStateCancel) {
            [_hud hideAnimated:YES];
            _hud = nil;
        }else{
            [_hud hideAnimated:YES];
            _hud = nil;
            NSLog(@"%@",error);
        }
    }];
//    [ShareSDK getUserInfo:platformType onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        if (state == SSDKResponseStateSuccess){
//
//            NSLog(@"uid=%@",user.uid);
//            NSLog(@"token=%@",user.credential.token);
//            NSLog(@"nickname=%@",user.nickname);
//        }else if (state == SSDKResponseStateCancel) {
//
//        }else{
//            NSLog(@"%@",error);
//        }
//    }];
}

//判断开放平台是否注册
- (void)determineWhetherTheOpenPlatformIsRegistered:(NSString *)platForm Uid:(NSString *)uid Name:(NSString *)name{
    NSDictionary *dic = @{@"open_platform":platForm,@"open_id":uid};
    [DataService postWithURL:@"rest3/v1/user/login_from_open_platform_V2" type:1 params:dic fileData:nil success:^(id data) {
        [_hud hideAnimated:YES];
        _hud = nil;
        
        if ([data[@"status"] integerValue] == 20002) {
            //账号未注册
            NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
            NSDictionary *location = [WYFileManager getCustomObjectWithKey:@"location"];
            if (location == nil) {
                location = @{@"city":@"",@"latitude":@"",@"longitude":@""};
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"open_platform":platForm,@"open_id":uid,@"push_token":uuid,@"longitude":location[@"longitude"],@"latitude":location[@"latitude"],@"city":location[@"city"],@"open_name":name,@"device_id":[UUIDTool getUUIDInKeychain]}];
            
            SettingInfoViewController *setVC = [[SettingInfoViewController alloc] init];
            setVC.phoneStr = @"third";
            setVC.infoMdic = dic;
            [self.navigationController pushViewController:setVC animated:YES];
            
        }else if ([data[@"status"] integerValue] == 1) {
            NSDictionary *userDic = data[@"data"][@"user_info"];
            UserModel *user = [UserModel mj_objectWithKeyValues:userDic];
            [DataService storePersonalInfoWithModel:user];
            [[AccountManager sharedAccountManager] loadGiftData];
            [MobClick profileSignInWithPUID:user.user_id provider:platForm];
            [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseBottomViewController alloc] init];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 手机号登录
- (void)phoneBtnAction {
    [_hud hideAnimated:YES];
    _hud = nil;
    
    PhoneLoginViewController *vc = [[PhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 用户权限
- (void)privateBtnAction {
    PrivateViewController *vc = [[PrivateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 定位
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    _locationDic = @{@"city":@"Unknown",@"latitude":@"",@"longitude":@""};
    if ([error code] == kCLErrorDenied) {
        //被拒绝
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法定位
        [DataService toastWithMsg:@"Please open the GPS"];
    }
    [WYFileManager setCustomObject:_locationDic forKey:@"location"];
    [AccountManager sharedAccountManager].locationDic = _locationDic;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    
    //根据经纬度反向地理编译出地址信息
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            CLLocationDegrees latitude = newLocation.coordinate.latitude;
            CLLocationDegrees longitude = newLocation.coordinate.longitude;
            _locationDic = @{@"city":city,@"latitude":@(latitude),@"longitude":@(longitude)};
            [WYFileManager setCustomObject:_locationDic forKey:@"location"];
            [AccountManager sharedAccountManager].locationDic = _locationDic;
            NSLog(@"%@",_locationDic);
        }
        else if (error == nil && [array count] == 0)
        {
            [DataService toastWithMessage:@"No results were returned"];
        }
        else if (error != nil)
        {
            [DataService toastWithMessage:[NSString stringWithFormat:@"An error occurred = %@", error]];
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
