//
//  ChatRoomModel.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ChatRoomModel.h"

@implementation ChatRoomModel
+ (NSDictionary *)objectClassInArray{
    return @{
             @"applySpeakers" : @"UserModel",
             @"listeners" : @"UserModel",
             @"speakers" : @"UserModel"
             };
}

@end
