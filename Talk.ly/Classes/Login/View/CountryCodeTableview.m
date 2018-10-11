//
//  CountryCodeTableview.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "CountryCodeTableview.h"
#import "CountryCodeTableViewCell.h"
#import "CountryCodeModel.h"

@implementation CountryCodeTableview

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.tableFooterView = [[UIView alloc] init];
        self.rowHeight = 50;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"code"];
    if (!cell) {
        
        cell = [[CountryCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"code"];
    }
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

@end
