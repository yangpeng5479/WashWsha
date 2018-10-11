//
//  ChatRoomModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomModel.h"
#import "UserModel.h"

@interface ChatRoomModel : NSObject
/*
 countInfo =         {
 "heat_count" = 122;
 "like_count" = 0;
 "listen_count" = 1;
 "online_count" = 2;
 };
 */
/*
 主播
 "live_count_info" =             {
 "heat_count" = 100;
 "like_count" = 0;
 "listen_count" = 0;
 "online_count" = 1;
 };
 */
@property(nonatomic,strong)RoomModel *chatroom;
@property(nonatomic,strong)NSArray *applySpeakers; //申请说话的
@property(nonatomic,strong)NSArray *listeners;        //听众
@property(nonatomic,strong)NSArray *speakers;            //正在讲话的
@property(nonatomic,copy)NSString *playingGame;         //正在玩的游戏
@property(nonatomic,strong)NSDictionary *countInfo;
@property(nonatomic,strong)NSDictionary *live_count_info; //主持人的信息
@property(nonatomic,strong)NSArray *banSpeakerPostions;
@property(nonatomic,copy)NSString *authUpSpeaker;
@property(nonatomic,assign)BOOL postBanned;


@end
