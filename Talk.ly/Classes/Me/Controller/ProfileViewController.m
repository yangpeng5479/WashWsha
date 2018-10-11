//
//  ProfileViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/29.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ProfileViewController.h"
#import "ContributeTopView.h"
#import "CommonPrex.h"
#import "GiftCollectionViewCell.h"
#import <Masonry.h>
#import "UserSettingViewController.h"
#import "DataService.h"
#import <UIImageView+WebCache.h>
#import "WYFileManager.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "GiftModel.h"
#import "GuardianTopViewController.h"

@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UITableView *profileTV;
@property(nonatomic,strong)ContributeTopView *contributeView;
@property(nonatomic,strong)UICollectionView *giftCollectionView;
@property(nonatomic,strong)NSMutableArray *giftArr;
@property(nonatomic,strong)NSArray *guardianArr;
@property(nonatomic,strong)UserModel *userModel;;

@end

@implementation ProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.type == 1) {
        [self loadMeData];
    }else {
        [self getUserInfoData];
    }
    [self loadGuardianData];
    [self getGiftBoxData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataService changeReturnButton:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _profileTV = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    if (IS_IPHONE_X) {
        _profileTV.frame = CGRectMake(0, -44, kScreenWidth, kScreenHeight);
    }
    _profileTV.backgroundColor = [UIColor whiteColor];
    _profileTV.dataSource = self;
    _profileTV.delegate = self;
    _profileTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _profileTV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_profileTV];
    
    //返回
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSpace, 30, 25, 25)];
    if (IS_IPHONE_X) {
        backBtn.frame = CGRectMake(kSpace, 44, 25, 25);
    }
    [backBtn setImage:[UIImage imageNamed:@"icon-Back-white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    if (self.type == 2) {
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kSpace-25, 30, 25, 25)];
        [moreBtn setImage:[UIImage imageNamed:@"icon-moredian"] forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:moreBtn];
        if (IS_IPHONE_X) {
            moreBtn.frame = CGRectMake(kScreenWidth-kSpace-25, 44, 25, 25);
        }
    }
}

//懒加载贡献榜
- (ContributeTopView *)contributeView {
    if (!_contributeView) {
        
        _contributeView = [[ContributeTopView alloc] initWithFrame:CGRectMake(2*kSpace, 0, 130, 60)];
    }
    return _contributeView;
}

#pragma mark - 数据获取
//获取守护排行榜
- (void)loadGuardianData {
    NSDictionary *dic = @{@"user_id":self.uid,@"page":@1,@"limit":@3};
    [DataService postWithURL:@"rest3/v1/Top/guarders" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"guarders"];
            _guardianArr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
            [_profileTV reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

//获取个人详情
- (void)loadMeData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic =@{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/user/get_my_info" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"ME:%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"user_info"];
            _userModel = [UserModel mj_objectWithKeyValues:diction];
            [WYFileManager setCustomObject:_userModel forKey:@"userModel"];
            [_profileTV reloadData];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

//获取他人信息
- (void)getUserInfoData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic =@{@"token":[AccountManager sharedAccountManager].token,@"host_user_id":self.uid};
    [DataService postWithURL:@"rest3/v1/user/get_host_user_info" type:1 params:dic fileData:nil success:^(id data) {
        
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *userDic = data[@"data"];
             _userModel = [UserModel mj_objectWithKeyValues:userDic];
            [_profileTV reloadData];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

//获取礼物盒子
- (void)getGiftBoxData {
    NSDictionary *dic = @{@"user_id":self.uid};
    [DataService postWithURL:@"rest3/v1/gift/my_gift_box" type:1 params:dic fileData:nil success:^(id data) {
        
        NSArray *arr = data[@"data"][@"gift_list"];
        _giftArr = [GiftModel mj_objectArrayWithKeyValuesArray:arr];
        [_giftCollectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

//关注 取消关注
- (void)followOrUnfollowData:(NSString *)url btn:(UIButton *)sender {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"star_user_id":self.uid};
    [DataService postWithURL:url type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            _userModel.has_follow = !_userModel;
            if (_userModel.has_follow) {
                [sender setTitle:@"Unfollow" forState:UIControlStateNormal];
            }else {
                [sender setTitle:@"Follow" forState:UIControlStateNormal];
            }
            [_profileTV reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

//礼物
- (UICollectionView *)giftCollectionView {
    
    if (!_giftCollectionView) {
        CGFloat w = (kScreenWidth-2*kSpace)/4;
        CGFloat imagew = (w-2*kSpace)/2;
        CGFloat h = imagew+5*kSpace;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(w, h);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, 0, kSpace);
        
        _giftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kSpace, kScreenWidth, 2*h*3) collectionViewLayout:layout];
        _giftCollectionView.backgroundColor = [UIColor clearColor];
        _giftCollectionView.delegate = self;
        _giftCollectionView.dataSource = self;
        _giftCollectionView.scrollEnabled = NO;
        _giftCollectionView.showsVerticalScrollIndicator = NO;
        [_giftCollectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:@"gift"];
    }
    return _giftCollectionView;
}

#pragma mark - 点击事件
- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreBtnAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *block = [UIAlertAction actionWithTitle:@"Block" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [DataService toastWithMessage:@"Block Success"];
    }];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [DataService toastWithMessage:@"Report Success"];
    }];
    [alert addAction:cancel];
    [alert addAction:report];
    [alert addAction:block];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//编辑个人信息
- (void)editBtnAction:(UIButton *)sender {
    if (self.type == 1) {
        UserSettingViewController *vc= [[UserSettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
        if (_userModel.has_follow) {
            //已关注  点击取消关注
            [self followOrUnfollowData:@"rest3/v1/follow/unfollow" btn:sender];
        }else {
            //未关注 点击关注
            [self followOrUnfollowData:@"rest3/v1/follow/follow" btn:sender];
        }
    }
}

//排行旁
- (void)contributeTopAction {
    NSLog(@"paiahngbang");
}

#pragma mark - collectionview's delegate datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [AccountManager sharedAccountManager].imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftCollectionViewCell *cell = (GiftCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"gift" forIndexPath:indexPath];
    GiftModel *model = _giftArr[indexPath.row];
    
    cell.giftNameLable.text = [NSString stringWithFormat:@"x%ld",model.count];
    if (model.count == 0) {
        cell.giftImageView.image = [UIImage imageNamed:[AccountManager sharedAccountManager].grayImageArr[indexPath.item]];
    }else {
        cell.giftImageView.image = [UIImage imageNamed:[AccountManager sharedAccountManager].imageArr[indexPath.item]];
    }
    return cell;
}

#pragma mark - tableview's delegate datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    [bgimageView sd_setImageWithURL:[NSURL URLWithString:_userModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    bgimageView.contentMode = UIViewContentModeScaleAspectFill;
    bgimageView.clipsToBounds = YES;
    
    //模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurView.frame = bgimageView.bounds;
    [bgimageView addSubview:blurView];
    [view addSubview:bgimageView];
    
    //头像
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(2*kSpace, bgimageView.bottom-30, 60, 60)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:_userModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    iconView.layer.cornerRadius = 30;
    iconView.layer.masksToBounds = YES;
    iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconView.layer.borderWidth = 2;
    [view addSubview:iconView];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-110, bgimageView.bottom+kSpace, 100, 20)];
    [rightBtn setTitleColor:k102Color forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBtn.layer.cornerRadius = kSpace;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderColor = k51Color.CGColor;
    rightBtn.layer.borderWidth = 1;
    [rightBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    if (self.type == 1) {
        [rightBtn setTitle:@"Edit Profile" forState:UIControlStateNormal];
    }else {
        if (_userModel.has_follow) {
            [rightBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
        }else {
            [rightBtn setTitle:@"Follow" forState:UIControlStateNormal];
        }
        
    }
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _userModel.name;
    nameLabel.textColor = k51Color;
    nameLabel.font = [UIFont systemFontOfSize:17];
    [nameLabel sizeToFit];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(iconView.mas_left);
        make.top.mas_equalTo(iconView.mas_bottom).offset(kSpace);
    }];
    
    //性别年龄
    UILabel *gendeLabel = [[UILabel alloc] init];
    gendeLabel.textColor = k102Color;
    gendeLabel.font = [UIFont systemFontOfSize:13];
    if ([_userModel.gender isEqualToString:@"male"]) {
        gendeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -1, 11, 11) str:_userModel.age];
    }else {
        gendeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -1, 11, 11) str:_userModel.age];
    }
    
    [gendeLabel sizeToFit];
    [view addSubview:gendeLabel];
    [gendeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(nameLabel.mas_right).offset(kSpace);
        make.bottom.mas_equalTo(nameLabel.mas_bottom);
    }];
    
    //ID
    UILabel *IDLable = [[UILabel alloc] init];
    IDLable.font = [UIFont systemFontOfSize:13];
    IDLable.textColor = k153Color;
    IDLable.text = [NSString stringWithFormat:@"ID:%@",_userModel.user_id];
    [IDLable sizeToFit];
    [view addSubview:IDLable];
    [IDLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_left);
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(kSpace);
    }];
    
    //个性签名
    UILabel *signatureLabel = [[UILabel alloc] init];
    signatureLabel.font = [UIFont systemFontOfSize:13];
    signatureLabel.textColor = k102Color;
    if ([_userModel.signature isEqualToString:@""]) {
        signatureLabel.text = @"No personal signature";
    }else {
        signatureLabel.text = _userModel.signature;
    }
    
    signatureLabel.textAlignment = NSTextAlignmentLeft;
    signatureLabel.numberOfLines = 2;
    [view addSubview:signatureLabel];
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(IDLable.mas_left);
        make.right.mas_equalTo(view.mas_right).offset(-3*kSpace);
        make.top.mas_equalTo(IDLable.mas_bottom).offset(kSpace);
        make.height.offset(40);
    }];
    
    //位置
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.textColor = k153Color;
    locationLabel.font = [UIFont systemFontOfSize:13];
    if ([_userModel.country isEqualToString:@""]) {
        locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-location" bounds:CGRectMake(0, -1, 9, 12) str:@"Unknown"];
    }else {
        locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-location" bounds:CGRectMake(0, -1, 9, 12) str:_userModel.country];
    }
    
    [locationLabel sizeToFit];
    [view addSubview:locationLabel];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(signatureLabel.mas_left);
        make.top.mas_equalTo(signatureLabel.mas_bottom).offset(kSpace);
    }];
    
    //关注
    UILabel *followLabel = [[UILabel alloc] init];
    followLabel.font = [UIFont systemFontOfSize:13];
    followLabel.textColor = k153Color;
    followLabel.text = [NSString stringWithFormat:@"%ld Following",[_userModel.follow_info[@"star_count"] integerValue]];
    [followLabel sizeToFit];
    [view addSubview:followLabel];
    [followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(locationLabel.mas_left);
        make.top.mas_equalTo(locationLabel.mas_bottom).offset(kSpace);
    }];
    
    //粉丝
    UILabel *fansLabel = [[UILabel alloc] init];
    fansLabel.textColor = k153Color;
    fansLabel.font = [UIFont systemFontOfSize:13];
    fansLabel.text = [NSString stringWithFormat:@"%ld Followers",[_userModel.follow_info[@"follower_count"] integerValue]];
    [fansLabel sizeToFit];
    [view addSubview:fansLabel];
    [fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(followLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(followLabel.mas_centerY);
    }];
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *vie = [[UIView alloc] init];
    vie.backgroundColor = [UIColor whiteColor];
    [vie addSubview:self.giftCollectionView];
    return vie;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 360;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat w = (kScreenWidth-2*kSpace)/4;
    CGFloat imagew = (w-2*kSpace)/2;
    CGFloat h = imagew+5*kSpace;
    return 6*h+2*kSpace;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"me"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"me"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView addSubview:self.contributeView];
    _contributeView.contributeArr = _guardianArr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GuardianTopViewController *topVC = [[GuardianTopViewController alloc] init];
    topVC.uid = self.uid;
    [self.navigationController pushViewController:topVC animated:YES];
}

- (UIImage *)grayImage:(UIImage *)sourceImage {
    
    CGRect imagerect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    UIGraphicsBeginImageContextWithOptions(imagerect.size, NO, sourceImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [sourceImage drawInRect:imagerect];
    UIColor *color = [UIColor darkGrayColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetAlpha(context, 0.7);
    CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
    CGContextFillRect(context, imagerect);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:imageRef];
    UIGraphicsEndImageContext();
    return grayImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
