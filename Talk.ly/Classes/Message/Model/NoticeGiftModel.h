//
//  NoticeGiftModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/28.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "GiftModel.h"

@interface NoticeGiftModel : NSObject
/*
 gift_info" =                 {
 "gift_coin_total" = 0;
 "gift_diamond_total" = 1;
 "gift_image_key" = "";
 "gift_key" = g2;
 "gift_name" = Like;
 "order_no" = 2;
 };
 */
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,assign)NSInteger gif_count;
@property(nonatomic,strong)GiftModel *gift_info;
@property(nonatomic,assign)BOOL has_follow_me;
@property(nonatomic,copy)NSString *notice_id;
@property(nonatomic,copy)NSString *receive_user_id;
@property(nonatomic,strong)UserModel *send_user;
@property(nonatomic,assign)BOOL status;
@property(nonatomic,assign)BOOL thanked;
@property(nonatomic,copy)NSString *type;

@end
