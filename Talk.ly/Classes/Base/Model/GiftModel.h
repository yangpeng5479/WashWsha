//
//  GiftModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/23.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property(nonatomic,assign)NSInteger gift_coin_total;
@property(nonatomic,assign)NSInteger gift_diamond_total;
@property(nonatomic,copy)NSString *gift_image_key;
@property(nonatomic,copy)NSString *gift_key;
@property(nonatomic,copy)NSString *gift_name;
@property(nonatomic,copy)NSString *order_no;
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)NSString *type;

@end
