//
//  MessageTableView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "MessageTableView.h"
#import "FriendMessageTableViewCell.h"
#import "SystemMessageTableViewCell.h"

@implementation MessageTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] init];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        FriendMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fmessage"];
        if (!cell) {
            
            cell = [[FriendMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fmessage"];
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"Friend Request";
                cell.imageview.image = [UIImage imageNamed:@"icon-friendrequest"];
            }else {
                cell.titleLabel.text = @"New Gift";
                cell.imageview.image = [UIImage imageNamed:@"icon-newgift"];
            }
        }
        return cell;
    }else {
        
        SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"smessage"];
        if (!cell) {
            
            cell = [[SystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"smessage"];
            cell.imageview.image = [UIImage imageNamed:@"icon-systemmessage"];
        }
        NoticeSystemModel *model = self.dataArr[indexPath.row-2];
        cell.systemModel = model;
        return cell;
    }
}
@end
