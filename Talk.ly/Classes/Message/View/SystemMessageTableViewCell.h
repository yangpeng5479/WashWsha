//
//  SystemMessageTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeSystemModel.h"

@interface SystemMessageTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)NoticeSystemModel *systemModel;
@end
