//
//  CountryChoiseCollectionView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CountryChoiseCollectionView.h"
#import "CommonPrex.h"
#import "CountryChociceCollectionViewCell.h"

@implementation CountryChoiseCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(kCellSpace, 15, kCellSpace, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat width = (kScreenWidth-6*15)/5.5;
    CGFloat height = 50;
    flowLayout.itemSize = CGSizeMake(width, height);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        [self registerClass:[CountryChociceCollectionViewCell class] forCellWithReuseIdentifier:@"country"];
    }
    
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CountryChociceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"country" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.item];
    return cell;
}

@end
