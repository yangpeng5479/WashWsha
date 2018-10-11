//
//  LiveView.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LiveView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"

@implementation LiveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _iconBgView = [[UIView alloc] init];
    _iconBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-user"]];
    _iconBgView.layer.cornerRadius = 15;
    _iconBgView.layer.masksToBounds = YES;
    [self addSubview:_iconBgView];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = 15;
    _iconView.layer.masksToBounds = YES;
    _iconView.image = [UIImage imageNamed:@"icon-people"];
    [_iconBgView addSubview:_iconView];
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.layer.cornerRadius = 15;
    _followBtn.layer.masksToBounds = YES;
    [_followBtn setImage:[UIImage imageNamed:@"icon-Following"] forState:UIControlStateNormal];
    [_iconBgView addSubview:_followBtn];
    
    _nameeLabel = [[MarqueeLabel alloc] init];
    _nameeLabel.scrollDuration = 8.0;
    _nameeLabel.fadeLength = 10.0f;
    _nameeLabel.font = [UIFont systemFontOfSize:13];
    _nameeLabel.textAlignment = NSTextAlignmentLeft;
    _nameeLabel.textColor = [UIColor whiteColor];
    [_iconBgView addSubview:_nameeLabel];
    
    _idLabel = [[UILabel alloc] init];
    _idLabel.font = [UIFont systemFontOfSize:10];
    _idLabel.textColor = [UIColor whiteColor];
    [_idLabel sizeToFit];
    [_iconBgView addSubview:_idLabel];
    
    _incomeView = [[UIView alloc] init];
    _incomeView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-income"]];
    _incomeView.layer.cornerRadius = 8;
    _incomeView.layer.masksToBounds = YES;
    [self addSubview:_incomeView];
    
    _incomeLabel = [[UILabel alloc] init];
    _incomeLabel.font = [UIFont systemFontOfSize:10];
    _incomeLabel.textColor = [UIColor whiteColor];
    _incomeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigdiamond" bounds:CGRectMake(0, -2, 10, 9) str:@" 0"];
    [_incomeLabel sizeToFit];
    [_incomeView addSubview:_incomeLabel];
    
    CGFloat w = kScreenWidth - 10 - 110 - 15 - 25;
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置具体属性
    CGFloat width = 35;
    CGFloat height = width;
    //    layout.minimumLineSpacing = kSpace;
    layout.minimumInteritemSpacing  = kCellSpace;
    layout.itemSize = CGSizeMake(width, height);
    layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0,kSpace,0,0);
    
    _onlineCV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _onlineCV.showsHorizontalScrollIndicator = NO;
    _onlineCV.backgroundColor = [UIColor clearColor];
    [self addSubview:_onlineCV];
    
    _onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _onlineBtn.layer.cornerRadius = kSpace;
    _onlineBtn.layer.masksToBounds = YES;
    [_onlineBtn setBackgroundImage:[UIImage imageNamed:@"bg-Online"] forState:UIControlStateNormal];
    [_onlineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_onlineBtn];
    
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomView];
    
    _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_messageBtn setImage:[UIImage imageNamed:@"icon-RoomMessage"] forState:UIControlStateNormal];
    [_bottomView addSubview:_messageBtn];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon-Close-1"] forState:UIControlStateNormal];
    [_bottomView addSubview:_closeBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setImage:[UIImage imageNamed:@"icon-share"] forState:UIControlStateNormal];
    [_bottomView addSubview:_shareBtn];
    
    _giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_giftBtn setImage:[UIImage imageNamed:@"icon-gift"] forState:UIControlStateNormal];
    [_bottomView addSubview:_giftBtn];
    
    [_iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(kSpace);
        make.top.mas_equalTo(self.mas_top).offset(3*kSpace);
        make.width.offset(110);
        make.height.offset(30);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconBgView.mas_left);
        make.top.mas_equalTo(_iconBgView.mas_top);
        make.width.height.equalTo(@30);
    }];
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_iconBgView.mas_right);
        make.top.mas_equalTo(_iconBgView.mas_top);
        make.width.height.equalTo(@30);
    }];
    [_nameeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconView.mas_right).offset(kCellSpace);
        make.top.mas_equalTo(_iconBgView.mas_top).offset(1);
        make.width.offset(70);
        make.height.offset(14);
    }];
    [_idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(_iconBgView.mas_bottom).offset(-1);
        make.left.mas_equalTo(_nameeLabel.mas_left);
    }];
    
    [_onlineCV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconBgView.mas_right).offset(15);
        make.centerY.mas_equalTo(_iconBgView.mas_centerY);
        make.width.offset(w);
        make.height.offset(35);
    }];
    [_onlineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).offset(-kSpace);
        make.centerY.mas_equalTo(_onlineCV.mas_centerY);
        make.width.height.equalTo(@30);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        make.height.offset(40);
    }];
    [_messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_bottomView.mas_left).offset(kSpace);
        make.bottom.mas_equalTo(_bottomView.mas_bottom);
        make.width.height.equalTo(@40);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_bottomView.mas_right).offset(-kSpace);
        make.centerY.mas_equalTo(_messageBtn.mas_centerY);
        make.height.width.equalTo(@40);
    }];
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_closeBtn.mas_left).offset(-kSpace);
        make.centerY.mas_equalTo(_messageBtn.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_shareBtn.mas_left).offset(-kSpace);
        make.centerY.mas_equalTo(_messageBtn.mas_centerY);
        make.width.height.equalTo(@40);
    }];
    [_incomeView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_iconView.mas_left);
        make.top.mas_equalTo(_iconView.mas_bottom).offset(kCellSpace);
        make.height.offset(16);
        make.width.offset(50);
    }];
    [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_equalTo(_incomeView.mas_centerY);
        make.centerX.mas_equalTo(_incomeView.mas_centerX);
    }];
}

@end
