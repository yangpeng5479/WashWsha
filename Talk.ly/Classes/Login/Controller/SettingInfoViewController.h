//
//  SettingInfoViewController.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingInfoViewController : UIViewController

@property(nonatomic,copy)NSString *phoneStr;
@property(nonatomic,copy)NSString *passwordStr;
@property(nonatomic,strong)NSMutableDictionary *infoMdic;

@end
