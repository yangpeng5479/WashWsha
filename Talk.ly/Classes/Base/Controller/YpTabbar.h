//
//  YpTabbar.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YpTabbar;

@protocol YpTabBarDelegate <NSObject>

-(void)addButtonClick:(YpTabbar *)tabBar;

@end

@interface YpTabbar : UITabBar

@property (nonatomic,weak) id<YpTabBarDelegate> ypTabBarDelegate;

@end
