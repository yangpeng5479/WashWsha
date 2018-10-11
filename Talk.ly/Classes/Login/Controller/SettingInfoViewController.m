//
//  SettingInfoViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SettingInfoViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "UserModel.h"
#import <MJExtension.h>
#import <UMMobClick/MobClick.h>
#import "WYFileManager.h"

@interface SettingInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UIView *dateView;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UILabel *birthdayLabel;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *headerUrl;
@property(nonatomic,strong)UIImageView *iconImageView;

@end

@implementation SettingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbg"]];
    self.view.contentMode = UIViewContentModeScaleToFill;
    
    [self setupUI];
    [self _createAgeView];
}

//创建年龄选择视图
- (void)_createAgeView {
    
    _dateView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 220)];
    _dateView.backgroundColor = kLightBgColor;
    _dateView.alpha = 0;
    
    [self.view addSubview:_dateView];
    
    [UIView animateWithDuration:.3 animations:^{
        
        _dateView.alpha = 1;
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(_dateView.width-60-kSpace, kSpace, 60, 30);
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:saveBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kSpace, kSpace, 60, 30);
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:cancelBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_dateView.width-120)/2, kSpace, 120, 30)];
    titleLabel.text = @"选择出生日期";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_dateView addSubview:titleLabel];
    
    UIDatePicker *datePick = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, saveBtn.bottom+kSpace, kScreenWidth, _dateView.height-saveBtn.bottom-kSpace)];
    datePick.datePickerMode = UIDatePickerModeDate;
    datePick.tag = 5100;
    
    NSString *minStr = @"1918-01-01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [dateFormatter dateFromString:minStr];
    NSDate *maxDate = [NSDate date];
    NSDate *birthday = [dateFormatter dateFromString:@"2000-01-01"];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    NSString *bstr = [NSString stringWithFormat:@"%@",[userdefault objectForKey:@"birthday"]];
    
    if (![bstr isEqualToString:@"(null)"]) {
        
        birthday = [dateFormatter dateFromString:@"1996-01-01"];
    }
    datePick.minimumDate = minDate;
    datePick.maximumDate = maxDate;
    datePick.date = birthday;
    
    [_dateView addSubview:datePick];
}

//弹出选择年龄控件
- (void)chooseAgeAction {
    [self tapAction];
    [UIView animateWithDuration:.3 animations:^{
        
        _dateView.alpha = 1;
        _dateView.transform = CGAffineTransformMakeTranslation(0, -_dateView.height);
    }];
}

//保存年龄
- (void)saveButtonAction {
    
    UIDatePicker *dateP = (UIDatePicker *)[_dateView viewWithTag:5100];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *birthday = [dateFormatter stringFromDate:dateP.date];
    
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:dateP.date];
    NSInteger age = (NSInteger)time/(3600*24*365);
    
    if (age > 17) {
        _age = [NSString stringWithFormat:@"%ld",age];
        _birthdayLabel.text = birthday;
        _birthdayLabel.textColor = k51Color;
    }else {
        [DataService toastWithMessage:@"Must be older than 17 to use iChat.ly"];
        _birthdayLabel.text = @"Birthday";
        _birthdayLabel.textColor = [UIColor lightGrayColor];
    }
    
    [UIView animateWithDuration:.3 animations:^{
        
        _dateView.alpha = 0;
        _dateView.transform = CGAffineTransformIdentity;
    }];
}

//取消年龄选择
- (void)cancelButtonAction {
    
    [UIView animateWithDuration:.3 animations:^{
        
        _dateView.alpha = 0;
        _dateView.transform = CGAffineTransformIdentity;
    }];
}

- (void)setupUI {
    _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, kScreenHeight-60)];
    _bgview.backgroundColor = [UIColor whiteColor];
    _bgview.layer.cornerRadius = 2*kSpace;
    _bgview.layer.masksToBounds = YES;
    _bgview.userInteractionEnabled = YES;
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
    signInLabel.text = @"Setting data";
    [signInLabel sizeToFit];
    [_bgview addSubview:signInLabel];
    
    [signInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.top.mas_equalTo(_bgview.mas_top).offset(50);
    }];
    
    //添加头像
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"Addphotos"];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_bgview addSubview:_iconImageView];
    UITapGestureRecognizer *addphoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoAction)];
    [_iconImageView addGestureRecognizer:addphoto];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_bgview.mas_centerX);
        make.top.mas_equalTo(signInLabel.mas_bottom).offset(40);
        make.width.height.equalTo(@80);
    }];
    
    //姓名
    _nameTF = [[UITextField alloc] init];
    _nameTF.placeholder = @"Nickname";
    _nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTF.delegate = self;
    _nameTF.borderStyle = UITextBorderStyleNone;
    _nameTF.keyboardType = UIKeyboardTypeASCIICapable;
    _nameTF.textColor = k51Color;
    _nameTF.font = [UIFont systemFontOfSize:15];
    [_bgview addSubview:_nameTF];
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgview.mas_left).offset(50);
        make.right.mas_equalTo(_bgview.mas_right).offset(-50);
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(30);
        make.height.offset(30);
    }];
    UILabel *topLineLabel = [[UILabel alloc] init];
    topLineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:topLineLabel];
    [topLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_nameTF.mas_left);
        make.right.mas_equalTo(_nameTF.mas_right);
        make.top.mas_equalTo(_nameTF.mas_bottom);
        make.height.offset(2);
    }];
    
    _birthdayLabel = [[UILabel alloc] init];
    _birthdayLabel.textColor = [UIColor lightGrayColor];
    _birthdayLabel.font = [UIFont systemFontOfSize:15];
    _birthdayLabel.text = @"Birthday";
    _birthdayLabel.userInteractionEnabled = YES;
    [_bgview addSubview:_birthdayLabel];
    [_birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameTF.mas_left);
        make.right.mas_equalTo(_nameTF.mas_right);
        make.height.offset(30);
        make.top.mas_equalTo(topLineLabel.mas_bottom).offset(30);
    }];
    UITapGestureRecognizer *birthTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAgeAction)];
    [_birthdayLabel addGestureRecognizer:birthTap];
    
    UILabel *centerLineLabel = [[UILabel alloc] init];
    centerLineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:centerLineLabel];
    [centerLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_birthdayLabel.mas_left);
        make.right.mas_equalTo(_birthdayLabel.mas_right);
        make.top.mas_equalTo(_birthdayLabel.mas_bottom);
        make.height.offset(2);
    }];
    
    //性别选择
    _genderLabel = [[UILabel alloc] init];
    _genderLabel.textColor = [UIColor lightGrayColor];
    _genderLabel.font = [UIFont systemFontOfSize:15];
    _genderLabel.text = @"Gender";
    _genderLabel.userInteractionEnabled = YES;
    [_bgview addSubview:_genderLabel];
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(centerLineLabel.mas_left);
        make.right.mas_equalTo(centerLineLabel.mas_right);
        make.height.offset(30);
        make.top.mas_equalTo(centerLineLabel.mas_bottom).offset(30);
    }];
    UITapGestureRecognizer *genderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseGenderAction)];
    [_genderLabel addGestureRecognizer:genderTap];
    
    UILabel *bottomLineLabel = [[UILabel alloc] init];
    bottomLineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:bottomLineLabel];
    [bottomLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_genderLabel.mas_left);
        make.right.mas_equalTo(_genderLabel.mas_right);
        make.top.mas_equalTo(_genderLabel.mas_bottom);
        make.height.offset(2);
    }];
    
    UIButton *ojbkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ojbkBtn setTitle:@"OK" forState:UIControlStateNormal];
    ojbkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    ojbkBtn.backgroundColor = kBlueColor;
    [ojbkBtn addTarget:self action:@selector(ojbkbtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgview addSubview:ojbkBtn];
    ojbkBtn.layer.cornerRadius = kCellSpace;
    ojbkBtn.layer.masksToBounds = YES;
    [ojbkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgview.mas_centerX);
        make.height.offset(44);
        make.width.offset(250);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
}

#pragma mark - 数据处理
- (void)saveImage:(UIImage *)image {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Uploading...";
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [DataService postWithURL:@"rest3/v1/Image/uploadImage" type:2 params:nil fileData:imageData success:^(id data) {
        [hud hideAnimated:YES];
        
        if ([data[@"status"] integerValue] == 1) {
            _headerUrl = [NSString stringWithFormat:@"%@",data[@"data"][@"link"]];
            NSLog(@"_headerUrl%@",_headerUrl);
            _iconImageView.image = image;
        }else {
            [DataService toastWithMessage:@"Avatar upload failed"];
        }
        
    } failure:^(NSError *error) {
        
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Avatar upload failed"];
    }];
}

//开放平台注册
- (void)loginWtihPlatform:(UIButton *)sender{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    [self.infoMdic setObject:_nameTF.text forKey:@"name"];
    [self.infoMdic setObject:_birthdayLabel.text forKey:@"birthday"];
    [self.infoMdic setObject:_genderLabel.text forKey:@"gender"];
    [self.infoMdic setObject:_headerUrl forKey:@"header"];
    
    [DataService postWithURL:@"rest3/v1/user/register_from_open_platform" type:1 params:self.infoMdic fileData:nil success:^(id data) {
        NSLog(@"login_from_open_platform:%@",data);
        sender.userInteractionEnabled = YES;
        if ([data[@"status"] integerValue] == 1) {
            
            NSDictionary *userDic = data[@"data"][@"user_info"];
            UserModel *user = [UserModel mj_objectWithKeyValues:userDic];
            [DataService storePersonalInfoWithModel:user];
            [[AccountManager sharedAccountManager] loadGiftData];
            [MobClick profileSignInWithPUID:user.user_id provider:self.infoMdic[@"open_platform"]];
            [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseBottomViewController alloc] init];
        }else if ([data[@"status"] integerValue] == 20008) {
            [DataService toastWithMessage:@"Please change another"];
        }
        [hud hideAnimated:YES];
    } failure:^(NSError *error) {
        sender.userInteractionEnabled = YES;
    }];
}

- (void)registeData:(UIButton *)sender {
    NSDictionary *location = [WYFileManager getCustomObjectWithKey:@"location"];
    if (location == nil) {
        location = @{@"city":@"",@"latitude":@"",@"longitude":@""};
    }
    NSLog(@"locationDic:%@",location);
    NSDictionary *dic = @{
                          @"phone_no":self.phoneStr,
                          @"passmd5":self.passwordStr,
                          @"name":_nameTF.text,
                          @"birthday":_birthdayLabel.text,
                          @"gender":_genderLabel.text,
                          @"header":_headerUrl,
                          @"longitude":location[@"longitude"],
                          @"latitude":location[@"latitude"],
                          @"city":location[@"city"],@"age":_age,
                          @"device_id":[UUIDTool getUUIDInKeychain]
                          };
    [DataService postWithURL:@"rest3/v1/user/registerByPhone" type:1 params:dic fileData:nil success:^(id data) {
        sender.userInteractionEnabled = YES;
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"user_info"];
            UserModel *model = [UserModel mj_objectWithKeyValues:diction];
            [DataService storePersonalInfoWithModel:model];
            [[AccountManager sharedAccountManager] loadGiftData];
            [MobClick profileSignInWithPUID:model.user_id provider:@"91110105MA019PL76Q"];
            [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseBottomViewController alloc] init];
        }else if ([data[@"status"] integerValue] == 20008) {
            [DataService toastWithMessage:@"Please change another"];
        }
    } failure:^(NSError *error) {
        sender.userInteractionEnabled = YES;
    }];
}

#pragma mark - 事件
//上传头像
- (void)addPhotoAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"addPhoto" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Album",@"TakePhoto", nil];
    [actionSheet showInView:self.view];
    return;
    if (IS_PAD) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"addPhoto" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Album", nil];
        [actionSheet showInView:self.view];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"addPhoto" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Album",@"TakePhoto", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)closeBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

//注册登录
- (void)ojbkbtnAction:(UIButton *)sender {
    
    if ([_headerUrl isEqualToString:@""] || !_headerUrl) {
        _headerUrl = @"";
        [self _toastWithMsg:@"Icon cannot be empty"];
        return;
    }
    if ([_nameTF.text isEqualToString:@""]) {
        [self _toastWithMsg:@"Nickname cannot be empty"];
        return;
    }
    if ([_birthdayLabel.text isEqualToString:@"Birt.hday"]) {
        [self _toastWithMsg:@"Birthday cannot be empty"];
        return;
    }
    if ([_genderLabel.text isEqualToString:@"Gender"]) {
        [self _toastWithMsg:@"Please set gender"];
        return;
    }
    sender.userInteractionEnabled = NO;
    if ([self.phoneStr isEqualToString:@"third"]) {
        //第三方登录,修改资料
        [self loginWtihPlatform:sender];
    }else {
        
        [self registeData:sender];
    }
}

//手势响应收回键盘
- (void)tapAction {
    
    [_nameTF resignFirstResponder];
    
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

- (void)chooseGenderAction{
    UIAlertController *alert = nil;
    if (IS_PAD) {
        alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    }else {
        alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Male" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.genderLabel.text = @"Male";
        self.genderLabel.textColor = k51Color;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Female" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.genderLabel.text = @"Female";
        self.genderLabel.textColor = k51Color;
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//提示框
- (void)_toastWithMsg:(NSString *)msg {
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Tips"
                                                        message:msg
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"close",nil) otherButtonTitles:nil];
    [alerView show];
}

#pragma mark - delegate
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self cancelButtonAction];
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:_tap];
    }
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case 1:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                imagePicker.delegate = self;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    CGFloat w = 150;
    CGFloat h = (w/image.size.width)*image.size.height;
    UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(w, h)];
    [self saveImage:newImage];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
