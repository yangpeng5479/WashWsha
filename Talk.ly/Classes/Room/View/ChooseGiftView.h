//
//  ChooseGiftView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChooseGiftView : UIView<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *bgScrollView;

@property(nonatomic,strong)NSArray *giftArr;
@property(nonatomic,strong)NSMutableArray *moneyArr;
@property(nonatomic,strong)NSMutableArray *giftKeyArr;

@property(nonatomic,strong)UIButton *rechargeBtn;
@property(nonatomic,strong)UILabel *goldLabel;
@property(nonatomic,strong)UILabel *diamondLabel;
@property(nonatomic,strong)UILabel *destinationLabel;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIButton *arrowBtn;

@end
