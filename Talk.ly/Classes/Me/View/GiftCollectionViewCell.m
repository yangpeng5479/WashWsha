//
//  GiftCollectionViewCell.m
//  video
//
//  Created by 杨鹏 on 2018/6/13.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import "GiftCollectionViewCell.h"
#import <Masonry.h>
#import "CommonPrex.h"

@implementation GiftCollectionViewCell
{
    NSArray *_imageArr;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageArr = @[@"Favor",@"Roseflower",@"Doughnut",@"icecream",@"Abunchofflowers",@"Bags",@"car",@"Icelolly",@"Pizza",@"Bear",@"love",@"heart",@"panda",@"DiamondRing",@"Ship",@"Drink",@"chocolate",@"speaker",@"Redlips",@"dog",@"Cat",@"Crystalshoes",@"Sportscar"];
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _giftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_giftImageView];
    
    _giftNameLable = [[UILabel alloc] init];
    _giftNameLable.font = [UIFont systemFontOfSize:13];
    _giftNameLable.textColor = k153Color;
    _giftNameLable.textAlignment = NSTextAlignmentCenter;
    [_giftNameLable sizeToFit];
    [self.contentView addSubview:_giftNameLable];
    
    CGFloat w = (kScreenWidth-2*kSpace)/4;
    CGFloat imagew = (w-2*kSpace)/2;
    CGFloat margin = (w-imagew)/2;
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.contentView.mas_left).offset(margin);
        make.top.mas_equalTo(self.contentView.mas_top).offset(kSpace);
        make.width.height.equalTo(@(imagew));
    }];
    [_giftNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_giftImageView.mas_bottom).offset(kSpace);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}
- (void)setModel:(GiftModel *)model {
    _model = model;
}
@end
