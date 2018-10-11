//
//  LiveBarrageCell.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/13.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LiveBarrageCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#define kBarrageHeight 40

@interface LiveBarrageCell()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation LiveBarrageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.layer.cornerRadius = kBarrageHeight * 0.5;
        
        [self addOwnViews];
        
        [self layoutFrameOfSubViews];
        
    }
    return self;
}

- (void)addOwnViews
{
    [self addSubview:self.headImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.textLabel];
}

- (void)layoutFrameOfSubViews
{
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(_headImageView.mas_height);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(8);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom);
        make.bottom.right.equalTo(self);
    }];
}

- (void)setBarrageModel:(MessageModel *)barrageModel
{
    _barrageModel = barrageModel;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_barrageModel.content.mainHeadImg] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    
    if ([_barrageModel.content.gender isEqualToString:@"female"]) {
        _nameLabel.textColor = [UIColor colorWithRed:255/255.0 green:168/255.0 blue:164/255.0 alpha:1.0];
    }else {
        _nameLabel.textColor = [UIColor colorWithRed:71/255.0 green:188/255.0 blue:226/255.0 alpha:1.0];
    }
    _nameLabel.text = _barrageModel.fromUserName;
    
    _textLabel.text = _barrageModel.content.name;
    
    NSDictionary *dictAttribute = @{NSFontAttributeName:_textLabel.font};
    CGRect rect = [_textLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kBarrageHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictAttribute context:nil];
    CGRect rect1 = [_nameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kBarrageHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictAttribute context:nil];
    if (rect.size.width >= rect1.size.width) {
        self.barrageSize = CGSizeMake(rect.size.width + kBarrageHeight +20, kBarrageHeight);
    }else {
        self.barrageSize = CGSizeMake(rect1.size.width + kBarrageHeight +20, kBarrageHeight);
    }
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.layer.cornerRadius = kBarrageHeight * 0.5;
        _headImageView.layer.borderColor = [UIColor yellowColor].CGColor;
        _headImageView.layer.borderWidth = 1;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:16];
    }
    return _textLabel;
}

@end
