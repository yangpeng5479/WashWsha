//
//  LiveProfileView.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/14.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface LiveProfileView : UIView

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UILabel *levelLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *IDLocationLabel;
@property(nonatomic,strong)UIButton *rightBtn;

- (instancetype)initWithFrame:(CGRect)frame withUserModel:(UserModel *)model;
@end
