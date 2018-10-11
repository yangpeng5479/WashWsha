//
//  FriendMessageTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FriendMessageTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation FriendMessageTableViewCell

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
    
    _imageview = [[UIImageView alloc] init];
    [_imageview xw_roundedCornerWithRadius:20 cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_imageview];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = k51Color;
    [_titleLabel sizeToFit];
    [self.contentView addSubview:_titleLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 69.5, kScreenWidth, 0.3)];
    lineLabel.backgroundColor = kLineColor;
    [self.contentView addSubview:lineLabel];
    
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_imageview.mas_right).offset(20);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

@end
