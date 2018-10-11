//
//  CountryCodeTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CountryCodeTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation CountryCodeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    
    _countryLabel = [[UILabel alloc] init];
    _countryLabel.textColor = k102Color;
    _countryLabel.font = [UIFont systemFontOfSize:15];
    [_countryLabel sizeToFit];
    [self addSubview:_countryLabel];
    
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.textColor = k102Color;
    _codeLabel.font = [UIFont systemFontOfSize:15];
    [_codeLabel sizeToFit];
    [self addSubview:_codeLabel];
    
    [_countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)setModel:(CountryCodeModel *)model {
    _model = model;
    
    _countryLabel.text = model.country;
    _codeLabel.text = [NSString stringWithFormat:@"+%@",model.code];
}

@end
