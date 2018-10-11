//
//  MineProfilePhotosView.m
//  GameTogether_iOS
//
//  Created by Mac on 16/5/13.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "MineProfilePhotosView.h"
#import "CommonPrex.h"
#import "DataService.h"

static NSString *cellStr = @"mineProfileCell";

@implementation MineProfilePhotosView

- (instancetype)initWithFrame:(CGRect)frame collectionViewFlowLayout:(UICollectionViewFlowLayout *)layout {
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.dataSource = self;
        self.shakeLevel = 3.0f;
        self.backgroundColor = [UIColor whiteColor];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.backgroundColor = kLightBgColor;
        [_addBtn setImage:[UIImage imageNamed:@"oyell_jiazhaopian"] forState:UIControlStateNormal];
        _addBtn.size = layout.itemSize;
        [self addSubview:_addBtn];
        
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellStr];
    }
    
    return self;
}

#pragma mark - <XWDragCellCollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_imageNameMarr.count < 8){
        
        _addBtn.left = kSpace+(_imageNameMarr.count%4)*(_addBtn.width+kSpace);
        _addBtn.top = kSpace+(_imageNameMarr.count/4)*(_addBtn.height+kSpace);
        
        _addBtn.hidden = NO;
    }else {
        
        _addBtn.hidden = YES;
    }
    
    return _imageNameMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellStr forIndexPath:indexPath];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:cell.bounds];
//    [DataService loadWebImageWithImageView:imageV string:_imageNameMarr[indexPath.item] defaultString:@"oyell_new_moren" defaultBlock:NO];
    [cell addSubview:imageV];
    
    return cell;
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView{
    
    return _imageNameMarr;
}

@end
