//
//  AnswerEndView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/16.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerEndView : UIView

@property(nonatomic,strong)UILabel *winsLabel;
@property(nonatomic,strong)UILabel *shareBonusLabel;
@property(nonatomic,strong)UILabel *winnerLabel;
@property(nonatomic,strong)UIImageView *iconView;

- (instancetype)initWithFrame:(CGRect)frame withcount:(NSString *)count withbonus:(NSString *)bonus withsuccess:(BOOL)success jackport:(NSInteger)jackpot;
@end
