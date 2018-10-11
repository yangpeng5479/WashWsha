//
//  UserListTableView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/23.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserListTableView : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSArray *userListArr;
@end
