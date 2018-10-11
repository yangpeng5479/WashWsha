//
//  RoomModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/2.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface RoomModel : NSObject

@property(nonatomic,copy)NSString *chatroom_id;
@property(nonatomic,copy)NSString *creator_user_id;
@property(nonatomic,copy)NSString *room_name;
@property(nonatomic,copy)NSString *room_desc;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *is_open;
@property(nonatomic,copy)NSString *topic_id;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *country_code;
@property(nonatomic,copy)NSString *country_icon;
@property(nonatomic,copy)NSString *enter_limit;
@property(nonatomic,copy)NSString *enter_pass;
@property(nonatomic,copy)NSString *is_recommend;
@property(nonatomic,copy)NSString *online_female_count;
@property(nonatomic,copy)NSString *online_male_count;
@property(nonatomic,assign)BOOL has_liked;
@property(nonatomic,strong)NSDictionary *topic;
@property(nonatomic,copy)NSString *heat_count;
@property(nonatomic,strong)UserModel *creator_user_info;
@property(nonatomic,assign)BOOL has_follow;
@property(nonatomic,copy)NSString *type;


@end
