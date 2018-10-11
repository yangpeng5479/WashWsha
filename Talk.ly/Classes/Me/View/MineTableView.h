//
//  MineTableView.h
//  video
//
//  Created by 杨鹏 on 2018/5/22.
//  Copyright © 2018年 BeijingChenggongNewEntertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableView : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSArray *contentArr;
@property(nonatomic,strong)UILabel *silverLabel;
@property(nonatomic,strong)UILabel *goldLabel;
@property(nonatomic,strong)UILabel *incomeLabel;

@end
