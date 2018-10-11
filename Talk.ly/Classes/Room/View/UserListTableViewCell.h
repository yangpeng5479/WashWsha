//
//  UserListTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/23.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserListTableViewCell : UITableViewCell

@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *ageLabel;
@property(nonatomic,strong)UILabel *activityLabel;
@property(nonatomic,strong)UILabel *heartLabel;
@property(nonatomic,strong)UILabel *wealthLabel;

@end
