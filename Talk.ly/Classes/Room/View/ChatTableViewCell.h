//
//  ChatTableViewCell.h
//  GameTogether_iOS
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYAttributedLabel/TYAttributedLabel.h>

@interface ChatTableViewCell : UITableViewCell

@property(nonatomic,strong)TYAttributedLabel *label;
@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGesture;
@property(nonatomic,strong)UIView *view;

@end
