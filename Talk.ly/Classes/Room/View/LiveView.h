//
//  LiveView.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MarqueeLabel.h>

@interface LiveView : UIView

@property(nonatomic,strong)UIView *iconBgView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIButton *followBtn;
@property(nonatomic,strong)MarqueeLabel *nameeLabel;
@property(nonatomic,strong)UILabel *idLabel;

@property(nonatomic,strong)UIView *incomeView;
@property(nonatomic,strong)UILabel *incomeLabel;

@property(nonatomic,strong)UICollectionView *onlineCV;
@property(nonatomic,strong)UIButton *onlineBtn;

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIButton *messageBtn;
@property(nonatomic,strong)UIButton *giftBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *closeBtn;


@end
