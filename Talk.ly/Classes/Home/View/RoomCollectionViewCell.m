//
//  RoomCollectionViewCell.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomCollectionViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "DataService.h"

@implementation RoomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _configureCell];
    }
    return self;
}

- (void)_configureCell {
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.image = [UIImage imageNamed:@"icon-people"];
    [_coverImageView xw_roundedCornerWithRadius:kCellSpace cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_coverImageView];
    
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _tagLabel.font = [UIFont systemFontOfSize:10];
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.layer.cornerRadius = 2;
    _tagLabel.layer.masksToBounds = YES;
    _tagLabel.backgroundColor = kGreenColor;
    [self.contentView addSubview:_tagLabel];
    
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.font = [UIFont systemFontOfSize:13];
    _locationLabel.textColor = [UIColor whiteColor];
    _locationLabel.shadowColor = k51Color;
    _locationLabel.shadowOffset = CGSizeMake(1, 1);
    [_locationLabel sizeToFit];
    [self.contentView addSubview:_locationLabel];
    
    _hotLabel = [[UILabel alloc] init];
    _hotLabel.font = [UIFont systemFontOfSize:13];
    _hotLabel.textColor = [UIColor whiteColor];
    _hotLabel.shadowColor = k51Color;
    _hotLabel.shadowOffset = CGSizeMake(1, 1);
    [_hotLabel sizeToFit];
    [self.contentView addSubview:_hotLabel];
    
    _signatureLabel = [[UILabel alloc] init];
    _signatureLabel.font = [UIFont systemFontOfSize:10];
    _signatureLabel.textColor = [UIColor whiteColor];
    _signatureLabel.shadowColor = k51Color;
    _signatureLabel.shadowOffset = CGSizeMake(1, 1);
    _signatureLabel.numberOfLines = 2;
    [self.contentView addSubview:_signatureLabel];
    
    _liveIconView = [[UIImageView alloc] init];
    _liveIconView.image = [UIImage imageNamed:@"live-icon"];
    [self.contentView addSubview:_liveIconView];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kSpace);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCellSpace);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellSpace);
        make.height.offset(30);
    }];
    
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_signatureLabel.mas_left);
        make.bottom.mas_equalTo(_signatureLabel.mas_top).offset(-kSpace);
    }];
    
    [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_signatureLabel.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top).offset(kSpace);
    }];
    
    [_liveIconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.with.offset(30);
    }];
}

- (void)setRoomModel:(RoomModel *)roomModel {
    _roomModel = roomModel;
    
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_roomModel.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    
    if ([_roomModel.city isEqualToString:@""] || _roomModel.city == nil) {
        if ([_roomModel.country isEqualToString:@""] || _roomModel.country == nil) {
            _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-locate" bounds:CGRectMake(0, -1, 11, 11) str:@"Mars"];
        }else {
            _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-locate" bounds:CGRectMake(0, -1, 11, 11) str:_roomModel.country];
        }
    }else {
        _locationLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-locate" bounds:CGRectMake(0, -1, 11, 11) str:_roomModel.city];
    }
    _hotLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-hot" bounds:CGRectMake(0, -2, 11, 11) str:_roomModel.heat_count];
    if ([_roomModel.room_desc isEqualToString:@""]) {
        _signatureLabel.text = @"Welcome to my room and chat with me.";
    }else {
     
        _signatureLabel.text = _roomModel.room_desc;
    }
    if ([_roomModel.type isEqualToString:@"radio"]) {
        _tagLabel.text = @"Radio";
        _tagLabel.backgroundColor = kGreenColor;
        _liveIconView.hidden = YES;
    }else {
        _tagLabel.text = @"Live";
        _tagLabel.backgroundColor = kRedColor;
        _liveIconView.hidden = NO;
    }
}


@end
