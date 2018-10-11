//
//  MusicPalyerView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/26.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "MusicPalyerView.h"
#import "CommonPrex.h"
#import <Masonry.h>

@implementation MusicPalyerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    //进度条
    _songSlider = [[UISlider alloc] init];
    [_songSlider setThumbImage:[UIImage imageNamed:@"progressbar"] forState:UIControlStateNormal];
    _songSlider.tintColor = kNavColor;
    [self addSubview:_songSlider];
    
    // 当前播放时间
    _currentTimeLabel = [[UILabel alloc] init];
    _currentTimeLabel.textColor = k51Color;
    _currentTimeLabel.text = @"00:00";
    _currentTimeLabel.font = [UIFont systemFontOfSize:15];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_currentTimeLabel sizeToFit];
    [self addSubview:_currentTimeLabel];
    
    // 整歌时间
    _durationTimeLabel = [[UILabel alloc] init];
    _durationTimeLabel.textColor = k51Color;
    _durationTimeLabel.text = @"00:00";
    _durationTimeLabel.font = [UIFont systemFontOfSize:15];
    _durationTimeLabel.textAlignment = NSTextAlignmentCenter;
    [_durationTimeLabel sizeToFit];
    [self addSubview:_durationTimeLabel];
    
    // 上一曲按键设置
    _preSongButtton = [[UIButton alloc] init];
    [_preSongButtton setImage:[UIImage imageNamed:@"icon-previouspiece"] forState:UIControlStateNormal];
    [self addSubview:_preSongButtton];
    
    // 播放或暂停按键设置
    _playOrPauseButton = [[UIButton alloc] init];
    [_playOrPauseButton setImage:[UIImage imageNamed:@"icon-timeout"] forState:UIControlStateNormal];
    [self addSubview:_playOrPauseButton];
    
    // 下一曲按键设置
    _nextSongButton = [[UIButton alloc] init];
    [_nextSongButton setImage:[UIImage imageNamed:@"icon-nexttrack"] forState:UIControlStateNormal];
    [self addSubview:_nextSongButton];
    
    [_songSlider mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.top.mas_equalTo(self.mas_top).offset(kCellSpace);
        make.height.offset(kSpace);
    }];
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_songSlider.mas_left);
        make.top.mas_equalTo(_songSlider.mas_bottom).offset(kCellSpace);
    }];
    [_durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_songSlider.mas_right);
        make.top.mas_equalTo(_songSlider.mas_bottom).offset(kCellSpace);
    }];
    [_playOrPauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_songSlider.mas_bottom).offset(35);
        make.width.height.equalTo(@50);
    }];
    [_preSongButtton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(_playOrPauseButton.mas_left).offset(-75);
        make.centerY.mas_equalTo(_playOrPauseButton.mas_centerY);
        make.width.offset(35);
        make.height.offset(25);
    }];
    [_nextSongButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_playOrPauseButton.mas_right).offset(75);
        make.centerY.mas_equalTo(_playOrPauseButton.mas_centerY);
        make.width.offset(35);
        make.height.offset(25);
    }];
    
}

@end
