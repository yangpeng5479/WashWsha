//
//  FriendRequestTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FriendRequestTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "DataService.h"


@implementation FriendRequestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI:reuseIdentifier];
    }
    return self;
}

- (void)setupUI:(NSString *)str {
    
    if ([str isEqualToString:@"0"]) {
        self.onlineLabel.hidden = YES;
        
        _genderLabel = [[UILabel alloc] init];
        _genderLabel.textColor = k102Color;
        _genderLabel.font = [UIFont systemFontOfSize:12];
        [_genderLabel sizeToFit];
        [self addSubview:_genderLabel];
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.backgroundColor = kNavColor;
        [_followBtn setTitle:@"Follow" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_followBtn xw_roundedCornerWithRadius:5 cornerColor:[UIColor whiteColor]];
        [self addSubview:_followBtn];
        
        [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(self.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.offset(50);
            make.height.offset(27);
        }];
    }else {
        self.onlineLabel.text = @"Following";
    }
}

- (void)setFansModel:(UserModel *)fansModel {
    _fansModel = fansModel;
    self.nameLabel.text = _fansModel.name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_fansModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    self.maleCountLable.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_fansModel.active_lv integerValue]]];
    self.femaleCountLable.attributedText = [DataService createAttributedStringWithImageName:@"icon-wallet" bounds:CGRectMake(0, -1, 12, 12) str:[NSString stringWithFormat:@"%ld",[_fansModel.wealth_lv integerValue]]];
    self.locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"heart1" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_fansModel.charm_lv integerValue]]];
    if ([_fansModel.signature isEqualToString:@""] || !_fansModel.signature) {
        self.signatureLabel.text = @"No signature set!";
    }else {
        self.signatureLabel.text = _fansModel.signature;
    }
    if ([_fansModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",[_fansModel.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",[_fansModel.age integerValue]]];
    }
}

- (void)setFriendModel:(UserModel *)friendModel {
    _friendModel = friendModel;
    self.nameLabel.text = _friendModel.name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_friendModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    self.maleCountLable.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_friendModel.active_lv integerValue]]];
    self.femaleCountLable.attributedText = [DataService createAttributedStringWithImageName:@"icon-wallet" bounds:CGRectMake(0, -1, 12, 12) str:[NSString stringWithFormat:@"%ld",[_friendModel.wealth_lv integerValue]]];
    self.locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"heart1" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[_friendModel.charm_lv integerValue]]];
    if ([_friendModel.signature isEqualToString:@""] || !_friendModel.signature) {
        self.signatureLabel.text = @"No signature set!";
    }else {
        self.signatureLabel.text = _friendModel.signature;
    }
    if ([_friendModel.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",[_friendModel.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",[_friendModel.age integerValue]]];
    }
}

@end
