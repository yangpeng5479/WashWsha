//
//  RoomTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "BaseFindTableViewCell.h"
#import "RoomModel.h"

@interface RoomTableViewCell : BaseFindTableViewCell

@property(nonatomic,strong)UILabel *signatureLabel;
@property(nonatomic,strong)UILabel *roomIntroduceLbael;

@property(nonatomic,strong)RoomModel *roomModel;
@end
