//
//  ExploreTableview.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>


@interface ExploreTableview : UITableView <UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *signatureLabel;
@property(nonatomic,strong)UILabel *themLabel;
@property(nonatomic,strong)UIButton *myroomButton;
@property(nonatomic,strong)UIView *activityView;
@property(nonatomic,strong)UIControl *activityControl;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,assign)BOOL isActivity;

- (UIView *)activityView;

@end
