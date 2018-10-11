//
//  FollowTableViewCell.m
//  video
//
//  Created by 杨鹏 on 2018/5/23.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import "FollowTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import <UIImageView+WebCache.h>

@implementation FollowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.cornerRadius = 25;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = k51Color;
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    
    _ageAndGenderLabel = [[UILabel alloc] init];
    _ageAndGenderLabel.font = [UIFont systemFontOfSize:15];
    _ageAndGenderLabel.textColor = k153Color;
    [_ageAndGenderLabel sizeToFit];
    [self.contentView addSubview:_ageAndGenderLabel];
    
    _unFollowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _unFollowBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_unFollowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
    [_unFollowBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    _unFollowBtn.layer.cornerRadius = kSpace;
    _unFollowBtn.layer.masksToBounds = YES;
    _unFollowBtn.layer.borderColor = kLineColor.CGColor;
    _unFollowBtn.layer.borderWidth = 1;
    [self.contentView addSubview:_unFollowBtn];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69.7, kScreenWidth, 0.3)];
    lineLabel.backgroundColor = kLineColor;
    [self.contentView addSubview:lineLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left).offset(kSpace);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.equalTo(@50);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(kSpace);
        make.top.mas_equalTo(self.iconImageView.mas_top);
    }];
    [_ageAndGenderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
    }];
    [_unFollowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kSpace);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.offset(7*kSpace);
        make.height.offset(2*kSpace);
    }];
}

- (void)setModel:(FollowModel *)model {
    _model = model;
    
    _nameLabel.text = _model.name;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    
    if (!_model.age) {
        _model.age = 18;
    }
    if ([model.gender isEqualToString:@"male"]) {
         _ageAndGenderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -1, 12, 12) str:[NSString stringWithFormat:@"%ld",_model.age]];
    }else {
        _ageAndGenderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -1, 12, 12) str:[NSString stringWithFormat:@"%ld",_model.age]];
    }
   
}

@end
