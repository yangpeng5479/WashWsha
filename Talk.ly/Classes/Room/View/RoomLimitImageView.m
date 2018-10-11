//
//  RoomLimitImageView.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/15.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomLimitImageView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <POP.h>

@implementation RoomLimitImageView

//type 1:主持人 2上麦 3普通用户
- (instancetype)initWithFrame:(CGRect)frame Type:(int)type Speaker:(BOOL)isSpeaker Mute:(BOOL)isMute{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI:type speaker:isSpeaker Mute:isMute];
    }
    return self;
}

- (void)setupUI:(int)type speaker:(BOOL)isSpeaker Mute:(BOOL)isMute{
    
    self.image = [UIImage imageNamed:@"Pop-ups-bg"];
    self.userInteractionEnabled = YES;
    
    NSArray *imageArr = [NSArray array];
    NSArray *titleArr = [NSArray array];
    if (type == 1) {

        if (isSpeaker == YES && isMute == YES) {
            imageArr = @[@"button-Authority",@"button-Roomsettings",@"button-hands-freeno",@"button-onwheat"];
            titleArr = @[@"Enter the limit",@"Room setting",@"Hands-Free:Yes",@"Mute:ON"];
        }else if (isSpeaker == YES && isMute == NO) {
            imageArr = @[@"button-Authority",@"button-Roomsettings",@"button-hands-freeno",@"button-microphone"];
            titleArr = @[@"Enter the limit",@"Room setting",@"Hands-Free:Yes",@"Mute:OFF"];
        }else {
            imageArr = @[@"button-Authority",@"button-Roomsettings",@"button-hands-free",@"button-microphone"];
            titleArr = @[@"Enter the limit",@"Room setting",@"Hands-Free:No",@"Mute:OFF"];
        }
    }else if (type == 2){
        if (isSpeaker == YES && isMute == YES) {
            imageArr = @[@"icon-down",@"button-hands-freeno",@"button-onwheat"];
            titleArr = @[@"Leave the position",@"Hands-Free:Yes",@"Mute:ON"];
        }else if (isSpeaker == YES && isMute == NO) {
            imageArr = @[@"icon-down",@"button-hands-freeno",@"button-microphone"];
            titleArr = @[@"Leave the position",@"Hands-Free:Yes",@"Mute:OFF"];
        }else {
            imageArr = @[@"icon-down",@"button-hands-free",@"button-microphone"];
            titleArr = @[@"Leave the position",@"Hands-Free:No",@"Mute:OFF"];
        }
        
    }else {
        if (isSpeaker == YES) {
            imageArr = @[@"icon-up",@"button-hands-freeno"];
            titleArr = @[@"Apply for wheat",@"Hands-Free:Yes"];
        }else {
            imageArr = @[@"icon-up",@"button-hands-free"];
            titleArr = @[@"Apply for wheat",@"Hands-Free:No"];
        }
    }
    
    for (int i = 0; i < imageArr.count; ++i) {
        CGFloat x = i%2;
        CGFloat y = i/2;
        CGFloat w = (kScreenWidth-30)/2;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x*w, y*(175)/2, w, 175/2)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((w-40)/2, 15, 40, 40)];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn.tag = 250+i;
        [view addSubview:btn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 260+i;
        titleLabel.text = titleArr[i];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        [view addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(view.mas_centerX);
            make.top.mas_equalTo(btn.mas_bottom).offset(kCellSpace);
        }];
        
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        ani.fromValue = [NSValue valueWithCGRect:CGRectMake((w-40)/2, 40+i*10, 40, 40)];
        ani.toValue = [NSValue valueWithCGRect:CGRectMake((w-40)/2, 15, 40, 40)];
        ani.springBounciness = 25;
        ani.beginTime = CACurrentMediaTime();
        [ani setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            btn.userInteractionEnabled = YES;
        }];
        [btn pop_addAnimation:ani forKey:nil];
    }
}

@end
