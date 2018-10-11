//
//  MineProfilePhotosView.h
//  GameTogether_iOS
//
//  Created by Mac on 16/5/13.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "XWDragCellCollectionView.h"

@interface MineProfilePhotosView : XWDragCellCollectionView<XWDragCellCollectionViewDataSource>

@property(nonatomic,copy)NSArray *imageNameMarr;

@property(nonatomic,strong)UIButton *addBtn;

- (instancetype)initWithFrame:(CGRect)frame collectionViewFlowLayout:(UICollectionViewFlowLayout *)layout;

@end
