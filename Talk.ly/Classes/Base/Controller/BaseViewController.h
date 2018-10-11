//
//  BaseViewController.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYTabPagerView.h>

@interface BaseViewController : UIViewController <TYTabPagerViewDataSource>

@property(nonatomic,strong)NSArray *titleArr;
@property (nonatomic, weak) TYTabPagerView *pagerView;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UIButton *searchBtn;

@end
