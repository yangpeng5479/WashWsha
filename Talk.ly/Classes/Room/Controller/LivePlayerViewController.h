//
//  LivePlayerViewController.h
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/10.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomModel.h"

@interface LivePlayerViewController : UIViewController

@property(nonatomic,strong)ChatRoomModel *roomModel;
@property(nonatomic,assign)BOOL isForbidenSpeak;

@end
