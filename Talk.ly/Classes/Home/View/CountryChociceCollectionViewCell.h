//
//  CountryChociceCollectionViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryModel.h"

@interface CountryChociceCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)CountryModel *model;
@end
