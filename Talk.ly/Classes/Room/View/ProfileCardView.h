//
//  ProfileCardView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/19.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface ProfileCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame withModel:(UserModel *)model type:(BOOL)isHost;

@property(nonatomic,strong)UIButton *reportBtn;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIButton *inviteBtn;
@property(nonatomic,strong)UIButton *kickedoutBtn;
@property(nonatomic,strong)UIButton *sendGiftBtn;
@property(nonatomic,strong)UILabel *leftLabel;
@property(nonatomic,strong)UIImageView *iconImageView;

@end
