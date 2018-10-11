//
//  SectionThreeTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SectionThreeTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation SectionThreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _image = [[UIImageView alloc] init];
    _image.backgroundColor = kNavColor;
    [self.contentView addSubview:_image];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text = @"Gold";
    _titleLabel.textColor = k51Color;
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:13];
    _detailLabel.textColor = k102Color;
    _detailLabel.text = @"8 Gold";
    [_detailLabel sizeToFit];
    [self.contentView addSubview:_detailLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 44.5, kScreenWidth, 0.3)];
    lineLabel.backgroundColor = kLineColor;
    [self.contentView addSubview:lineLabel];
    
    [_image mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(15);
        make.height.offset(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_image.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_image.mas_centerY);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).offset(-35);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

@end
