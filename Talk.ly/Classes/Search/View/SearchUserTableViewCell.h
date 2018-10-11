//
//  SearchUserTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/27.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface SearchUserTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *activityLabel;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UILabel *signatureLabel;

@property(nonatomic,strong)UserModel *userModel;
@end
