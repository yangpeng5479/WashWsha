//
//  CountryCodeTableViewCell.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/5/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryCodeModel.h"

@interface CountryCodeTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *countryLabel;
@property(nonatomic,strong)UILabel *codeLabel;
@property(nonatomic,strong)CountryCodeModel *model;

@end
