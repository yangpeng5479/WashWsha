//
//  WalletModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletModel : NSObject

/*
 {
 "max_withdraw" = "0.00";
 wallet =         {
 "coin_total" = 0;
 "coupon_total" = 0;
 "diamond_total" = 0;
 };
 }
 */

@property(nonatomic,assign)float max_withdraw;
@property(nonatomic,strong)NSDictionary *wallet;

@end
