//
//  SearchUserTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/27.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SearchUserTableViewCell.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation SearchUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _configureCell];
    }
    return self;
}

- (void)_configureCell {
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"icon-people"];
    [_iconImageView xw_roundedCornerWithRadius:25 cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = k51Color;
    _nameLabel.text = @"Name";
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    
    _activityLabel = [[UILabel alloc] init];
    _activityLabel.textColor = k102Color;
    _activityLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -2, 13, 13) str:@"0"];
    _activityLabel.font = [UIFont systemFontOfSize:12];
    [_activityLabel sizeToFit];
    [self.contentView addSubview:_activityLabel];
    
    _genderLabel = [[UILabel alloc] init];
    _genderLabel.textColor = k102Color;
    _genderLabel.font = [UIFont systemFontOfSize:12];
    _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-boy" bounds:CGRectMake(0, -2, 6, 13) str:@"18"];
    [_genderLabel sizeToFit];
    [self.contentView addSubview:_genderLabel];
    
    _signatureLabel = [[UILabel alloc] init];
    _signatureLabel.font = [UIFont systemFontOfSize:12];
    _signatureLabel.text = @"Signature";
    _signatureLabel.textColor = k153Color;
    [self.contentView addSubview:_signatureLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69.5, kScreenWidth, 0.3)];
    lineLabel.backgroundColor =kLineColor;
    [self.contentView addSubview:lineLabel];
    
    [self addcontraintWithSubview];
}
- (void)addcontraintWithSubview {
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left).offset(kSpace);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.equalTo(@50);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconImageView.mas_right).offset(kCellSpace);
        make.top.mas_equalTo(_iconImageView.mas_top).offset(kSpace);
    }];
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
    }];
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_activityLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_activityLabel.mas_centerY);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.bottom.mas_equalTo(_iconImageView.mas_bottom).offset(-kCellSpace);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kSpace);
        make.height.offset(13);
    }];
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _nameLabel.text = _userModel.name;
    _activityLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_userModel.active_lv integerValue]]];
    if ([_userModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_userModel.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 13) str:[NSString stringWithFormat:@"%ld",(long)[_userModel.age integerValue]]];
    }
    if ([_userModel.signature isEqualToString:@""] || !_userModel.signature) {
        _signatureLabel.text = @"No signature set";
    }else {
        _signatureLabel.text = _userModel.signature;
    }
    
}



@end
