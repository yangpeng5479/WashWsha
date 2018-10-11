//
//  DefaultView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/10.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "DefaultView.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation DefaultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _imageview = [[UIImageView alloc] init];
    [self addSubview:_imageview];
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.font = [UIFont systemFontOfSize:18];
    _tipsLabel.textColor = k102Color;
    [_tipsLabel sizeToFit];
    [self addSubview:_tipsLabel];
    
    _coverControl = [[UIControl alloc] initWithFrame:self.bounds];
    _coverControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_coverControl];
    
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset(200);
        make.height.offset(140);
    }];
    
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_imageview.mas_bottom).offset(40);
    }];
    
}

@end
