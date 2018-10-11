//
//  ChatTableViewCell.m
//  GameTogether_iOS
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "CommonPrex.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataService.h"

@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self _configureCell];
    }
    
    return self;
}

- (void)_configureCell {
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, kCellSpace, self.height-kSpace, self.width)];
    _view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Chatbg"]];
    _view.layer.cornerRadius = kCellSpace;
    _view.layer.masksToBounds = YES;
    [self.contentView addSubview:_view];
    
    //创建富文本
    _label = [[TYAttributedLabel alloc] initWithFrame:CGRectMake(kSpace, kSpace, kScreenWidth-2*kSpace, 0)];
    _label.characterSpacing = 5;
    _label.linesSpacing = 5;
//    _label.paragraphSpacing = 1;
    _label.backgroundColor = [UIColor clearColor];
    _label.numberOfLines = 0;
//    _label.openShadow = YES;
    [self.contentView addSubview:_label];
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    [self addGestureRecognizer:_longPressGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_label.textContainer.textWidth >= self.width-2*kSpace) {
        [_label setFrameWithOrign:CGPointMake(kSpace, kSpace) Width:self.width-2*kSpace];
        _view.frame = CGRectMake(0, kCellSpace, self.width, _label.textContainer.textHeight+kSpace);
    }else {
     
        [_label setFrameWithOrign:CGPointMake(kSpace, kSpace) Width:_label.textContainer.textWidth];
        _view.frame = CGRectMake(0, kCellSpace, _label.textContainer.textWidth+kSpace, _label.textContainer.textHeight+kSpace);
    }
    
}

- (BOOL)canBecomeFirstResponder {

    return YES;
}
@end
