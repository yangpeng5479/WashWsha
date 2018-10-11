//
//  CountryRoomListTableview.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/11.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CountryRoomListTableview.h"
#import "BaseTableViewCell.h"

@implementation CountryRoomListTableview

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
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
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roomlist"];
    if (cell == nil) {
        
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roomlist"];
    }
    cell.roomModel = self.dataArr[indexPath.row];
    return cell;
}

@end
