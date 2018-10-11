//
//  SystemMusicTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/26.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SystemMusicTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation SystemMusicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _iconView = [[UIImageView alloc] init];
//    _iconView.image = [UIImage imageNamed:@"icon-people"];
    [self.contentView addSubview:_iconView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = k51Color;
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [_nameLabel sizeToFit];
    [self.contentView addSubview:_nameLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 49.7, kScreenWidth, 0.3)];
    lineLabel.backgroundColor = kLineColor;
    [self addSubview:lineLabel];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.equalTo(@20);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.right.mas_equalTo(_iconView.mas_left).offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)setModel:(MusicModel *)model {
    _model = model;
    _nameLabel.text = _model.title;
}

@end
