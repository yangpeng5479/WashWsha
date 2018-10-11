//
//  ContentModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/21.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger num;
@property(nonatomic,copy)NSString *gender;
@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,copy)NSString *toUserName;
@property(nonatomic,copy)NSString *mainHeadImg;
@property(nonatomic,copy)NSString *toHeadImg;
@property(nonatomic,strong)NSDictionary *userCount;
@property(nonatomic,strong)NSArray *nums;
@property(nonatomic,copy)NSString *userIds;

/*
 bonus = 0;
 "online_count" = 0;
 "question_count" =     {
 "a_count" = 0;
 "b_count" = 0;
 "c_count" = 1;
 "right_count" = 0;
 "wrong_count" = 0;
 };
 */
@end
