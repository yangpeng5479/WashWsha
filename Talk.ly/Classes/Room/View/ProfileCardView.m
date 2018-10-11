//
//  ProfileCardView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/19.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ProfileCardView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "DataService.h"

@interface ProfileCardView()

@property(nonatomic,strong)UIView *bgview;
@property(nonatomic,strong)UILabel *genderLabel;
@property(nonatomic,strong)UILabel *activeLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *heartLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@end

@implementation ProfileCardView

- (instancetype)initWithFrame:(CGRect)frame withModel:(UserModel *)model type:(BOOL)isHost {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = kCellSpace;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self setupUIusermodel:model type:isHost];
    }
    return self;
}

- (void)setupUIusermodel:(UserModel *)model type:(BOOL)ishost{
    
    _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reportBtn setImage:[UIImage imageNamed:@"icon-Report"] forState:UIControlStateNormal];
    [self addSubview:_reportBtn];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon-close1"] forState:UIControlStateNormal];
    [self addSubview:_closeBtn];
    
    _iconImageView = [[UIImageView alloc] init];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    [_iconImageView xw_roundedCornerWithRadius:85/2 cornerColor:[UIColor whiteColor]];
    _iconImageView.userInteractionEnabled = YES;
    [self addSubview:_iconImageView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = model.name;
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [_nameLabel sizeToFit];
    _nameLabel.textColor = k51Color;
    [self addSubview:_nameLabel];
    
    _bgview = [[UIView alloc] init];
    _bgview.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgview];
    
    _genderLabel = [[UILabel alloc] init];
    _genderLabel.textColor = k102Color;
    _genderLabel.font = [UIFont systemFontOfSize:12];
    [_genderLabel sizeToFit];
    if ([model.gender isEqualToString:@"male"]) {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-male" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",[model.age integerValue]]];
    }else {
        _genderLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-female" bounds:CGRectMake(0, -2, 10, 10) str:[NSString stringWithFormat:@"%ld",[model.age integerValue]]];
    }
    [_bgview addSubview:_genderLabel];
    
    _activeLabel = [[UILabel alloc] init];
    _activeLabel.textColor = k102Color;
    _activeLabel.font = [UIFont systemFontOfSize:12];
    [_activeLabel sizeToFit];
    _activeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-Activevalue" bounds:CGRectMake(0, -2, 12, 12) str:[NSString stringWithFormat:@"%ld",[model.active_lv integerValue]]];
    [_bgview addSubview:_activeLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = [UIFont systemFontOfSize:12];
    _moneyLabel.textColor = k102Color;
    [_moneyLabel sizeToFit];
    _moneyLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-wallet" bounds:CGRectMake(0, -1, 12, 12) str:[NSString stringWithFormat:@"%ld",[model.wealth_lv integerValue]]];
    [_bgview addSubview:_moneyLabel];
    
    _heartLabel = [[UILabel alloc] init];
    _heartLabel.textColor = k102Color;
    _heartLabel.font = [UIFont systemFontOfSize:12];
    [_heartLabel sizeToFit];
    _heartLabel.attributedText = [DataService createAttributedStringWithImageName:@"heart1" bounds:CGRectMake(0, -3, 12, 12) str:[NSString stringWithFormat:@"%ld",[model.charm_lv integerValue]]];
    [_bgview addSubview:_heartLabel];
    
    UILabel *signatureLabel = [[UILabel alloc] init];
    signatureLabel.textColor = k153Color;
    signatureLabel.font = [UIFont systemFontOfSize:12];
    signatureLabel.numberOfLines = 2;
    signatureLabel.textAlignment = NSTextAlignmentCenter;
    if ([model.signature isEqualToString:@""] || !model.signature) {
        signatureLabel.text = @"";
    }else {
        signatureLabel.text = model.signature;
    }
    [self addSubview:signatureLabel];
    
    UILabel *lineLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-44.5, self.width, 0.5)];
    lineLabe.backgroundColor = kLineColor;
    [self addSubview:lineLabe];
    
    if ([[AccountManager sharedAccountManager].userID isEqualToString:model.user_id]) {
        UILabel *meLabel = [[UILabel alloc] init];
        meLabel.text = @"Me";
        meLabel.font = [UIFont systemFontOfSize:17];
        meLabel.textColor = kNavColor;
        meLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:meLabel];
        
        [meLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(lineLabe.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
    }else {
        
        if (model.has_follow == NO) {
            for (int i = 0; i < 2; ++i) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*(self.width/2), self.height-44,self.width/2, 45)];
                btn.tag = 210+i;
                [self addSubview:btn];
                [btn setTitleColor:kNavColor forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                if (i == 0 ) {
                    [btn setTitle:@"Send a Gift" forState:UIControlStateNormal];
                    _sendGiftBtn = btn;
                }else {
                    [btn setTitle:@"Follow" forState:UIControlStateNormal];
                }
            }
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2, self.height-44, 0.5, 45)];
            line.backgroundColor = kLineColor;
            [self addSubview:line];
        }else {
            _sendGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_sendGiftBtn setTitleColor:kNavColor forState:UIControlStateNormal];
            _sendGiftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [_sendGiftBtn setTitle:@"Send a Gift" forState:UIControlStateNormal];
            [self addSubview:_sendGiftBtn];
            
            [_sendGiftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(lineLabe.mas_bottom);
                make.left.mas_equalTo(self.mas_left);
                make.right.mas_equalTo(self.mas_right);
                make.bottom.mas_equalTo(self.mas_bottom);
            }];
        }
    }
    
    if (ishost == YES) {
        //主播查看用户
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setImage:[UIImage imageNamed:@"button-invitetospeak"] forState:UIControlStateNormal];
        [self addSubview:_inviteBtn];
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:12];
        _leftLabel.textColor = k51Color;
        _leftLabel.text = @"Invite to talk";
        [_leftLabel sizeToFit];
        [self addSubview:_leftLabel];
        
        _kickedoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_kickedoutBtn setImage:[UIImage imageNamed:@"button-kickedout"] forState:UIControlStateNormal];
        [self addSubview:_kickedoutBtn];
        
        UILabel *kickLabel = [[UILabel alloc] init];
        kickLabel.textColor = k51Color;
        kickLabel.text = @"Kicked Out";
        kickLabel.font = [UIFont systemFontOfSize:12];
        [kickLabel sizeToFit];
        [self addSubview:kickLabel];
        
        [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(signatureLabel.mas_bottom).offset(kSpace);
            make.left.mas_equalTo(self.mas_left).offset((self.width/2-20)/2);
            make.width.offset(30);
            make.height.offset(30);
        }];
        [_kickedoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(_inviteBtn.mas_top);
            make.right.mas_equalTo(self.mas_right).offset(-(self.width/2-20)/2);
            make.width.offset(30);
            make.height.offset(30);
        }];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_inviteBtn.mas_centerX);
            make.top.mas_equalTo(_inviteBtn.mas_bottom).offset(kSpace);
        }];
        
        [kickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_kickedoutBtn.mas_centerX);
            make.top.mas_equalTo(_kickedoutBtn.mas_bottom).offset(kSpace);
        }];
    }
    
    //添加约束
    [_reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(kSpace);
        make.top.mas_equalTo(self.mas_top).offset(kSpace);
        make.width.offset(30);
        make.height.offset(30);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.mas_right).offset(-kSpace);
        make.top.mas_equalTo(self.mas_top).offset(kSpace);
        make.width.offset(30);
        make.height.offset(30);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(30);
        make.width.offset(85);
        make.height.offset(85);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(_iconImageView.mas_bottom).offset(2*kSpace);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_bgview.mas_left);
        make.centerY.mas_equalTo(_bgview.mas_centerY);
    }];
    [_activeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_genderLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_bgview.mas_centerY);
    }];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_activeLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_bgview.mas_centerY);
    }];
    [_heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_moneyLabel.mas_right).offset(kSpace);
        make.centerY.mas_equalTo(_bgview.mas_centerY);
    }];
    [_bgview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(kSpace);
        make.height.offset(14);
    }];
    [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(50);
        make.top.mas_equalTo(_bgview.mas_bottom).offset(kSpace);
        make.right.mas_equalTo(self.mas_right).offset(-50);
        make.height.offset(25);
    }];
}

- (void)layoutSubviews {
    
    CGFloat w = _genderLabel.width+_activeLabel.width+_moneyLabel.width+_heartLabel.width+3*kSpace;
    [_bgview mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(kSpace);
        make.height.offset(14);
        make.width.offset(w);
    }];
}

















@end
