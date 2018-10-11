//
//  CharmTableView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CharmTableView.h"
#import "BaseFindTableViewCell.h"
#import <Masonry.h>

@implementation CharmTableView

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
        BaseFindTableViewCell *cell = [[BaseFindTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cell.leveImageView.image = [UIImage imageNamed:@"icon-goldmedal"];
        cell.charmModel = self.dataArr[indexPath.row];
        return cell;
    }else if (indexPath.row == 1) {
        BaseFindTableViewCell *cell = [[BaseFindTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cell.leveImageView.image = [UIImage imageNamed:@"icon-silvermedal"];
        cell.charmModel = self.dataArr[indexPath.row];
        return cell;
    }else if (indexPath.row == 2) {
        BaseFindTableViewCell *cell = [[BaseFindTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        cell.leveImageView.image = [UIImage imageNamed:@"icon-bronzemedal"];
        cell.charmModel = self.dataArr[indexPath.row];
        return cell;
    }else {
        BaseFindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"charm"];
        if (!cell) {
            
            cell = [[BaseFindTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"charm"];
            [cell.leveImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).offset(17.5);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.width.offset(25);
                make.height.offset(25);
            }];
        }
        cell.leveImageView.image = [UIImage imageNamed:@"grade-bg"];
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.charmModel = self.dataArr[indexPath.row];
        return cell;
    }
}

@end
