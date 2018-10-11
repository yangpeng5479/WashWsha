//
//  OpenRoomView.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "OpenRoomView.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <POP.h>

@implementation OpenRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.backgroundColor = [UIColor whiteColor];
    NSArray *imageArr = [NSArray arrayWithObjects:@"icon-openlive",@"icon-openradio", nil];
    NSArray *titleArr = [NSArray arrayWithObjects:@"Live",@"Radio", nil];
    
    CGFloat w = 50;
    CGFloat x = (kScreenWidth/2 - 50)/2;
    
    for (int i = 0; i < imageArr.count; ++i) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x+i*(kScreenWidth/2), 2*kSpace, w, 150/2)];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn.tag = 350+i;
        [view addSubview:btn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 360+i;
        titleLabel.text = titleArr[i];
        titleLabel.textColor = k153Color;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        [view addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(view.mas_centerX);
            make.top.mas_equalTo(btn.mas_bottom).offset(kCellSpace);
        }];
        
        POPSpringAnimation *ani = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        ani.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 50+i*10, 50, 50)];
        ani.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
        ani.springBounciness = 25;
        ani.beginTime = CACurrentMediaTime();
        [ani setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            btn.userInteractionEnabled = YES;
        }];
        [btn pop_addAnimation:ani forKey:nil];
    }
    
    //关闭
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"icon-Close-Keycolor"] forState:UIControlStateNormal];
    closeBtn.tag = 370;
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-2*kSpace);
        make.width.height.equalTo(@30);
    }];
   
}

@end
