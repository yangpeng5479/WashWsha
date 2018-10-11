//
//  MessageModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/21.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentModel.h"

@interface MessageModel : NSObject

@property(nonatomic,copy)NSString *fromUserId;
@property(nonatomic,copy)NSString *fromUserName;
@property(nonatomic,assign)NSInteger messageId;
@property(nonatomic,strong)ContentModel *content;
@property(nonatomic,assign)int type;
@property(nonatomic,assign)int category;

@end
