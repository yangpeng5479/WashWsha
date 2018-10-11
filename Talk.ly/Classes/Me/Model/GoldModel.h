//
//  GoldModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldModel : NSObject
@property(nonatomic,copy)NSString *get_coin_total;
@property(nonatomic,copy)NSString *official_exchange_diamond_id;
@property(nonatomic,assign)NSInteger order_no;
@property(nonatomic,copy)NSString *pay_diamond_total;


@property(nonatomic,copy)NSString *get_diamond_total;
@property(nonatomic,copy)NSString *pay_coupon_total;
@property(nonatomic,copy)NSString *official_exchange_coupon_id;

- (NSComparisonResult)compareWithStu:(GoldModel *)model;

@end
