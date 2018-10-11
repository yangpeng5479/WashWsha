//
//  InroomTopView.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MarqueeLabel.h>

@interface InroomTopView : UIView

@property(nonatomic,strong)MarqueeLabel *nameLabel;
@property(nonatomic,strong)UIButton *followBtn;
@property(nonatomic,strong)UICollectionView *onlineCollectionview;
@property(nonatomic,strong)UIButton *moreBtn;
@property(nonatomic,strong)UILabel *onlineLabel;
@property(nonatomic,strong)UILabel *likeLabel;
@property(nonatomic,strong)UIButton *reportRoomBtn;
@end
