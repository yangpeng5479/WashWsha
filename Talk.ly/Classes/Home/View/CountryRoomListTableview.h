//
//  CountryRoomListTableview.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryRoomListTableview : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArr;
@end
