//
//  BaseTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomModel.h"

@interface BaseTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *maleCountLable;
@property(nonatomic,strong)UILabel *femaleCountLable;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UILabel *signatureLabel;
@property(nonatomic,strong)UILabel *onlineCountLabel;
@property(nonatomic,strong)UILabel *onlineLabel;

@property(nonatomic,strong)RoomModel *roomModel;

@end
