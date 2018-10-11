//
//  RoomTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation RoomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.levelLabel.hidden = YES;
    self.genderLabel.hidden = YES;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(kSpace);
        make.top.mas_equalTo(self.iconImageView.mas_top);
    }];
    
    _signatureLabel = [[UILabel alloc] init];
    _signatureLabel.textColor = k153Color;
    _signatureLabel.font = [UIFont systemFontOfSize:11];
    _signatureLabel.text = @"Life is happy";
    [self.contentView addSubview:_signatureLabel];
    
    _roomIntroduceLbael = [[UILabel alloc] init];
    _roomIntroduceLbael.textColor = k153Color;
    _roomIntroduceLbael.font = [UIFont systemFontOfSize:12];
    _roomIntroduceLbael.text = @"Homeowner: ROC";
    [self.contentView addSubview:_roomIntroduceLbael];
    
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.nameLabel.mas_left);
//        make.right.mas_equalTo(self.rightLabel.mas_left).offset(-kSpace);
        make.height.offset(11);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    
    [_roomIntroduceLbael mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.iconImageView.mas_bottom);
    }];
}

- (void)setRoomModel:(RoomModel *)roomModel {
    _roomModel = roomModel;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_roomModel.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    self.nameLabel.text = _roomModel.room_name;
    _signatureLabel.text = _roomModel.room_desc;
    _roomIntroduceLbael.text = [NSString stringWithFormat:@"Homeowner: %@",_roomModel.creator_user_info.name];
}

@end
