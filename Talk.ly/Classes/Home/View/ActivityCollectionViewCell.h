//
//  ActivityCollectionViewCell.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/22.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface ActivityCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)ActivityModel *model;

@property(nonatomic,strong)UIImageView *coverImageView;
@property(nonatomic,strong)UILabel *tagLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *moneyLabel;

@end
