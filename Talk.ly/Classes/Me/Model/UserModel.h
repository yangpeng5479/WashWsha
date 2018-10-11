//
//  UserModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/2.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject

@property(nonatomic,copy)NSString *active_lv;
@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *charm_lv;
@property(nonatomic,copy)NSString *constellation;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *country_code;
@property(nonatomic,copy)NSString *country_icon;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *signature;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *v_flag;
@property(nonatomic,copy)NSString *wealth_lv;
@property(nonatomic,copy)NSString *forbid_share;
@property(nonatomic,assign)BOOL has_follow;
@property(nonatomic,copy)NSString *income;
@property(nonatomic,copy)NSString *expend;
@property(nonatomic,copy)NSString *position;
@property(nonatomic,copy)NSString *contribute;
@property(nonatomic,assign)NSInteger contribute_charm;
@property(nonatomic,copy)NSString *role;
@property(nonatomic,strong)NSDictionary *invite_info;
/*
 "invite_info" =             {
 "has_invited" = 0;
 "invite_code" = xmzXIo;
 };
 */
@property(nonatomic,strong)NSDictionary *openplatform_binding_info;
/*
 "openplatform_binding_info" =             {
 facebook = 0;
 google = 0;
 instagram = 0;
 twitter = 1;
 };
 */
@property(nonatomic,strong)NSDictionary *follow_info;
/*
 "follow_info" =             {
 "follower_count" = 3;
 "star_count" = 0;
 };
 */

@end
