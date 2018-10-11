//
//  FriendRequestTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UserModel.h"

@interface FriendRequestTableViewCell : BaseTableViewCell

@property(nonatomic,strong)UIButton *followBtn;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UserModel *fansModel;
@property(nonatomic,strong)UserModel *friendModel;
@end
