//
//  MineTableView.m
//  video
//
//  Created by 杨鹏 on 2018/5/22.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import "MineTableView.h"
#import "MineTableViewCell.h"
#import <Masonry.h>
#import "CommonPrex.h"

@implementation MineTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = @[@[@"Profile",@"Sliver",@"Gold",@"Income"],@[@"Setting and Privacy",@"Coupon",@"Help center"]];
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mine"];
    if (!cell) {
        
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mine"];
        cell.label.text = arr[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                _silverLabel = [[UILabel alloc] init];
                _silverLabel.font = [UIFont systemFontOfSize:15];
                _silverLabel.textColor = k153Color;
                [_silverLabel sizeToFit];
                [cell.contentView addSubview:_silverLabel];
                [_silverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.mas_equalTo(cell.contentView.mas_right);
                    make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                }];
            }else if (indexPath.row == 2) {
                _goldLabel = [[UILabel alloc] init];
                _goldLabel.font = [UIFont systemFontOfSize:15];
                _goldLabel.textColor = k153Color;
                [_goldLabel sizeToFit];
                [cell.contentView addSubview:_goldLabel];
                [_goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.mas_equalTo(cell.contentView.mas_right);
                    make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                }];
            }else if (indexPath.row == 3) {
                _incomeLabel = [[UILabel alloc] init];
                _incomeLabel.font = [UIFont systemFontOfSize:15];
                _incomeLabel.textColor = k153Color;
                [_incomeLabel sizeToFit];
                [cell.contentView addSubview:_incomeLabel];
                [_incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.mas_equalTo(cell.contentView.mas_right);
                    make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                }];
            }
        }
    }
    return cell;
}
@end
