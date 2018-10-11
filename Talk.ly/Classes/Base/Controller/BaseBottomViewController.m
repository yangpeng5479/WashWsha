//
//  BaseBottomViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/29.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseBottomViewController.h"
#import "BaseNavigationController.h"
#import "CommonPrex.h"
#import "MineViewController.h"
#import "YpTabbarController.h"

@interface BaseBottomViewController ()

@end

@implementation BaseBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MineViewController *mineVC = [[MineViewController alloc] init];
    BaseNavigationController *mineNav = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    YpTabbarController *tabbarVC = [[YpTabbarController alloc] init];
    self.leftDrawerViewController = mineNav;
    self.centerViewController = tabbarVC;
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    self.maximumLeftDrawerWidth = kDrawerWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
