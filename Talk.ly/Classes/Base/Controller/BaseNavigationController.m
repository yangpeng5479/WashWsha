//
//  BaseNavigationController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithTitle:@""style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = bar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
