//
//  GoldModel.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "GoldModel.h"

@implementation GoldModel

- (NSComparisonResult)compareWithStu:(GoldModel *)model {
    if (self.order_no > model.order_no)
    {
        return NSOrderedDescending;
    }
    else if (self.order_no == model.order_no)
    {
        return NSOrderedSame;
    }
    else
    {
        return NSOrderedAscending;
    }
}
@end
