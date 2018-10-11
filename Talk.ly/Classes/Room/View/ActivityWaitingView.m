//
//  ActivityWaitingView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/3.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ActivityWaitingView.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>

@implementation ActivityWaitingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    UILabel *appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = @"DR.IQ";
    appNameLabel.textColor = [UIColor whiteColor];
    appNameLabel.font = [UIFont systemFontOfSize:30];
    [appNameLabel sizeToFit];
    [self addSubview:appNameLabel];
    
    UILabel *nextLabel = [[UILabel alloc] init];
    nextLabel.textColor = [UIColor whiteColor];
    nextLabel.font = [UIFont systemFontOfSize:18];
    nextLabel.text = @"NEXT GAME";
    [nextLabel sizeToFit];
    [self addSubview:nextLabel];
    
    _creatTimeLabel = [[UILabel alloc] init];
    _creatTimeLabel.textColor = [UIColor whiteColor];
    _creatTimeLabel.font = [UIFont systemFontOfSize:24];
    [_creatTimeLabel sizeToFit];
    [self addSubview:_creatTimeLabel];
    
    _jackpotLabel = [[UILabel alloc] init];
    _jackpotLabel.textColor = [UIColor whiteColor];
    _jackpotLabel.font = [UIFont systemFontOfSize:24];
    [_jackpotLabel sizeToFit];
    [self addSubview:_jackpotLabel];
    
    _bonusImageView = [[UIImageView alloc] init];
    _bonusImageView.image = [UIImage imageNamed:@"Whitebg"];
    [self addSubview:_bonusImageView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(kSpace, 0, _bonusImageView.width-2*kSpace, 100)];
    _topView.backgroundColor = [UIColor clearColor];
    [_bonusImageView addSubview:_topView];
    
    _cumLabel = [[UILabel alloc] init];
    _cumLabel.font = [UIFont systemFontOfSize:23];
    _cumLabel.textColor = k51Color;
    _cumLabel.text = @"Cumulative Bonus";
    _cumLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_cumLabel];
    
    _wintotalLabel = [[UILabel alloc] init];
    _wintotalLabel.textColor = k51Color;
    _wintotalLabel.font = [UIFont systemFontOfSize:36];
    _wintotalLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_wintotalLabel];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(kSpace, _bonusImageView.width-2*kSpace, 0, 100)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_bonusImageView addSubview:_bottomView];
    
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.textColor = k51Color;
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    _amountLabel.font = [UIFont systemFontOfSize:23];
    _amountLabel.text = @"Cash Amount";
    [_bottomView addSubview:_amountLabel];
    
    _cashLabel = [[UILabel alloc] init];
    _cashLabel.font = [UIFont systemFontOfSize:36];
    _cashLabel.textColor = k51Color;
    _cashLabel.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_cashLabel];
    
    [appNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(appNameLabel.mas_bottom).offset(25);
    }];
    [_creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(nextLabel.mas_bottom).offset(25);
    }];
    [_jackpotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_creatTimeLabel.mas_bottom).offset(25);
    }];
    [_bonusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_jackpotLabel.mas_bottom).offset(35);
        make.left.mas_equalTo(self.mas_left).offset(50);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-60);
    }];
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topView.frame = CGRectMake(kSpace, 0, _bonusImageView.width-2*kSpace, _bonusImageView.height/2);
    _bottomView.frame = CGRectMake(kSpace, _bonusImageView.height/2, _bonusImageView.width-2*kSpace, _bonusImageView.height/2);
    
    [_cumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_topView.mas_top).offset((_topView.height-80)/2);
        make.left.mas_equalTo(_topView.mas_left).offset(-2*kSpace);
        make.right.mas_equalTo(_topView.mas_right).offset(-2*kSpace);
        make.height.offset(25);
    }];
    [_wintotalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cumLabel.mas_left);
        make.right.mas_equalTo(_cumLabel.mas_right);
        make.top.mas_equalTo(_cumLabel.mas_bottom).offset(20);
        make.height.offset(35);
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_bottomView.mas_top).offset((_bottomView.height-80)/2);
        make.left.mas_equalTo(_bottomView.mas_left);
        make.right.mas_equalTo(_bottomView.mas_right);
        make.height.offset(25);
    }];
    [_cashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bottomView.mas_left);
        make.right.mas_equalTo(_bottomView.mas_right);
        make.top.mas_equalTo(_amountLabel.mas_bottom).offset(20);
        make.height.offset(35);
    }];
}























@end
