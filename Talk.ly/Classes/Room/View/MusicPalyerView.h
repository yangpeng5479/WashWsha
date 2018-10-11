//
//  MusicPalyerView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/26.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPalyerView : UIView

@property (nonatomic, strong) UIButton *preSongButtton; //上一曲
@property (nonatomic, strong) UIButton *nextSongButton; //下一曲
@property (nonatomic, strong) UIButton *playOrPauseButton; //播放暂停
@property (nonatomic, strong) UISlider *songSlider;           //进度条
@property (nonatomic, strong) UILabel *currentTimeLabel;    //当前时间
@property (nonatomic, strong) UILabel *durationTimeLabel;   //整首歌时间

@end
