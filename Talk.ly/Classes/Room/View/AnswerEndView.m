//
//  AnswerEndView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/16.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "AnswerEndView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "UserModel.h"

@implementation AnswerEndView

- (instancetype)initWithFrame:(CGRect)frame withcount:(NSString *)count withbonus:(NSString *)bonus withsuccess:(BOOL)success jackport:(NSInteger)jackpot {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *keepLabel = [[UILabel alloc] init];
        keepLabel.font = [UIFont systemFontOfSize:50];
        keepLabel.textColor = [UIColor whiteColor];
        if (success) {
            keepLabel.text = @"YOU WIN";
        }else {
            keepLabel.text = @"YOU LOSE";
        }
        [keepLabel sizeToFit];
        [self addSubview:keepLabel];
        
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = 150;
        _iconView.layer.masksToBounds = YES;
        _iconView.image = [UIImage imageNamed:@"icon-people"];
        [self addSubview:_iconView];
        
        _winsLabel = [[UILabel alloc] init];
        _winsLabel.textColor = [UIColor whiteColor];
        _winsLabel.font = [UIFont systemFontOfSize:36];
        if (success) {
            _winsLabel.text = @"Congratulatuins";
        }else {
            _winsLabel.text = @"Oops!";
        }
        [_winsLabel sizeToFit];
        [self addSubview:_winsLabel];
        
        _shareBonusLabel = [[UILabel alloc] init];
        _shareBonusLabel.font = [UIFont systemFontOfSize:20];
        _shareBonusLabel.textColor = [UIColor whiteColor];
        _shareBonusLabel.numberOfLines = 0;
        if (success) {
            _shareBonusLabel.text = [NSString stringWithFormat:@"Challenge succeed\nYou won %@ Dollars",bonus];
        }else {
            _shareBonusLabel.text = [NSString stringWithFormat:@"Only One step away from the lucky $%ld\nTry next time!!!",jackpot];
        }
        _shareBonusLabel.textAlignment = NSTextAlignmentCenter;
        [_shareBonusLabel sizeToFit];
        [self addSubview:_shareBonusLabel];
        
        [keepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(self.mas_top);
        }];
        
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(keepLabel.mas_bottom).offset(50);
            make.width.height.equalTo(@300);
        }];
        
        [_winsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_iconView.mas_bottom).offset(2*kSpace);
        }];
        
        [_shareBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(_winsLabel.mas_bottom).offset(2*kSpace);
        }];
    }
    return self;
}




@end
