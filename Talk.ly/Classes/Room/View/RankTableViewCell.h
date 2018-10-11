//
//  RankTableViewCell.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/20.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface RankTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *topLabel;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UILabel *levelLabel;
@property(nonatomic,strong)UILabel *contributeLabel;

@property(nonatomic,strong)UserModel *model;

@end
