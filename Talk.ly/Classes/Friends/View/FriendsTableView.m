//
//  FriendsTableView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FriendsTableView.h"
#import "FriendsTableViewCell.h"

@implementation FriendsTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] init];
        self.rowHeight = 90;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friends"];
    if (!cell) {
        
        cell = [[FriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friends"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

@end
