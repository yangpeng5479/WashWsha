//
//  RoomCollectionView.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface RoomCollectionView : UICollectionView<UICollectionViewDataSource>

@property(nonatomic,strong)ActivityModel *model;
@property(nonatomic,strong)NSArray *dataArr;

@end
