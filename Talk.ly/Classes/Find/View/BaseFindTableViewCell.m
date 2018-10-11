//
//  BaseFindTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseFindTableViewCell.h"
#import "DataService.h"
#import <Masonry.h>
#import "CommonPrex.h"
#import <UIImageView+WebCache.h>

@implementation BaseFindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _configureUI];
    }
    return self;
}

- (void)_configureUI {
    
    _leveImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_leveImageView];
    
    _rankLabel = [[UILabel alloc] init];
    _rankLabel.font = [UIFont systemFontOfSize:10];
    _rankLabel.textColor = k51Color;
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView insertSubview:_rankLabel aboveSubview:_leveImageView];
    
    _iconImageView = [[UIImageView alloc] init];
    [_iconImageView xw_roundedCornerWithRadius:25 cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = k51Color;
    _nameLabel.text = @"NAME";
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    
    _levelLabel = [[UILabel alloc] init];
    _levelLabel.font = [UIFont systemFontOfSize:13];
    _levelLabel.textColor = k102Color;
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -2, 13, 13) str:@"0"];
    [self.contentView addSubview:_levelLabel];
    
    _genderLabel = [[UILabel alloc] init];
    _genderLabel.font = [UIFont systemFontOfSize:13];
    _genderLabel.textColor = k102Color;
    _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 6, 13) str:@"18"];
    [self.contentView addSubview:_genderLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69.5, kScreenWidth, 0.3)];
    lineLabel.backgroundColor = kLineColor;
    [self.contentView addSubview:lineLabel];
    
    [self _addcontraint];
}

- (void)_addcontraint {
    
    [_leveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(30);
        make.height.offset(30);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_leveImageView.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconImageView.mas_right).offset(kSpace);
        make.top.mas_equalTo(_iconImageView.mas_top);
    }];
    
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.bottom.mas_equalTo(_iconImageView.mas_bottom);
    }];
    
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_leveImageView.mas_centerX);
        make.centerY.mas_equalTo(_leveImageView.mas_centerY);
        make.width.height.equalTo(@15);
    }];
}

- (void)setLevelModel:(UserModel *)levelModel {
    _levelModel = levelModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_levelModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _nameLabel.text = _levelModel.name;
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -2, 12, 12) str:[NSString stringWithFormat:@"%ld",(long)[_levelModel.active_lv integerValue]]];
    if ([_levelModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_levelModel.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_levelModel.age integerValue]]];
    }
}

- (void)setWealthModel:(UserModel *)wealthModel {
    _wealthModel = wealthModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_wealthModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _nameLabel.text = _wealthModel.name;
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-wallet" bounds:CGRectMake(0, -2, 12, 10) str:[NSString stringWithFormat:@"%ld",(long)[_wealthModel.wealth_lv integerValue]]];
    if ([_wealthModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_wealthModel.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_wealthModel.age integerValue]]];
    }
}

- (void)setCharmModel:(UserModel *)charmModel {
    _charmModel = charmModel;
    _nameLabel.text = _charmModel.name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_charmModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"heart1" bounds:CGRectMake(0, -2, 12, 12) str:[NSString stringWithFormat:@"%ld",(long)[_charmModel.charm_lv integerValue]]];
    if ([_charmModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_charmModel.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_charmModel.age integerValue]]];
    }
}

- (void)setGuardianModel:(UserModel *)guardianModel {
    _guardianModel = guardianModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_guardianModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _nameLabel.text = _guardianModel.name;
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"gift" bounds:CGRectMake(0, -3, 12, 12) str:_guardianModel.active_lv];
    if ([_guardianModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -3, 10, 10) str:_guardianModel.age];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -3, 10, 10) str:_guardianModel.age];
    }
}







@end
