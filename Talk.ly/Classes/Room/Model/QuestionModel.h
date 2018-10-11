//
//  QuestionModel.h
//  Dr.IQ
//
//  Created by 杨鹏 on 2018/2/25.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property(nonatomic,assign)int answer_question_id;
@property(nonatomic,assign)int order_no;
@property(nonatomic,copy)NSString *question;
@property(nonatomic,copy)NSString *a;
@property(nonatomic,copy)NSString *b;
@property(nonatomic,copy)NSString *c;
@property(nonatomic,copy)NSString *answer;
@property(nonatomic,copy)NSString *answer_desc;
@property(nonatomic,copy)NSString *status;

@end
