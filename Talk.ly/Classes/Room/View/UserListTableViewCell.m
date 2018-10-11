//
//  UserListTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/23.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "UserListTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "DataService.h"

@implementation UserListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self _configureCell];
    }
    
    return self;
}

- (void)_configureCell {
    
    _iconImageView = [[UIImageView alloc] init];
    [_iconImageView xw_roundedCornerWithRadius:35 cornerColor:[UIColor whiteColor]];
    [self addSubview:_iconImageView];
    
    //名字
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor =k51Color;
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [_nameLabel sizeToFit];
    _nameLabel.text = @"Name";
    [self addSubview:_nameLabel];
    
    //性别年龄
    _ageLabel = [[UILabel alloc] init];
    _ageLabel.font = [UIFont systemFontOfSize:15];
    _ageLabel.textColor = k102Color;
    [_ageLabel sizeToFit];
    _ageLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 11, 11) str:@"18"];
    [self addSubview:_ageLabel];
    
    //活跃等级
    _activityLabel = [[UILabel alloc] init];
    _activityLabel.textColor = k51Color;
    _activityLabel.font = [UIFont systemFontOfSize:15];
    [_activityLabel sizeToFit];
    _activityLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -3, 12, 12) str:@"0"];
    [self addSubview:_activityLabel];
    
    _heartLabel = [[UILabel alloc] init];
    _heartLabel.font = [UIFont systemFontOfSize:15];
    _heartLabel.textColor = k51Color;
    [_heartLabel sizeToFit];
    _heartLabel.attributedText = [DataService createAttributedStringWithImageName:@"heart1" bounds:CGRectMake(0, -3, 12, 12) str:@"0"];
    [self addSubview:_heartLabel];
    
    //财富
    _wealthLabel = [[UILabel alloc] init];
    _wealthLabel.font = [UIFont systemFontOfSize:15];
    _wealthLabel.textColor = k51Color;
    [_wealthLabel sizeToFit];
    _wealthLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-wallet" bounds:CGRectMake(0, -3, 12, 12) str:@"0"];
    [self addSubview:_wealthLabel];
    
    //添加约束
    [self addcontraintView];
}

- (void)addcontraintView {
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(kSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(70);
        make.height.offset(70);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconImageView.mas_right).offset(kSpace);
        make.top.mas_equalTo(_iconImageView.mas_top).offset(kCellSpace);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
    }];
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.bottom.mas_equalTo(_iconImageView.mas_bottom).offset(-kCellSpace);
    }];
    [_heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_activityLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_activityLabel.mas_centerY);
    }];
    [_wealthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_heartLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_heartLabel.mas_centerY);
    }];
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_userModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    
    _nameLabel.text = _userModel.name;
    
    _ageLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 11, 11) str:[NSString stringWithFormat:@"%ld",[_userModel.age integerValue]]];
    
    _activityLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_userModel.active_lv integerValue]]];
    
    _heartLabel.attributedText = [DataService createAttributedStringWithImageName:@"heart1" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_userModel.charm_lv integerValue]]];
    
    _wealthLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-wallet" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_userModel.wealth_lv integerValue]]];
    
}












@end
