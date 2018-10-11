//
//  YPHeaderFooterView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "YPHeaderFooterView.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation YPHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        backView.backgroundColor = [UIColor whiteColor];
        
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.backgroundColor = kNavColor;
        [backView addSubview:leftLabel];
        self.leftlabel = leftLabel;
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = k51Color;
        rightLabel.font = [UIFont systemFontOfSize:16];
        [backView addSubview:rightLabel];
        self.rightlabel = rightLabel;
        
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.offset(2);
            make.height.offset(15);
            make.left.mas_equalTo(backView.mas_left).offset(15);
            make.top.mas_equalTo(backView.mas_top).offset(15);
        }];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(leftLabel.mas_right).offset(kCellSpace);
            make.centerY.mas_equalTo(leftLabel.mas_centerY);
        }];
        [self.contentView addSubview:backView];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    self.rightlabel.text = text;
}


@end
