//
//  ExploreTableview.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ExploreTableview.h"
#import "BaseTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"
#import <MJExtension.h>

@implementation ExploreTableview

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

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"explore"];
    if (cell == nil) {
        
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"explore"];
    }
    cell.roomModel = self.dataArr[indexPath.row];
    return cell;
}

@end
