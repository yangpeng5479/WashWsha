//
//  RoomLimitImageView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/15.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomLimitImageView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame Type:(int)type Speaker:(BOOL)isSpeaker Mute:(BOOL)isMute;
@end
