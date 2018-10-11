//
//  InroomTopView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "InroomTopView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "CountryChociceCollectionViewCell.h"

@implementation InroomTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.userInteractionEnabled = YES;
    
    //可滚动名字
    _nameLabel = [[MarqueeLabel alloc] init];
    _nameLabel.scrollDuration = 8.0;
    _nameLabel.fadeLength = 10.0f;
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];
    
    //关注按钮
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.backgroundColor = kNavColor;
    [_followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _followBtn.layer.cornerRadius = 9;
    [self addSubview:_followBtn];
    
    //在线人数
    _onlineLabel = [[UILabel alloc] init];
    _onlineLabel.font = [UIFont systemFontOfSize:10];
    [_onlineLabel sizeToFit];
    _onlineLabel.textColor = [UIColor whiteColor];
    [self addSubview:_onlineLabel];
    
    //喜欢人数
    _likeLabel = [[UILabel alloc] init];
    _likeLabel.font = [UIFont systemFontOfSize:10];
    _likeLabel.textColor = [UIColor whiteColor];
    [_likeLabel sizeToFit];
    [self addSubview:_likeLabel];
    
    CGFloat w = kScreenWidth - 60 - 65 - 5 - 50 - 30 - 30;
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    CGFloat width = 35;
    CGFloat height = width;
    //    layout.minimumLineSpacing = kSpace;
    layout.minimumInteritemSpacing  = kCellSpace;
    layout.itemSize = CGSizeMake(width, height);
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0,kSpace,0,0);
    
    _onlineCollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _onlineCollectionview.showsHorizontalScrollIndicator = NO;
    _onlineCollectionview.backgroundColor = [UIColor clearColor];
    [self addSubview:_onlineCollectionview];
    [_onlineCollectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"online"];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.layer.cornerRadius = 15;
    _moreBtn.layer.masksToBounds = YES;
    [_moreBtn setImage:[UIImage imageNamed:@"icon-default"] forState:UIControlStateNormal];
    [self addSubview:_moreBtn];
    
    _reportRoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reportRoomBtn setImage:[UIImage imageNamed:@"icon-dian"] forState:UIControlStateNormal];
    [self addSubview:_reportRoomBtn];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.top.mas_equalTo(self.mas_top);
        make.width.offset(65);
        make.height.offset(15);
    }];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_right).offset(kCellSpace);
        make.centerY.mas_equalTo(_nameLabel.mas_centerY);
        make.width.offset(50);
        make.height.offset(18);
    }];
    [_onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(kCellSpace);
    }];
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_onlineLabel.mas_right).offset(2*kSpace);
        make.top.mas_equalTo(_onlineLabel.mas_top);
    }];
    [_reportRoomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.equalTo(@30);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_reportRoomBtn.mas_left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.height.equalTo(@30);
    }];
    [_onlineCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_moreBtn.mas_left).offset(-kSpace);
        make.top.mas_equalTo(self.mas_top);
        make.width.offset(w);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}
@end
