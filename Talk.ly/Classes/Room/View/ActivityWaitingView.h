//
//  ActivityWaitingView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/3.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityWaitingView : UIView

@property(nonatomic,strong)UILabel *creatTimeLabel;
@property(nonatomic,strong)UILabel *jackpotLabel;
@property(nonatomic,strong)UILabel *wintotalLabel;
@property(nonatomic,strong)UILabel *cashLabel;

@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIImageView *bonusImageView;
@property(nonatomic,strong)UILabel *cumLabel;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UILabel *amountLabel;
@end
