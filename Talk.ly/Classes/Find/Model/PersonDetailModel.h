//
//  PersonDetailModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/12.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomModel.h"

@interface PersonDetailModel : NSObject

@property(nonatomic,assign)NSInteger active_lv;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,assign)NSInteger charm_lv;
@property(nonatomic,copy)NSString *constellation;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *country_code;
@property(nonatomic,copy)NSString *country_icon;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,assign)BOOL has_follow;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,assign)NSInteger latitude;
@property(nonatomic,assign)NSInteger longitude;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *signature;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,assign)NSInteger v_flag;
@property(nonatomic,assign)NSInteger wealth_lv;
@property(nonatomic,strong)RoomModel *in_chatroom;
@end
