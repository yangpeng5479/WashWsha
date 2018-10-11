//
//  ContributeTopView.m
//  GameTogether_iOS
//
//  Created by Mac on 16/5/9.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "ContributeTopView.h"
#import "CommonPrex.h"
#import <UIImageView+WebCache.h>

@implementation ContributeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        [self _setUpContributeView];
    }
    
    return self;
}

- (void)_setUpContributeView {

    CGFloat w = 40;
    CGFloat h = w;
    
    for (int i = 0; i < 3; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*(w+kSpace), (self.height-h)/2-5, w, h)];
        imageV.tag = 3550+i;
        imageV.layer.cornerRadius = w/2;
        imageV.layer.masksToBounds = YES;
        imageV.userInteractionEnabled = YES;
        [self addSubview:imageV];
    }
}

- (void)setContributeArr:(NSArray *)contributeArr {
    _contributeArr = [contributeArr copy];
    
    for (int i = 0; i < _contributeArr.count; i++) {
        UserModel *model = _contributeArr[i];
        UIImageView *imageV = (UIImageView *)[self viewWithTag:3550+i];
        [imageV sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    }
}

@end
