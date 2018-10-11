//
//  UserSettingViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/30.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "UserSettingViewController.h"
#import "YPHeaderFooterView.h"
#import "WYFileManager.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "ModifyUserinfoViewController.h"
#import "UserModel.h"
#import <MJExtension.h>
#import "LoginBrigeViewController.h"
#import "AboutMeViewController.h"
#import <MBProgressHUD.h>
#import "FeedbackIdeaController.h"

@interface UserSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView *settingTableView;
@property(nonatomic,strong)UILabel *birthdayLabel;
@property(nonatomic,strong)UIView *dateView;;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *signatureLabel;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *cacheLabel;
@property(nonatomic,copy)NSString *headerUrl;

@end

@implementation UserSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserData];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Setting";
    self.view.backgroundColor = [UIColor whiteColor];
    [DataService changeReturnButton:self];
    [self setupUI];
    [self _createAgeView];
}

#pragma mark - 创建视图
- (void)setupUI {
    
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.showsVerticalScrollIndicator = NO;
    _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _settingTableView.mj_header = [DataService refreshHeaderWithTarget:self action:@selector(loadUserData)];
    [_settingTableView registerClass:[YPHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.view addSubview:_settingTableView];
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
    
    if (age > 0) {
        [self configureUserInfonWithString:birthday];
    }else {
        
        _birthdayLabel.text = @"";
    }
    [_birthdayLabel sizeToFit];
    
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

#pragma mark - 数据请求
- (void)loadUserData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/user/get_my_info" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *dictionary = data[@"data"][@"user_info"];
            UserModel *model = [UserModel mj_objectWithKeyValues:dictionary];
            _nameLabel.text = model.name;
            _birthdayLabel.text = model.birthday;
            _signatureLabel.text = model.signature;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *birthday = [dateFormatter dateFromString:model.birthday];
            NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:birthday];
            NSInteger age = (NSInteger)time/(3600*24*365);
            if (age>0) {
                _birthdayLabel.text = model.birthday;
            }
            if ([model.gender isEqualToString:@"none"]) {
                model.gender = @"";
            }
            _genderLabel.text = model.gender;
            [_iconView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
            
            [_settingTableView reloadData];
            [_settingTableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        [_settingTableView.mj_header endRefreshing];
    }];
}
- (void)configureUserInfonWithString:(NSString *)str{
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"birthday":str};
    
    [DataService postWithURL:@"rest3/v1/user/modify_my_info" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
                _birthdayLabel.text = [NSString stringWithFormat:@"%@",str];
                model.birthday = str;
                [WYFileManager setCustomObject:model forKey:@"userModel"];
            [DataService toastWithMessage:@"Modify success"];
        }else {
            [DataService toastWithMessage:@"Modify error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Modify error"];
    }];
}

- (void)saveImage:(UIImage *)image {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Uploading...";
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    [DataService postWithURL:@"rest3/v1/Image/uploadImage" type:2 params:nil fileData:imageData success:^(id data) {
        [hud hideAnimated:YES];
        
        if ([data[@"status"] integerValue] == 1) {
            _headerUrl = [NSString stringWithFormat:@"%@",data[@"data"][@"link"]];
            
            [self modifyHeadimageData];
            _iconView.image = image;
        }else {
            [DataService toastWithMessage:@"Avatar upload failed"];
        }
        
    } failure:^(NSError *error) {
        
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Avatar upload failed"];
    }];
}

//修改头像
- (void)modifyHeadimageData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"header":_headerUrl};
    [DataService postWithURL:@"rest3/v1/user/modify_header" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"Operation Success"];
            [self loadUserData];
        }else {
            [DataService toastWithMessage:@"Unknow Error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Network Error"];
    }];
}

#pragma mark - tableview delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }else if (section == 1) {
        return 1;
    }else {
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YPHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    // 覆盖文字
    if (section == 0) {
        
        header.text = @"Profile settings";
    } else if(section == 1){
        header.text = @"Notifications";
    }else {
        header.text = @"General";
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

//为了上面的方法有效果 ios11 必须实现下面方法
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArr = @[@[@"Avatar",@"Nickname",@"Birthday",@"Gender",@"Signature"],@[@"Notification reminder settings"],@[@"Clear cache",@"FAQ",@"About",@"Exit the current account"]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userset"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userset"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = titleArr[indexPath.section][indexPath.row];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.7, kScreenWidth, 0.3)];
        lineLabel.backgroundColor = kLineColor;
        [cell addSubview:lineLabel];
        
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-55, kCellSpace, 40, 40)];
                    _iconView.layer.cornerRadius = 20;
                    _iconView.layer.masksToBounds = YES;
                    [cell addSubview:_iconView];
                }
                    break;
                case 1:
                {
                    _nameLabel = [[UILabel alloc] init];
                    _nameLabel.font = [UIFont systemFontOfSize:15];
                    _nameLabel.textColor = k51Color;
                    [_nameLabel sizeToFit];
                    [cell addSubview:_nameLabel];
                    
                    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.right.mas_equalTo(cell.mas_right).offset(-35);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                    }];
                }
                    break;
                case 2:
                {
                    _birthdayLabel = [[UILabel alloc] init];
                    _birthdayLabel.font = [UIFont systemFontOfSize:15];
                    _birthdayLabel.textColor = k51Color;
                    [_birthdayLabel sizeToFit];
                    [cell addSubview:_birthdayLabel];
                    
                    [_birthdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.right.mas_equalTo(cell.mas_right).offset(-35);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                    }];
                }
                    break;
                case 3:
                {
                    _genderLabel = [[UILabel alloc] init];
                    _genderLabel.font = [UIFont systemFontOfSize:15];
                    _genderLabel.textColor = k51Color;
                    [_genderLabel sizeToFit];
                    
                    [cell addSubview:_genderLabel];
                    
                    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.right.mas_equalTo(cell.mas_right).offset(-35);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                    }];
                }
                    break;
                case 4:
                {
                    _signatureLabel = [[UILabel alloc] init];
                    _signatureLabel.font = [UIFont systemFontOfSize:15];
                    _signatureLabel.textColor = k51Color;
                    _signatureLabel.textAlignment = NSTextAlignmentRight;
                    
                    [cell addSubview:_signatureLabel];
                    
                    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.right.mas_equalTo(cell.mas_right).offset(-35);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.left.mas_equalTo(cell.mas_left).offset(10*kSpace);
                        make.height.offset(20);
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }else if (indexPath.section == 1) {
            
        }else {
            if (indexPath.row == 0) {
                _cacheLabel = [[UILabel alloc] init];
                _cacheLabel.textColor = k51Color;
                _cacheLabel.font = [UIFont systemFontOfSize:15];
                [_cacheLabel sizeToFit];
                [cell.contentView addSubview:_cacheLabel];
                NSUInteger size = [[SDImageCache sharedImageCache] getSize];
                _cacheLabel.text = [NSString stringWithFormat:@"%.2fMB",size/1024/1024.0];
                [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.mas_equalTo(cell.mas_right).offset(-35);
                    make.centerY.mas_equalTo(cell.mas_centerY);
                }];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
        switch (indexPath.row) {
            case 0:
            {
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Album",@"TakePhoto", nil];
                [actionSheet showInView:self.view];
            }
                break;
            case 1:
            {
                ModifyUserinfoViewController *modifyVC = [[ModifyUserinfoViewController alloc] init];
                modifyVC.type = 1;
                modifyVC.text = model.name;
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
                break;
            case 2:
            {
                [self chooseAgeAction];
            }
                break;
            case 3:
            {
                
            }
                break;
            case 4:
            {
                ModifyUserinfoViewController *modifyVC = [[ModifyUserinfoViewController alloc] init];
                modifyVC.type = 2;
                modifyVC.text = model.signature;
                [self.navigationController pushViewController:modifyVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            [_settingTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }else if (indexPath.row == 1) {
            //FAQ
            FeedbackIdeaController *feedbackvc = [[FeedbackIdeaController alloc] init];
            [self.navigationController pushViewController:feedbackvc animated:YES];
            
        }else if (indexPath.row == 2) {
            AboutMeViewController *aboutVC = [[AboutMeViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
        else if (indexPath.row == 3) {
            
            UIAlertController *exitAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to quit your current account?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                [DEFAULTS setBool:YES forKey:@"isLogout"];
                
                LoginBrigeViewController *guideVC = [[LoginBrigeViewController alloc] init];
//                [UIApplication sharedApplication].delegate.window.rootViewController = guideVC;
                [self presentViewController:guideVC animated:YES completion:nil];
            }];
            
            [exitAlert addAction:cancelAction];
            [exitAlert addAction:sureAction];
            [self presentViewController:exitAlert animated:YES completion:nil];
        }
    }
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
    CGFloat w = 150;
    CGFloat h = (w/image.size.width)*image.size.height;
    UIImage *newImage = [self imageWithImage:image scaledToSize:CGSizeMake(w, h)];
    [self saveImage:newImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
