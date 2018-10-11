//
//  RoomTableView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomTableView.h"
#import "RoomTableViewCell.h"
#import <Masonry.h>

@implementation RoomTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableFooterView = [[UIView alloc] init];
        self.rowHeight = 70;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        RoomTableViewCell *cell = [[RoomTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cell.leveImageView.image = [UIImage imageNamed:@"icon-goldmedal"];
        cell.roomModel = self.dataArr[indexPath.row];
        return cell;
    }else if (indexPath.row == 1) {
        RoomTableViewCell *cell = [[RoomTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cell.leveImageView.image = [UIImage imageNamed:@"icon-silvermedal"];
        cell.roomModel = self.dataArr[indexPath.row];
        return cell;
    }else if (indexPath.row == 2) {
        RoomTableViewCell *cell = [[RoomTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cell.leveImageView.image = [UIImage imageNamed:@"icon-bronzemedal"];
        cell.roomModel = self.dataArr[indexPath.row];
        return cell;
    }else {
        RoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"room"];
        if (!cell) {
            
            cell = [[RoomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"room"];
            [cell.leveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).offset(17.5);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.offset(25);
                make.height.offset(25);
            }];
        }
        cell.leveImageView.image = [UIImage imageNamed:@"grade-bg"];
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.roomModel = self.dataArr[indexPath.row];
        return cell;
    }
}

@end
