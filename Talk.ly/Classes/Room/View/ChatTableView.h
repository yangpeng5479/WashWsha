//
//  ChatTableView.h
//  GameTogether_iOS
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTableViewCell.h"

@interface ChatTableView : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *messageMarr;
@property(nonatomic,strong)NSMutableArray *onlineUserMarr;
@property(nonatomic,strong)NSMutableArray *textContainers;


@end
