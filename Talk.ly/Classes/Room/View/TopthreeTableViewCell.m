//
//  TopthreeTableViewCell.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/20.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "TopthreeTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import <UIImageView+WebCache.h>

@implementation TopthreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"icon-people"];
    _iconImageView.layer.cornerRadius = 32;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _rankbgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_rankbgImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = k51Color;
    _nameLabel.text = @"name";
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 13)];
    _genderLabel.textColor = k102Color;
    _genderLabel.font = [UIFont systemFontOfSize:13];
    _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%d",18]];
    [_genderLabel sizeToFit];
    [self.contentView addSubview:_genderLabel];
    
    _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(_genderLabel.right+kSpace, 0, 50, 20)];
    _levelLabel.backgroundColor = kBlueColor;
    _levelLabel.font = [UIFont systemFontOfSize:13];
    _levelLabel.textColor = [UIColor whiteColor];
    _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"star" bounds:CGRectMake(5, 0, 10, 10) str:[NSString stringWithFormat:@" %d",18]];
    _levelLabel.layer.cornerRadius = kCellSpace;
    _levelLabel.layer.masksToBounds = YES;
    [_levelLabel sizeToFit];
    [self.contentView addSubview:_levelLabel];
    
    _contributionLabel = [[UILabel alloc] init];
    _contributionLabel.textColor = k153Color;
    _contributionLabel.font = [UIFont systemFontOfSize:12];
    _contributionLabel.text = [NSString stringWithFormat:@"%d coin",0];
    [_contributionLabel sizeToFit];
    [self.contentView addSubview:_contributionLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.contentView.mas_left).offset(2*kSpace);
        make.width.height.equalTo(@64);
    }];
    [_rankbgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(_iconImageView.mas_centerY);
        make.centerX.mas_equalTo(_iconImageView.mas_centerX);
        make.width.height.equalTo(@100);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_rankbgImageView.mas_right).offset(kSpace);
        make.bottom.mas_equalTo(_rankbgImageView.mas_centerY).offset(-3);
    }];
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_rankbgImageView.mas_centerY).offset(3);
        make.left.mas_equalTo(_rankbgImageView.mas_right).offset(kSpace);
    }];
    [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(_genderLabel.mas_centerY);
        make.left.mas_equalTo(_genderLabel.mas_right).offset(kCellSpace);
    }];
    [_contributionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2*kSpace);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setModel:(UserModel *)model {
    _model = model;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _nameLabel.text = _model.name;
    
    if ([_model.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_model.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",(long)[_model.age integerValue]]];
    }
    [_genderLabel sizeToFit];
    
     _levelLabel.attributedText = [DataService createAttributedStringWithImageName:@"star" bounds:CGRectMake(5, 0, 10, 10) str:[NSString stringWithFormat:@" %@",_model.active_lv]];
    [_levelLabel sizeToFit];
    
    if ([_model.contribute isEqualToString:@""] || !_model.contribute) {
        _model.contribute = @"0";
    }
    _contributionLabel.text = [NSString stringWithFormat:@"%@ coin",_model.contribute];
}

@end
