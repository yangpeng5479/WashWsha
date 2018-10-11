//
//  ActivityCollectionViewCell.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/22.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ActivityCollectionViewCell.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import "DataService.h"

@implementation ActivityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _configureCell];
    }
    return self;
}

- (void)_configureCell {
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.image = [UIImage imageNamed:@"activity"];
    [_coverImageView xw_roundedCornerWithRadius:kCellSpace cornerColor:[UIColor whiteColor]];
    [self.contentView addSubview:_coverImageView];
    
    _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    _tagLabel.font = [UIFont systemFontOfSize:10];
    _tagLabel.textColor = [UIColor whiteColor];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.layer.cornerRadius = 2;
    _tagLabel.layer.masksToBounds = YES;
    _tagLabel.backgroundColor = kNavColor;
    [self.contentView addSubview:_tagLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.font = [UIFont systemFontOfSize:16];
    _moneyLabel.textColor = [UIColor whiteColor];
    _moneyLabel.text = @"$ 3000 Prize";
    [_moneyLabel sizeToFit];
    _moneyLabel.shadowColor = k51Color;
    _moneyLabel.shadowOffset = CGSizeMake(1, 1);
    [self.contentView addSubview:_moneyLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:16];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.text = @"2018-8-1 GMT+8";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.shadowColor = k51Color;
    _timeLabel.shadowOffset = CGSizeMake(1, 1);
    _timeLabel.numberOfLines = 2;
    [self.contentView addSubview:_timeLabel];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-2*kSpace);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView.mas_left).offset(kSpace);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kSpace);
        make.bottom.mas_equalTo(_moneyLabel.mas_top).offset(-kSpace);
        make.height.offset(4*kSpace);
    }];
}

- (void)setModel:(ActivityModel *)model {
    _model = model;
    
    _moneyLabel.text = [NSString stringWithFormat:@"$ %ld Prize",_model.jackpot];
    _tagLabel.text = @"Real Cash";
    _tagLabel.backgroundColor = [UIColor colorWithRed:247/255.0 green:107/255.0 blue:28/255.0 alpha:0.8];
    _coverImageView.image = [UIImage imageNamed:@"activity"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *cdate = [formatter dateFromString:_model.curr_time];
    NSTimeInterval interval = [[NSTimeZone systemTimeZone] secondsFromGMT];
    cdate = [cdate dateByAddingTimeInterval:interval];
    NSString *current = [formatter stringFromDate:cdate];
    
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSArray *zoneArray = [[NSString stringWithFormat:@"%@", localTimeZone] componentsSeparatedByString:@"("];
    NSString *tempTZ = [NSString stringWithFormat:@"%@", zoneArray.lastObject];
    NSArray *arr = [[NSString stringWithFormat:@"%@", tempTZ] componentsSeparatedByString:@")"];
    NSString *gmt = [NSString stringWithFormat:@"%@",arr.firstObject];
    
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",current,gmt];
}
@end
