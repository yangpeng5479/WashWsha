//
//  ActivityModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/3.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property(nonatomic,assign)float can_withdraw_total;
@property(nonatomic,assign)float win_total;

@property(nonatomic,copy)NSString *answer_activity_id;
@property(nonatomic,copy)NSString *create_user_id;
@property(nonatomic,assign)NSInteger curr_question_no;
@property(nonatomic,copy)NSString *curr_question_status;
@property(nonatomic,copy)NSString *header_image;
@property(nonatomic,assign)NSInteger jackpot;
@property(nonatomic,assign)NSInteger join_count;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger online_count;
@property(nonatomic,copy)NSString *room_id;
@property(nonatomic,copy)NSString *start_time;
@property(nonatomic,copy)NSString *curr_time;
@property(nonatomic,copy)NSString *status;

@end
