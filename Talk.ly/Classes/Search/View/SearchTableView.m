//
//  SearchTableView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/27.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SearchTableView.h"
#import "BaseTableViewCell.h"
#import "SearchUserTableViewCell.h"

@implementation SearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] init];
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_pageIndex == 0) {
        BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchroom"];
        if (cell == nil) {
            
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchroom"];
        }
        cell.roomModel = self.dataArr[indexPath.row];
        return cell;
    }else {
        SearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchuser"];
        if (cell == nil) {
            
            cell = [[SearchUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchuser"];
        }
        cell.userModel = self.dataArr[indexPath.row];
        return cell;
    }
}
@end
