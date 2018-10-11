//
//  InroomCenterView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "InroomCenterView.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation InroomCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    UIImageView *borderimage = [[UIImageView alloc] init];
    borderimage.image = [UIImage imageNamed:@"icon-Avatarbg"];
    borderimage.backgroundColor = [UIColor clearColor];
    borderimage.layer.cornerRadius = 55;
    borderimage.userInteractionEnabled = YES;
    [self addSubview:borderimage];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = 50;
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;
    _iconView.tag = 104;
    [borderimage addSubview:_iconView];
    
    _voiceImageview = [[UIImageView alloc] init];
    _voiceImageview.image = [UIImage imageNamed:@"icon-voice1"];
    [self addSubview:_voiceImageview];
    
    _nicknameLabel = [[UILabel alloc] init];
    _nicknameLabel.text = @"Name";
    [_nicknameLabel sizeToFit];
    _nicknameLabel.font = [UIFont systemFontOfSize:17];
    _nicknameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nicknameLabel];
    
    _signatureLabel = [[UILabel alloc] init];
    _signatureLabel.textColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.8];
    _signatureLabel.font = [UIFont systemFontOfSize:12];
    _signatureLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_signatureLabel];
    
    _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _topicBtn.layer.cornerRadius = kSpace+kCellSpace;
    _topicBtn.backgroundColor = [UIColor clearColor];
    _topicBtn.layer.borderColor = kNavColor.CGColor;
    _topicBtn.layer.borderWidth = 2;
    [_topicBtn setTitle:@"Topic" forState:UIControlStateNormal];
    [_topicBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    _topicBtn.userInteractionEnabled = NO;
    _topicBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_topicBtn];
    
    [borderimage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top);
        make.width.offset(110);
        make.height.offset(110);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(borderimage.mas_centerX);
        make.centerY.mas_equalTo(borderimage.mas_centerY);
        make.width.offset(100);
        make.height.offset(100);
    }];
    [_voiceImageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_iconView.mas_right);
        make.bottom.mas_equalTo(_iconView.mas_bottom);
        make.height.width.equalTo(@20);
    }];
    [_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(borderimage.mas_bottom).offset(kSpace);
    }];
    [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(_nicknameLabel.mas_bottom).offset(kCellSpace);
        make.height.offset(15);
    }];
    
    [_topicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_signatureLabel.mas_bottom).offset(kSpace);
        make.width.offset(80);
        make.height.offset(30);
    }];
}
@end
