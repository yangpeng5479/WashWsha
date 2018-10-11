//
//  RoomCollectionView.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomCollectionView.h"
#import "CommonPrex.h"
#import "RoomCollectionViewCell.h"
#import "ActivityCollectionViewCell.h"

@implementation RoomCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth,200);
    flowLayout.minimumInteritemSpacing = kSpace;
    flowLayout.minimumLineSpacing = kSpace;
    flowLayout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat width = (kScreenWidth-3*kSpace)/2;
    CGFloat height = width;
    flowLayout.itemSize = CGSizeMake(width, height);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        [self registerClass:[RoomCollectionViewCell class] forCellWithReuseIdentifier:@"room"];
        [self registerClass:[ActivityCollectionViewCell class] forCellWithReuseIdentifier:@"acti"];
    }
    
    return self;
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"acti" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else {
        RoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"room" forIndexPath:indexPath];
        cell.roomModel = self.dataArr[indexPath.item-1];
        return cell;
    }
}

@end
