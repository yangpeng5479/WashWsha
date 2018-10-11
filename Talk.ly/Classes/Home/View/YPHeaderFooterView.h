//
//  YPHeaderFooterView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPHeaderFooterView : UITableViewHeaderFooterView
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UILabel *leftlabel;
@property (nonatomic, strong) UILabel *rightlabel;
@end
