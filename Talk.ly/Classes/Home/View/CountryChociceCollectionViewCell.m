//
//  CountryChociceCollectionViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CountryChociceCollectionViewCell.h"
#import <Masonry.h>
#import "CommonPrex.h"
#import "DataService.h"
#import <UIImageView+WebCache.h>

@implementation CountryChociceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _configureCell];
    }
    return self;
}

- (void)_configureCell {
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = k153Color;
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCellSpace);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCellSpace);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.height.offset(30);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(_imageView.mas_bottom);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setModel:(CountryModel *)model {
    _model = model;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.country_icon]];
    _nameLabel.text = model.country_name;
}

@end
