//
//  ChatTableView.m
//  GameTogether_iOS
//
//  Created by Mac on 16/5/24.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "ChatTableView.h"
#import "MessageModel.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AccountManager.h"
#import "GiftModel.h"
#import "WYFileManager.h"

static NSString *cellStr = @"chatCell";

@implementation ChatTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

- (void)setMessageMarr:(NSMutableArray *)messageMarr {
    
    _messageMarr = messageMarr;
    
    if (!_textContainers) {
        _textContainers = [NSMutableArray array];
    }
    for (NSInteger i = _textContainers.count; i < _messageMarr.count; i++) {
        
        MessageModel *model = _messageMarr[i];
        TYTextContainer *textCon = [self _createTextContrainerWith:model];
        
        [_textContainers addObject:textCon];
    }
}

- (TYTextContainer *)_createTextContrainerWith:(MessageModel *)model {
    
    TYTextContainer *textContainer = [[TYTextContainer alloc] init];
    textContainer.characterSpacing = 0;
    textContainer.linesSpacing = 1;
    textContainer.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
    UILabel *label = nil;
    NSString *text = @"";
    UserModel *mineUserModel = [WYFileManager getCustomObjectWithKey:@"userModel"];
    switch (model.category) {
        case 1:
        {
            text = [NSString stringWithFormat:@"  %@: %@",model.fromUserName,model.content.name];
            
            textContainer.text = text;
            
            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
            textStorage.range = [text rangeOfString:[NSString stringWithFormat:@"%@:",model.fromUserName]];
            if ([model.content.gender isEqualToString:@"female"]) {
                textStorage.textColor = [UIColor colorWithRed:255/255.0 green:168/255.0 blue:164/255.0 alpha:1.0];
            }else {
                textStorage.textColor = [UIColor colorWithRed:71/255.0 green:188/255.0 blue:226/255.0 alpha:1.0];
            }
            textStorage.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
            [textContainer addTextStorage:textStorage];
            
            textStorage = [[TYTextStorage alloc]init];
            textStorage.range = NSMakeRange(text.length-model.content.name.length,model.content.name.length);
            if ([model.content.name containsString:[NSString stringWithFormat:@"@%@",mineUserModel.name]]) {
                textStorage.textColor = [UIColor colorWithRed:84/255.0 green:246/255.0 blue:249/255.0 alpha:1];
            }else {
                textStorage.textColor = [UIColor whiteColor];
            }
            textStorage.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
            [textContainer addTextStorage:textStorage];
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 50, 20)];
            label.backgroundColor = kNavColor;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor whiteColor];
            label.attributedText = [DataService createAttributedStringWithImageName:@"star" bounds:CGRectMake(5, 0, 10, 10) str:[NSString stringWithFormat:@" %ld",model.content.num]];
            label.layer.cornerRadius = kCellSpace;
            label.layer.masksToBounds = YES;
            [label sizeToFit];
            [textContainer addView:label range:NSMakeRange(0, 1)];
        }
            break;
        case 3:
        {
            for (GiftModel *giftmodel in [AccountManager sharedAccountManager].giftModelMarr) {
                if ([giftmodel.gift_key isEqualToString:model.content.name]) {
                    text = [NSString stringWithFormat:@"%@ Give one %@ to %@",model.fromUserName,giftmodel.gift_name,model.content.toUserName];
                }
            }
            textContainer.text = text;
            TYTextStorage *textStorage = [[TYTextStorage alloc]init];
            textStorage.range = NSMakeRange(0,text.length);
            textStorage.textColor = [UIColor colorWithRed:253/255.0 green:194/255.0 blue:53/255.0 alpha:1];
            textStorage.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
            [textContainer addTextStorage:textStorage];
        }
            break;
            
        default:
            break;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:15] forKey:NSFontAttributeName];
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (size.width+label.width >= self.width-2*kSpace) {
        textContainer = [textContainer createTextContainerWithTextWidth:self.width-2*kSpace];
    }else {
     
        textContainer = [textContainer createTextContainerWithTextWidth:size.width+label.width+2*kSpace];
    }
    
    return textContainer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _textContainers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.label.textContainer = _textContainers[indexPath.row];
    cell.label.isWidthToFit = YES;
    
    MessageModel *model = _messageMarr[indexPath.row];
    if (model.category == 1) {
        [cell.longPressGesture addTarget:self action:@selector(sendNotification:)];
        
    }else {
        [cell.longPressGesture removeTarget:self action:@selector(sendNotification:)];
    }
    
    return cell;
}

- (void)sendNotification:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        ChatTableViewCell *cell = (ChatTableViewCell *)sender.view;
        NSIndexPath *indexPath = [self indexPathForCell:cell];
        MessageModel *model = _messageMarr[indexPath.row];
        NSDictionary *dic = @{@"index":indexPath,@"model":model};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"longPress" object:nil userInfo:dic];
    }
}




@end
