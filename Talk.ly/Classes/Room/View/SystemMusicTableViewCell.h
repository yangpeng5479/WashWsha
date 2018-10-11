//
//  SystemMusicTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/26.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicModel.h"

@interface SystemMusicTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)MusicModel *model;

@end
