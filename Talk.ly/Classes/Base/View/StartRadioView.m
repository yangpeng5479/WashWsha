//
//  StartRadioView.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "StartRadioView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "WYFileManager.h"
#import "UserModel.h"
#import "DataService.h"

@implementation StartRadioView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void) setupUI{
    
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    _imagebg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _imagebg.contentMode = UIViewContentModeScaleAspectFill;
    [_imagebg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurView.frame = _imagebg.bounds;
    [_imagebg addSubview:blurView];
    [self addSubview:_imagebg];
    
    NSDictionary *dic = [WYFileManager getCustomObjectWithKey:@"location"];
    [AccountManager sharedAccountManager].locationDic = dic;
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.font = [UIFont systemFontOfSize:13];
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.shadowColor = k51Color;
    _locationLabel.shadowOffset = CGSizeMake(1, 1);
    if ([model.country isEqualToString:@""] && dic != nil) {
        model.country = [NSString stringWithFormat:@"%@",[AccountManager sharedAccountManager].locationDic[@"city"]];
    }else {
        model.country = @"Unknow";
    }
    _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-locate" bounds:CGRectMake(0, -2, 13, 13) str:model.country];
    [_locationLabel sizeToFit];
    [self addSubview:_locationLabel];
    
//    _nameLabel = [[UILabel alloc] init];
//    _nameLabel.font = [UIFont systemFontOfSize:18];
//    _nameLabel.textColor = [UIColor whiteColor];
//    _nameLabel.shadowColor = k153Color;
//    _nameLabel.shadowOffset = CGSizeMake(1, 1);
//    _nameLabel.text = @"Radio Name";
//    [self addSubview:_nameLabel];
    
    _titleTF = [[UITextField alloc] init];
    _titleTF.borderStyle = UITextBorderStyleNone;
    _titleTF.backgroundColor = [UIColor clearColor];
    _titleTF.font = [UIFont fontWithName:@"Arial-BoldMT" size:26];
    _titleTF.textColor = [UIColor whiteColor];
    _titleTF.placeholder = @"Title Your Channel";
    _titleTF.layer.shadowColor = k51Color.CGColor;
    _titleTF.layer.shadowOffset = CGSizeMake(1, 1);
    [_titleTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_titleTF];
    
//    _descrbeLabel = [[UILabel alloc] init];
//    _descrbeLabel.font = [UIFont systemFontOfSize:18];
//    _descrbeLabel.textColor = [UIColor whiteColor];
//    _descrbeLabel.shadowColor = k153Color;
//    _descrbeLabel.shadowOffset = CGSizeMake(1, 1);
//    _descrbeLabel.text = @"Room description";
//    [self addSubview:_descrbeLabel];
    
    _decTF = [[UITextField alloc] init];
    _decTF.borderStyle = UITextBorderStyleNone;
    _decTF.backgroundColor = [UIColor clearColor];
    _decTF.font = [UIFont fontWithName:@"Arial-BoldMT" size:20];
    _decTF.textColor = [UIColor whiteColor];
    _decTF.placeholder = @"Enter Your Room's Description";
    _decTF.layer.shadowColor = k51Color.CGColor;
    _decTF.layer.shadowOffset = CGSizeMake(1, 1);
    [_decTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self addSubview:_decTF];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon-Close-white"] forState:UIControlStateNormal];
    [self addSubview:_closeBtn];
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.backgroundColor =kBlueColor;
    [_startBtn setTitle:@"Start Radio" forState:UIControlStateNormal];
    [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _startBtn.layer.cornerRadius = 20;
    _startBtn.layer.masksToBounds = YES;
    [self addSubview:_startBtn];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(2*kSpace);
        make.top.mas_equalTo(self.mas_top).offset(3*kSpace);
    }];
//    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.mas_left).offset(3*kSpace);
//        make.top.mas_equalTo(_locationLabel.mas_bottom).offset(4*kSpace);
//    }];
    [_titleTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(3*kSpace);
        make.right.mas_equalTo(self.mas_right).offset(-3*kSpace);
        make.top.mas_equalTo(_locationLabel.mas_bottom).offset(5*kSpace);
        make.height.offset(30);
    }];
    
//    [_descrbeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(_nameLabel.mas_left);
//        make.top.mas_equalTo(_titleTF.mas_bottom).offset(2*kSpace);
//    }];
    [_decTF mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleTF.mas_left);
        make.right.mas_equalTo(self.mas_right).offset(-3*kSpace);
        make.top.mas_equalTo(_titleTF.mas_bottom).offset(2*kSpace);
        make.height.offset(22);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).offset(-2*kSpace);
        make.top.mas_equalTo(self.mas_top).offset(3*kSpace);
        make.width.height.equalTo(@30);
    }];
    
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5*kSpace);
        make.width.offset(150);
        make.height.offset(40);
    }];
}

@end
