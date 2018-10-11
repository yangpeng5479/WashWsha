//
//  GiftCollectionViewCell.h
//  video
//
//  Created by 杨鹏 on 2018/6/13.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftModel.h"

@interface GiftCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView *giftImageView;
@property(nonatomic,strong)UILabel *giftNameLable;

@property(nonatomic,strong)GiftModel *model;

@end
