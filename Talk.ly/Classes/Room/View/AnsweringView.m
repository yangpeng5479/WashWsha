//
//  AnsweringView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/4.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "AnsweringView.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation AnsweringView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = kCellSpace;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = kCellSpace;
    
    _topIconView = [[UIImageView alloc] init];
    _topIconView.layer.cornerRadius = 25;
    _topIconView.image = [UIImage imageNamed:@"icon-pen"];
    [self addSubview:_topIconView];
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.font = [UIFont systemFontOfSize:15];
    _indexLabel.text = @"No.1";
    [_indexLabel sizeToFit];
    _indexLabel.textColor = k153Color;
    [self addSubview:_indexLabel];
    
    _centerLabel = [[UILabel alloc] init];
    _centerLabel.font = [UIFont systemFontOfSize:18];
    _centerLabel.textColor = k51Color;
    _centerLabel.text = @"Please Choose";
    [_centerLabel sizeToFit];
    [self addSubview:_centerLabel];
    
    _timerLabel = [[UILabel alloc] init];
    _timerLabel.font = [UIFont systemFontOfSize:18];
    _timerLabel.textColor = kNavColor;
    [_timerLabel sizeToFit];
    [self addSubview:_timerLabel];
    
    _questionDescLabel = [[UILabel alloc] init];
    _questionDescLabel.font = [UIFont systemFontOfSize:15];
    _questionDescLabel.numberOfLines = 0;
    _questionDescLabel.textColor = k102Color;
    _questionDescLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_questionDescLabel];
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.font = [UIFont systemFontOfSize:12];
    _tipsLabel.textColor = kErrorColor;
    _tipsLabel.text = @"Answered wrong , you are eliminated!";
    [_tipsLabel sizeToFit];
    _tipsLabel.hidden = YES;
    [self addSubview:_tipsLabel];
    
    _aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _aBtn.layer.cornerRadius = 20;
    _aBtn.layer.borderColor = kLineColor.CGColor;
    _aBtn.layer.borderWidth = 1;
    _aBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _aBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_aBtn setTitleColor:k51Color forState:UIControlStateNormal];
    [self addSubview:_aBtn];
    
    _label1 = [[UILabel alloc] init];
    _label1.textColor = k153Color;
    _label1.font = [UIFont systemFontOfSize:15];
    [_label1 sizeToFit];
    [_aBtn addSubview:_label1];
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_aBtn.mas_right).offset(-15);
        make.centerY.mas_equalTo(_aBtn.mas_centerY);
    }];
    
    _bBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bBtn.layer.cornerRadius = 20;
    _bBtn.layer.borderColor = kLineColor.CGColor;
    _bBtn.layer.borderWidth = 1;
    _bBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _bBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_bBtn setTitleColor:k51Color forState:UIControlStateNormal];
    [self addSubview:_bBtn];
    _label2 = [[UILabel alloc] init];
    _label2.textColor = k153Color;
    _label2.font = [UIFont systemFontOfSize:15];
    [_label2 sizeToFit];
    [_bBtn addSubview:_label2];
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_bBtn.mas_right).offset(-15);
        make.centerY.mas_equalTo(_bBtn.mas_centerY);
    }];
    
    _cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cBtn.layer.cornerRadius = 20;
    _cBtn.layer.borderColor = kLineColor.CGColor;
    _cBtn.layer.borderWidth = 1;
    _cBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    _cBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_cBtn setTitleColor:k51Color forState:UIControlStateNormal];
    [self addSubview:_cBtn];
    
    _label3 = [[UILabel alloc] init];
    _label3.textColor = k153Color;
    _label3.font = [UIFont systemFontOfSize:15];
    [_label3 sizeToFit];
    [_cBtn addSubview:_label3];
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_cBtn.mas_right).offset(-15);
        make.centerY.mas_equalTo(_cBtn.mas_centerY);
    }];
    
    [_cBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-43);
        make.height.offset(40);
    }];
    [_bBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(_cBtn.mas_top).offset(-15);
        make.height.offset(40);
    }];
    [_aBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(25);
        make.right.mas_equalTo(self.mas_right).offset(-25);
        make.bottom.mas_equalTo(_bBtn.mas_top).offset(-15);
        make.height.offset(40);
    }];
    
    [_topIconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(self.mas_top);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.equalTo(@(50));
    }];
    [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(kSpace);
        make.top.mas_equalTo(self.mas_top).offset(kSpace);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_topIconView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [_timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(_centerLabel.mas_centerY);
        make.left.mas_equalTo(_centerLabel.mas_right).offset(kSpace);
    }];
    [_questionDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(_centerLabel.mas_bottom).offset(25);
        make.height.offset(80);
    }];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_cBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
}

























@end
