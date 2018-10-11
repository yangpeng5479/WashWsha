//
//  RoomViewController.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomModel.h"
#import "InroomTopView.h"
#import "InroomCenterView.h"

@interface RoomViewController : UIViewController

@property(nonatomic,strong)InroomTopView *topView;
@property(nonatomic,strong)InroomCenterView *centerView;
@property(nonatomic,strong)ChatRoomModel *chatModel;
@property(nonatomic,assign)int type; //1.房主
@end
