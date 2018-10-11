//
//  ChooseGiftView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ChooseGiftView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"

@implementation ChooseGiftView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"giftbg"]];
        self.userInteractionEnabled = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    /*
    "gift_coin_total" = 0;
     "gift_diamond_total" = 50;
     "gift_image_key" = "";
     "gift_key" = g11;
     "gift_name" = "Hug Bear";
     "order_no" = 11;
     */
    _giftArr = [[AccountManager sharedAccountManager].giftListMarr copy];
    _giftKeyArr = [NSMutableArray array];
    _moneyArr = [NSMutableArray array];
    
    for (int i = 0; i < _giftArr.count; ++i) {
        NSDictionary *dic = _giftArr[i];
        [_giftKeyArr addObject:dic[@"gift_key"]];
        if (i == 1) {
            [_moneyArr addObject:dic[@"gift_coin_total"]];
        }else {
            [_moneyArr addObject:dic[@"gift_diamond_total"]];
        }
    }
    int page = (int)(_giftArr.count%8==0 ? _giftArr.count/8 : (_giftArr.count/8+1));
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250-5*kSpace)];
    _bgScrollView.contentSize = CGSizeMake(page*kScreenWidth, _bgScrollView.height);
    _bgScrollView.showsHorizontalScrollIndicator = NO;
    _bgScrollView.pagingEnabled = YES;
    _bgScrollView.delegate = self;
    _bgScrollView.userInteractionEnabled = YES;
    _bgScrollView.delaysContentTouches = YES;
    _bgScrollView.canCancelContentTouches = NO;
    [self addSubview:_bgScrollView];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *coinNumArr = [NSMutableArray array];
    
    for (int j = 0; j < page; ++j) {
        
        //创建每页的数组
        NSMutableArray *tempImageArr = [NSMutableArray array];
        NSMutableArray *tempMoneyArr = [NSMutableArray array];
        
        //每页的8个
        for (int i = 0; i < 8; ++i) {
            
            if (_giftArr.count <= i+8*j) {
                break;
            }
            [tempImageArr addObject:[AccountManager sharedAccountManager].imageArr[i+j*8]];
            [tempMoneyArr addObject:_moneyArr[i+j*8]];
        }
        [imageArr addObject:tempImageArr];
        [coinNumArr addObject:tempMoneyArr];
    }
    
    for (int j = 0; j < page; ++j)  {
        NSArray *image = imageArr[j];
        NSArray *coin = coinNumArr[j];
        
        for (int i = 0; i < image.count; ++i) {
            CGFloat x = i%4;
            CGFloat y = i/4;
            
            
            UIView *backview = [self _createGiftButtonWithImageName:image[i] coinNum:coin[i] I:i J:j];
            backview.origin = CGPointMake(j*self.width+0.5+x*backview.width, y*backview.height+0.5);
            backview.userInteractionEnabled = YES;
            [_bgScrollView addSubview:backview];
            backview.tag = 500+j*8+i;
        }
    }
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _bgScrollView.bottom, kScreenWidth, 0.5)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineLabel];
    
//    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.width-35)/2, self.height-35, 35, 5)];
//    pageControl.tag = 600;
//    pageControl.numberOfPages = page;
//    [self addSubview:pageControl];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 250-49.5, kScreenWidth, 49.5)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    UIImageView *goldImageview = [[UIImageView alloc] init];
    goldImageview.image = [UIImage imageNamed:@"icon-silver"];
    [bottomView addSubview:goldImageview];
    
    _goldLabel = [[UILabel alloc] init];
    _goldLabel.text = @"0";
    [_goldLabel sizeToFit];
    _goldLabel.font = [UIFont systemFontOfSize:12];
    _goldLabel.textColor = [UIColor whiteColor];
    [bottomView addSubview:_goldLabel];

    UIImageView *diamondImageview = [[UIImageView alloc] init];
    diamondImageview.image = [UIImage imageNamed:@"icon-USdollar"];
    [bottomView addSubview:diamondImageview];
    
    _diamondLabel = [[UILabel alloc] init];
    _diamondLabel.text = @"0";
    [_diamondLabel sizeToFit];
    _diamondLabel.textColor = [UIColor whiteColor];
    _diamondLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:_diamondLabel];

    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.backgroundColor = kNavColor;
    [_rechargeBtn setTitle:@"Recharge" forState:UIControlStateNormal];
    [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rechargeBtn.layer.cornerRadius = kSpace+kCellSpace;
    _rechargeBtn.layer.masksToBounds = YES;
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:_rechargeBtn];
    
    _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_arrowBtn setImage:[UIImage imageNamed:@"icon-Downarrow"] forState:UIControlStateNormal];
    [bottomView addSubview:_arrowBtn];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"icon-people"];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    [bottomView addSubview:_iconView];
    
    _destinationLabel = [[UILabel alloc] init];
    _destinationLabel.text = @"Give:";
    _destinationLabel.font = [UIFont systemFontOfSize:12];
    _destinationLabel.textColor = [UIColor whiteColor];
    _destinationLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_destinationLabel];
    
    //添加约束
    [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(bottomView.mas_left).offset(15);
        make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-kSpace);
    }];
    [goldImageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_goldLabel.mas_centerX);
        make.bottom.mas_equalTo(_goldLabel.mas_top).offset(-kCellSpace);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    [_diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_goldLabel.mas_right).offset(30);
        make.bottom.mas_equalTo(_goldLabel.mas_bottom);
    }];
    [diamondImageview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(_diamondLabel.mas_centerX);
        make.top.mas_equalTo(goldImageview.mas_top);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    [_rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.left.mas_equalTo(_diamondLabel.mas_right).offset(15);
        make.width.offset(70);
        make.height.offset(30);
    }];
    
    [_arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(bottomView.mas_right).offset(-15);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.width.offset(30);
        make.height.offset(30);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_arrowBtn.mas_left).offset(-kCellSpace);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.width.offset(40);
        make.height.offset(40);
    }];
    [_destinationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_iconView.mas_left).offset(-kCellSpace);
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.width.offset(150);
        make.height.offset(12);
    }];
    
}
- (UIView *)_createGiftButtonWithImageName:(NSString *)imageName coinNum:(NSString *)coinNum I:(int)i J:(int)j{
    
    CGFloat width = (kScreenWidth-1.5)/4;
    CGFloat height = (250-50-0.5)/2;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    UIImageView *giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-40)/2, 25, 40, 40)];
    giftImageView.contentMode = UIViewContentModeScaleAspectFit;
    giftImageView.image = [UIImage imageNamed:imageName];
    giftImageView.userInteractionEnabled = YES;
    [view addSubview:giftImageView];
    
    UILabel *coinLabel = [[UILabel alloc] init];
    if (UI_IS_IPHONE6PLUS) {
        coinLabel.frame = CGRectMake(0, giftImageView.bottom+kSpace, width, 15);
    }else {
        coinLabel.frame = CGRectMake(0, giftImageView.bottom+kSpace, width, 15);
    }
    
    coinLabel.textColor = [UIColor whiteColor];
    coinLabel.textAlignment = NSTextAlignmentCenter;
    coinLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *str = [NSString stringWithFormat:@"%ld",[coinNum integerValue]];
    if (j == 0) {
        if (i == 1) {
            coinLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-silver" bounds:CGRectMake(0, -2, 15, 15) str:str];
        }else {
            //icon-USdollar
            
            coinLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-USdollar" bounds:CGRectMake(0, -2, 15, 15) str:str];
        }
    }else {
        coinLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-USdollar" bounds:CGRectMake(0, -2, 15, 15) str:str];
    }
    [view addSubview:coinLabel];
    
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    int page = scrollView.contentOffset.x/self.width;
//    UIPageControl *pageControl = (UIPageControl *)[self viewWithTag:600];
//    pageControl.currentPage = page;
}


@end
