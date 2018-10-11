//
//  OnlineCollectionViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/20.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "OnlineCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@implementation OnlineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _iconview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    _iconview.layer.cornerRadius = 17.5;
    _iconview.layer.masksToBounds = YES;
    
    [self.contentView addSubview:_iconview];
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [_iconview sd_setImageWithURL:[NSURL URLWithString:_userModel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
}
@end
