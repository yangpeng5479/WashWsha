//
//  MineTableViewCell.m
//  video
//
//  Created by 杨鹏 on 2018/5/22.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import "MineTableViewCell.h"
#import <Masonry.h>
#import "CommonPrex.h"

@implementation MineTableViewCell

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
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = k51Color;
    [_label sizeToFit];
    [self.contentView addSubview:_label];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.font = [UIFont systemFontOfSize:15];
    _rightLabel.textColor = k153Color;
    [_rightLabel sizeToFit];
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right).offset(-2*kSpace);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

@end
