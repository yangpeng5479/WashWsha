//
//  BaseViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseViewController.h"
#import <TYTabPagerView.h>
#import "CommonPrex.h"
#import "SearchViewController.h"

@interface BaseViewController ()




@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kLightBgColor;
    [self addTabPagerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (IS_IPHONE_X) {
        _pagerView.frame = CGRectMake(0, 40, kScreenWidth,kScreenHeight-44);
    }else {
        _pagerView.frame = CGRectMake(0, 20, kScreenWidth,kScreenHeight-20);
    }
}

- (void)addTabPagerView {
    
    TYTabPagerView *pagerView = [[TYTabPagerView alloc]init];
    pagerView.tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    pagerView.tabBar.backgroundColor = kLightBgColor;
    pagerView.tabBar.layout.adjustContentCellsCenter = YES;
    pagerView.tabBar.layout.selectedTextColor = [UIColor blackColor];
    pagerView.tabBar.layout.normalTextColor = [UIColor lightGrayColor];
    pagerView.tabBar.layout.progressColor = kBlueColor;
    pagerView.tabBar.layout.progressWidth = pagerView.tabBar.layout.cellWidth;
    pagerView.pageView.scrollView.bounces = NO;
//    pagerView.pageView.scrollView.pagingEnabled = YES;
    
    pagerView.tabBarHeight = 50;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
    _pagerView = pagerView;
    
//    _pagerView.tabBar.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    UIView *leftBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, _pagerView.tabBarHeight)];
    leftBgview.backgroundColor = kLightBgColor;
    [_pagerView addSubview:leftBgview];
    
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSpace, (_pagerView.tabBarHeight-25)/2, 25, 25)];
    _logoImageView.image = [UIImage imageNamed:@"oyell_xiaoxi2.3"];
    [leftBgview addSubview:_logoImageView];
    
    UIView *rightBgview = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-50, 0, 50, _pagerView.tabBarHeight)];
    rightBgview.backgroundColor = kLightBgColor;
    [_pagerView addSubview:rightBgview];
    
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchBtn setImage:[UIImage imageNamed:@"icon-search"] forState:UIControlStateNormal];
    _searchBtn.frame = CGRectMake(kSpace, (_pagerView.tabBarHeight-20)/2, 20, 20);
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBgview addSubview:_searchBtn];
}

- (NSInteger)numberOfViewsInTabPagerView {
    return _titleArr.count;
}

- (NSString *)tabPagerView:(TYTabPagerView *)tabPagerView titleForIndex:(NSInteger)index {
    NSString *title = _titleArr[index];
    return title;
}

#pragma mark - touch
- (void)searchBtnClick {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
