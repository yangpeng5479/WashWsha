//
//  NewGiftTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/28.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeGiftModel.h"

@interface NewGiftTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UILabel *giftNameLabel;
@property(nonatomic,strong)UILabel *giftCountLabel;
@property(nonatomic,strong)UIImageView *giftImageView;
@property(nonatomic,strong)UIButton *thankBtn;
@property(nonatomic,strong)UIButton *backGiftBtn;

@property(nonatomic,strong)NoticeGiftModel *noticeGiftModel;
@end
