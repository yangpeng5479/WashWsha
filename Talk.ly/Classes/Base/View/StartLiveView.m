//
//  StartLiveView.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "StartLiveView.h"
#import <Masonry.h>

@implementation StartLiveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.imagebg removeFromSuperview];
        self.imagebg = nil;
        
        [self.startBtn setTitle:@"Start Live" forState:UIControlStateNormal];
        self.titleTF.placeholder = @"Title Your Live";
        _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_beautyBtn setImage:[UIImage imageNamed:@"icon-Lopicca-off"] forState:UIControlStateNormal];
        [_beautyBtn setImage:[UIImage imageNamed:@"icon-Lopicca-on"] forState:UIControlStateSelected];
        _beautyBtn.selected = YES;
        [self addSubview:_beautyBtn];
        
        [_beautyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.mas_equalTo(self.startBtn.mas_centerY);
            make.right.mas_equalTo(self.startBtn.mas_left).offset(-10);
            make.width.height.equalTo(@40);
        }];
    }
    return self;
}

@end
