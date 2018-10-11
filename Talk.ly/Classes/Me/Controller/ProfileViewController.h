//
//  ProfileViewController.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/29.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

//1:自己 2:别人
@property(nonatomic,assign)int type;

@property(nonatomic,copy)NSString *uid;

@end
