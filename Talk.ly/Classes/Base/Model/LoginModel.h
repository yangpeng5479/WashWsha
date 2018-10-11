//
//  LoginModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/1.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
/*
 {
 "age_range" =     {
 min = 21;
 };
 "first_name" = "\U9e4f";
 gender = male;
 id = 125323378298118;
 "last_name" = "\U6768";
 link = "https://www.facebook.com/app_scoped_user_id/125323378298118/";
 locale = "zh_CN";
 name = "\U6768\U9e4f";
 picture = {
 data =   {
 height = 50;
 "is_silhouette" = 1;
 url = "https://scontent.xx.fbcdn.net/v/t1.0-1/c15.0.50.50/p50x50/10354686_10150004552801856_220367501106153455_n.jpg?oh=58094ae96718bcfcbd53cfea5151eaf5&oe=5B137D2F";
 width = 50;
 };
 };
 timezone = 8;
 "updated_time" = "2018-02-28T11:27:57+0000";
 verified = 1;
 }
 */

@property(nonatomic,copy)NSString *age;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *locale;
@property(nonatomic,copy)NSString *portrait;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *name;

@end
