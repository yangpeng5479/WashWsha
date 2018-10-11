//
//  SearchTableView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/27.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableView : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic,assign)NSInteger pageIndex;
@end
