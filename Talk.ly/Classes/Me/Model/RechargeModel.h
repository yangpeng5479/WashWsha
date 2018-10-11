//
//  RechargeModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeModel : NSObject

@property(nonatomic,assign)NSInteger award_total;
@property(nonatomic,assign)NSInteger event_award_coins;
@property(nonatomic,assign)NSInteger get_total;
@property(nonatomic,copy)NSString *event_desc;
@property(nonatomic,copy)NSString *iap_key;
@property(nonatomic,assign)float money;
@property(nonatomic,copy)NSString *official_recharge_list_id;
@property(nonatomic,assign)NSInteger order_no;

@end
