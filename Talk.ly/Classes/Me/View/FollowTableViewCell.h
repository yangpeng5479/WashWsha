//
//  FollowTableViewCell.h
//  video
//
//  Created by 杨鹏 on 2018/5/23.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FollowModel.h"

@interface FollowTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *ageAndGenderLabel;
@property(nonatomic,strong)UIButton *unFollowBtn;

@property(nonatomic,strong)FollowModel *model;

@end
