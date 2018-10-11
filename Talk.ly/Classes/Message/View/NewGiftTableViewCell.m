//
//  NewGiftTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/28.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "NewGiftTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@implementation NewGiftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    
    _iconImageView = [[UIImageView alloc] init];
    [_iconImageView xw_roundedCornerWithRadius:25 cornerColor:[UIColor whiteColor]];
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = k51Color;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.text = @"Name";
    [self addSubview:_nameLabel];
    
    _bgview = [[UIView alloc] init];
    _bgview.backgroundColor = [UIColor whiteColor];
    _bgview.layer.cornerRadius = kCellSpace;
    _bgview.layer.shadowColor = [UIColor blackColor].CGColor;
    _bgview.layer.shadowOffset = CGSizeMake(3, 3);
    _bgview.layer.shadowOpacity = 0.5;
    _bgview.layer.shadowRadius = kCellSpace;
    [self addSubview:_bgview];
    
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.textColor = k51Color;
    _giftNameLabel.font = [UIFont systemFontOfSize:14];
    _giftNameLabel.text = @"Give you";
    [_giftNameLabel sizeToFit];
    [_bgview addSubview:_giftNameLabel];
    
    _giftCountLabel = [[UILabel alloc] init];
    _giftCountLabel.textColor = k51Color;
    _giftCountLabel.font = [UIFont systemFontOfSize:14];
    _giftCountLabel.text = @"Charm + 1";
    [_giftCountLabel sizeToFit];
    [_bgview addSubview:_giftCountLabel];
    
    _giftImageView = [[UIImageView alloc] init];
    [_bgview addSubview:_giftImageView];
    
    _thankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_thankBtn setTitle:@"Thank" forState:UIControlStateNormal];
    [_thankBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    _thankBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgview addSubview:_thankBtn];
    
    _backGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backGiftBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    [_backGiftBtn setTitle:@"Back to the ceremony" forState:UIControlStateNormal];
    _backGiftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_bgview addSubview:_backGiftBtn];
    
    [self addcontraintUI];
}

- (void)addcontraintUI {
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.equalTo(@50);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(kSpace);
        make.right.mas_equalTo(_iconImageView.mas_right).offset(kCellSpace);
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(kCellSpace);
        make.height.offset(15);
    }];
    
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconImageView.mas_right).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
    }];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_bgview.mas_left).offset(kSpace);
        make.top.mas_equalTo(_bgview.mas_top).offset(kSpace);
    }];
    [_giftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_giftNameLabel.mas_left);
        make.top.mas_equalTo(_giftNameLabel.mas_bottom).offset(15);
    }];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_bgview.mas_right).offset(-2*kSpace);
        make.top.mas_equalTo(_bgview.mas_top).offset(15);
        make.width.height.equalTo(@40);
    }];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = kLineColor;
    [_bgview addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_bgview.mas_left);
        make.right.mas_equalTo(_bgview.mas_right);
        make.top.mas_equalTo(_bgview.mas_top).offset(70);
        make.height.offset(0.5);
    }];
    
    [_thankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(lineLabel.mas_bottom).offset(kCellSpace);
        make.left.mas_equalTo(_bgview.mas_left).offset(kSpace);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    [_backGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_bgview.mas_right).offset(-kSpace);
        make.top.mas_equalTo(lineLabel.mas_bottom).offset(kCellSpace);
        make.height.offset(20);
        make.width.offset(145);
    }];
}

- (void)setNoticeGiftModel:(NoticeGiftModel *)noticeGiftModel {
    _noticeGiftModel = noticeGiftModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_noticeGiftModel.send_user.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _nameLabel.text = _noticeGiftModel.send_user.name;
    _giftNameLabel.text = [NSString stringWithFormat:@"Give you %@",_noticeGiftModel.gift_info.gift_name];
    _giftCountLabel.text = [NSString stringWithFormat:@"Charm + %ld",_noticeGiftModel.gif_count];
    _giftImageView.image = [UIImage imageNamed:_noticeGiftModel.gift_info.gift_image_key];
    if (!_noticeGiftModel.thanked) {
        [_thankBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    }else {
        [_thankBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if (!_noticeGiftModel.status) {
        [_backGiftBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    }else {
        [_backGiftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}


















@end
