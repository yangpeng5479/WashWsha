//
//  UserListTableView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/23.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "UserListTableView.h"
#import "UserListTableViewCell.h"

@implementation UserListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _userListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userlist"];
    if (!cell) {
        
        cell = [[UserListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userlist"];
    }
    cell.userModel = self.userListArr[indexPath.row];
    return cell;
}

@end
