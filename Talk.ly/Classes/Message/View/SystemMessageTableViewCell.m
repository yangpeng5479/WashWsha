//
//  SystemMessageTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SystemMessageTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation SystemMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = k102Color;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
    
    _imageview = [[UIImageView alloc] init];
    _imageview.backgroundColor = kNavColor;
    [_imageview xw_roundedCornerWithRadius:20 cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_imageview];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.textColor = k51Color;
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.mas_top).offset(25);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.offset(100);
        make.height.offset(15);
    }];
    
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top).offset(30);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(_imageview.mas_right).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(kSpace);
    }];
}

- (void)setSystemModel:(NoticeSystemModel *)systemModel {
    _systemModel = systemModel;
    _timeLabel.text = _systemModel.create_time;
    _contentLabel.text = _systemModel.content;
}

@end
