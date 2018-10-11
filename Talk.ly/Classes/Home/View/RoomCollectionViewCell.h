//
//  RoomCollectionViewCell.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomModel.h"

@interface RoomCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)RoomModel *roomModel;

@property(nonatomic,strong)UIImageView *coverImageView;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UILabel *signatureLabel;
@property(nonatomic,strong)UILabel *hotLabel;
@property(nonatomic,strong)UILabel *tagLabel;
@property(nonatomic,strong)UIImageView *liveIconView;

@end
