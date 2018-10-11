//
//  RechargeCollectionViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeModel.h"

@interface RechargeCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)RechargeModel *model;

@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *giveLabel;
@property(nonatomic,strong)UIImageView *goldImageView;
@property(nonatomic,strong)UILabel *getmoneyLabel;
@property(nonatomic,strong)UIButton *buyButton;

@end
