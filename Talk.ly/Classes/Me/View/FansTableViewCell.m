//
//  FansTableViewCell.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/6/30.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "FansTableViewCell.h"

@implementation FansTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.unFollowBtn setTitle:@"+ Follow" forState:UIControlStateNormal];
    }
    
    return self;
}

@end
