//
//  BaseFindTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface BaseFindTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *leveImageView;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *levelLabel;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UserModel *levelModel;
@property(nonatomic,strong)UserModel *wealthModel;
@property(nonatomic,strong)UserModel *charmModel;
@property(nonatomic,strong)UserModel *guardianModel;
@property(nonatomic,strong)UILabel *rankLabel;
@end
