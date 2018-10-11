//
//  LevelTableView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelTableView : UITableView<UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArr;
@end
