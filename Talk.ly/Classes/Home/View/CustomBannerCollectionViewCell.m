//
//  CustomBannerCollectionViewCell.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/10/10.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CustomBannerCollectionViewCell.h"
#import <UIView+SDExtension.h>
#import "CommonPrex.h"

@implementation CustomBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] init];;
    _imageView.layer.cornerRadius = kCellSpace;
    _imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(kSpace, kCellSpace, kScreenWidth-2*kSpace, self.height-kSpace);
}

@end
