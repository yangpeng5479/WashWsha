//
//  OnlineCollectionViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/20.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface OnlineCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong)UIImageView *iconview;
@end
