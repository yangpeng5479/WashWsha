//
//  BaseTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "DataService.h"

@implementation BaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self _configureCell];
    }
    return self;
}

- (void)_configureCell {
    
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"icon-people"];
    [_iconView xw_roundedCornerWithRadius:5 cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = k51Color;
    _nameLabel.text = @"name";
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    
    _maleCountLable = [[UILabel alloc] init];
    _maleCountLable.textColor = k102Color;
    [_maleCountLable sizeToFit];
    _maleCountLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_maleCountLable];
    
    _femaleCountLable = [[UILabel alloc] init];
    _femaleCountLable.textColor = k102Color;
    [_femaleCountLable sizeToFit];
    _femaleCountLable.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_femaleCountLable];
    
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.textColor = k102Color;
    [_locationLabel sizeToFit];
    _locationLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_locationLabel];
    
    _signatureLabel = [[UILabel alloc] init];
    _signatureLabel.textColor = k153Color;
    _signatureLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_signatureLabel];
    
    _onlineLabel = [[UILabel alloc] init];
    _onlineLabel.font = [UIFont systemFontOfSize:16];
    _onlineLabel.textColor = k102Color;
    _onlineLabel.textAlignment = NSTextAlignmentCenter;
    _onlineLabel.numberOfLines = 2;
    [_onlineLabel sizeToFit];
    [self.contentView addSubview:_onlineLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 89.5, kScreenWidth, 0.3)];
    lineLabel.backgroundColor = kLineColor;
    [self.contentView addSubview:lineLabel];
    
    [self _addconstraint];
}

- (void)_addconstraint {
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.offset(70);
        make.height.offset(70);
    }];
    
    [_maleCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.centerY.mas_equalTo(_iconView.mas_centerY);
    }];
    
    [_femaleCountLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_maleCountLable.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_maleCountLable.mas_centerY);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_femaleCountLable.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_femaleCountLable.mas_centerY);
    }];
    
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kSpace);
        make.bottom.mas_equalTo(_iconView.mas_bottom);
        make.height.offset(15);
    }];
    
    [_onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         
        make.left.mas_equalTo(_iconView.mas_right).offset(kSpace);
        make.top.mas_equalTo(_iconView.mas_top);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.offset(15);
    }];
}

- (void)setRoomModel:(RoomModel *)roomModel {
    _roomModel = roomModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_roomModel.creator_user_info.image] placeholderImage:[UIImage imageNamed:@""]];
    _nameLabel.text = _roomModel.room_name;
    _maleCountLable.attributedText = [DataService createAttributedStringWithImageName:@"icon-boy" bounds:CGRectMake(0, -2, 6, 13) str:_roomModel.online_male_count];
    _femaleCountLable.attributedText = [DataService createAttributedStringWithImageName:@"icon-Girl" bounds:CGRectMake(0, -2, 6, 13) str:_roomModel.online_female_count];
    
    if ([_roomModel.city isEqualToString:@""] || _roomModel.city == nil) {
        if ([_roomModel.country isEqualToString:@""] || _roomModel.country == nil) {
            _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-location" bounds:CGRectMake(0, -2, 9, 13) str:@"Mars"];
        }else {
            _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-location" bounds:CGRectMake(0, -2, 9, 13) str:_roomModel.country];
        }
    }else {
        _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-location" bounds:CGRectMake(0, -2, 9, 13) str:_roomModel.city];
    }
    
    NSInteger online = [_roomModel.online_female_count integerValue] + [_roomModel.online_male_count integerValue];
    _onlineLabel.text = [NSString stringWithFormat:@"%ld\nonline",online];
    
    _signatureLabel.text = _roomModel.room_desc;
}
@end
