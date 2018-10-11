//
//  FollowModel.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/29.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowModel : NSObject

@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,assign)NSInteger v_flag;
@property(nonatomic,assign)NSInteger forbid_share;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,assign)NSInteger active_lv;
@property(nonatomic,assign)NSInteger charm_lv;
@property(nonatomic,assign)NSInteger wealth_lv;
@property(nonatomic,copy)NSString *signature;
@property(nonatomic,assign)BOOL is_my_follower;
@property(nonatomic,assign)BOOL is_my_star;
@end
