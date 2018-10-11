//
//  NoticeSystemModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/28.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeSystemModel : NSObject

@property(nonatomic,assign)NSInteger notice_id;
@property(nonatomic,assign)NSInteger receive_user_id;
@property(nonatomic,assign)NSInteger send_user_id;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSDictionary *send_user;
/*
 name
 */

@end
