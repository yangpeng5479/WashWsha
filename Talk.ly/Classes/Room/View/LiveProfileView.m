//
//  LiveProfileView.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/14.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LiveProfileView.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation LiveProfileView

- (instancetype)initWithFrame:(CGRect)frame withUserModel:(UserModel *)model {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI:model];
    }
    return self;
}

- (void)setupUI:(UserModel *)model {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = kCellSpace;
    self.layer.masksToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    imageView.layer.cornerRadius = 45;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(2*kSpace);
        make.width.height.offset(90);
    }];
    
    if (![model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:[UIImage imageNamed:@"icon-more1"] forState:UIControlStateNormal];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.mas_right).offset(-kSpace);
            make.top.mas_equalTo(self.mas_top).offset(kSpace);
            make.width.height.equalTo(@20);
        }];
    }
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = model.name;
    _nameLabel.textColor = k51Color;
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_nameLabel sizeToFit];
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(kSpace);
    }];
    
    _bgview = [[UIView alloc] init];
    _bgview.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgview];
    
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 13)];
    _genderLabel.textColor = k102Color;
    _genderLabel.font = [UIFont systemFontOfSize:12];
   
    if ([model.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[model.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[model.age integerValue]]];
    }
    [_genderLabel sizeToFit];
    [_bgview addSubview:_genderLabel];

    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_genderLabel.right+kSpace, 0, 50, 20)];
    _levelLabel.backgroundColor = kBlueColor;
    _levelLabel.font = [UIFont systemFontOfSize:13];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"star" bounds:CGRectMake(5, 0, 10, 10) str:[NSString stringWithFormat:@" %@",model.active_lv]];
    _levelLabel.layer.cornerRadius = kCellSpace;
    _levelLabel.layer.masksToBounds = YES;
    [_levelLabel sizeToFit];
    [_bgview addSubview:_levelLabel];
    
    
    _IDLocationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _bgview.bottom+kSpace, 50, 30)];
    _IDLocationLabel.textColor = k102Color;
    _IDLocationLabel.font = [UIFont systemFontOfSize:12];
    if ([model.country isEqualToString:@""]) {
        model.country = @"Unknown";
    }
    _IDLocationLabel.text = [NSString stringWithFormat:@"ID: %@ | %@",model.user_id,model.country];
    [_IDLocationLabel sizeToFit];
    [self addSubview:_IDLocationLabel];
    [_IDLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_bgview.mas_bottom).offset(kSpace);
    }];
    
    NSMutableArray *labelArr = [NSMutableArray array];
    for (int i = 0; i < 4; ++i) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kBlueColor;
        label.font = [UIFont systemFontOfSize:17];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"%@",model.follow_info[@"follower_count"]];
        }else if (i == 1) {
            label.text = [NSString stringWithFormat:@"%@",model.follow_info[@"star_count"]];
        }else if (i == 2) {
            label.text = model.expend;
        }else {
            label.text = model.income;
        }
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        [labelArr addObject:label];
    }
    
    CGFloat w = self.width/4;
    [labelArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:w leadSpacing:0 tailSpacing:0];
    [labelArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_IDLocationLabel.mas_bottom).offset(2*kSpace);
        make.height.offset(20);
    }];
    NSArray *titleArr = @[@"Following",@"Followers",@"Send",@"Income"];
    NSMutableArray *contentMarr = [NSMutableArray array];
    for (int i = 0; i < 4; ++i) {
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:13];
        contentLabel.textColor = k153Color;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.text = titleArr[i];
        
        [self addSubview:contentLabel];
        [contentMarr addObject:contentLabel];
    }
    [contentMarr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:w leadSpacing:0 tailSpacing:0];
    [contentMarr mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(_IDLocationLabel.mas_bottom).offset(45);
        make.height.offset(15);
    }];
    
    
    NSArray *arr = [NSArray array];
    if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
        arr = @[@"Profile"];
    }else {
        if (model.has_follow) {
            arr = @[@"Followed",@"@him",@"Profile"];
        }else {
            arr = @[@"Follow",@"@him",@"Profile"];
        }
    }
    
    CGFloat btnW = self.width/arr.count;
    for (int i = 0; i < arr.count; ++i) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnW, self.height-50, btnW, 50)];;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:k102Color forState:UIControlStateNormal];
        btn.tag = 510+i;
        [self addSubview:btn];
    }
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSpace, self.height-51, self.width-2*kSpace, 0.5)];
    lineLabel.backgroundColor = kLineColor;
    [self addSubview:lineLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = _genderLabel.width + _levelLabel.width + kSpace;
    _bgview.frame = CGRectMake((kScreenWidth-40-w)/2, _nameLabel.bottom+kSpace, w, 15);
    _nameLabel.x = (kScreenWidth-40-_nameLabel.width)/2;
    _IDLocationLabel.x = (kScreenWidth-40-_IDLocationLabel.width)/2;
}

@end
