//
//  RechargeCollectionViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RechargeCollectionViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation RechargeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = kCellSpace;
        self.layer.borderColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:24/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _getmoneyLabel = [[UILabel alloc] init];
    _getmoneyLabel.font = [UIFont systemFontOfSize:14];
    _getmoneyLabel.textColor = [UIColor colorWithRed:251/255.0 green:128/255.0 blue:45/255.0 alpha:1.0];
    [_getmoneyLabel sizeToFit];
    [self addSubview:_getmoneyLabel];
    
    _giveLabel = [[UILabel alloc] init];
    _giveLabel.textColor = kNavColor;
    _giveLabel.font = [UIFont systemFontOfSize:12];
    [_giveLabel sizeToFit];
    [self addSubview:_giveLabel];
    
    _goldImageView = [[UIImageView alloc] init];
    _goldImageView.image = [UIImage imageNamed:@"icon-USdollar"];
    [self addSubview:_goldImageView];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = [UIFont systemFontOfSize:12];
    _moneyLabel.textColor = kNavColor;
    [_moneyLabel sizeToFit];
    [self addSubview:_moneyLabel];
    
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.backgroundColor = [UIColor colorWithRed:253/255.0 green:128/255.0 blue:24/255.0 alpha:1.0];
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyButton setTitle:@"Buy Now" forState:UIControlStateNormal];
    _buyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_buyButton];
    
    [self addcontraintWithView];
}

- (void)addcontraintWithView {
    
    [_getmoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(kSpace);
    }];
    [_giveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_getmoneyLabel.mas_bottom).offset(kCellSpace);
    }];
    
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.offset(25);
    }];
    [_goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(_moneyLabel.mas_top).offset(-kCellSpace);
        make.width.height.equalTo(@25);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(_buyButton.mas_top).offset(-kSpace);
    }];
}

- (void)setModel:(RechargeModel *)model {
    _model = model;
    _getmoneyLabel.text = [NSString stringWithFormat:@"%ld Gold",_model.get_total];
    if (_model.award_total > 0) {
        _giveLabel.text = [NSString stringWithFormat:@"Give %ld Gold",_model.award_total];
    }else {
        _giveLabel.text = @"";
    }
    _moneyLabel.text = [NSString stringWithFormat:@"$ %.2f",_model.money];
}
















@end
