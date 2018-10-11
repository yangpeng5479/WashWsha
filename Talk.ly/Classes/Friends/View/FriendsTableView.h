//
//  FriendsTableView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableView : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArr;
@end
