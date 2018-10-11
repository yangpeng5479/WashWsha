//
//  FriendsTableViewCell.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


@implementation FriendsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.onlineLabel.hidden = YES;
    
    [self.iconView xw_roundedCornerWithRadius:35 cornerColor:[UIColor whiteColor]];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.iconView.mas_right).offset(kSpace);
        make.top.mas_equalTo(self.iconView.mas_top);
    }];
    
    [self.signatureLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
        make.left.mas_equalTo(self.nameLabel.mas_left);
    }];
}

- (void)setModel:(UserModel *)model {
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    self.nameLabel.text = _model.name;
    if ([_model.signature isEqualToString:@""]) {
        self.signatureLabel.text = @"The user did not set a signature";
    }else {
        self.signatureLabel.text = _model.signature;
    }
}

@end
