//
//  LiveRoomViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/8.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LiveRoomViewController.h"
#import "AccountManager.h"
#import "DataService.h"
#import "CommonPrex.h"
#import "StartLiveView.h"
#import "LiveView.h"
#import "OnlineCollectionViewCell.h"
#import "LLSwitch.h"
#import "ChatRoomModel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <MJExtension.h>
#import "WYFileManager.h"
#import <UIImageView+WebCache.h>
#import "NSDictionary+Jsonstring.h"
#import "MessageModel.h"
#import "ChatTableView.h"
#import "UserListTableView.h"
#import <RegexKitLite.h>
#import "GiftModel.h"
#import <SVGA.h>
#import "LiveGiftShowModel.h"
#import "LiveGiftShowCustom.h"
#import "LiveBarrageCell.h"
#import <ZBLiveBarrage.h>
#import "LiveProfileView.h"
#import "ProfileViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "GoldViewController.h"
#import "RewardRankViewController.h"


@interface LiveRoomViewController ()<ZegoLivePublisherDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,LLSwitchDelegate,UITableViewDelegate,ZegoIMDelegate,SVGAPlayerDelegate,LiveGiftShowCustomDelegate,ZBLiveBarrageDelegate,ZegoRoomDelegate>

@property(nonatomic,strong)UIView *preview;
@property(nonatomic,strong)StartLiveView *bgView;
@property(nonatomic,strong)LiveView *liveView;
@property(nonatomic,strong)UITapGestureRecognizer *tap;
@property(nonatomic,strong)NSMutableArray *onlineUserArr;
@property(nonatomic,strong)UIView *chatInputView;
@property(nonatomic,strong)UITextField *inputTF;
@property(nonatomic,strong)UITapGestureRecognizer *hideKeyboardControl;
@property(nonatomic,strong)NSMutableArray *commonMsgMarr;
@property(nonatomic,strong)ChatTableView *chatView;
@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong)UserListTableView *userListTableview;
@property(nonatomic,strong)NSTimer *forbiddenScrollTimer;
@property(nonatomic,assign)BOOL chatViewIsForbiddenScroll;
@property(nonatomic,copy)NSString *atNameString;
@property(nonatomic,assign)NSRange atNameRange;
@property(nonatomic,strong)NSMutableArray *giftAnimateMarr;
@property(nonatomic,weak) LiveGiftShowCustom * customGiftShow;
@property(nonatomic,strong)SVGAParser *parser;
@property(nonatomic,strong)SVGAPlayer *animatePlayer;
@property(nonatomic,strong)UILabel *giftLabel;
@property(nonatomic,strong)UIImageView *giftBG;
@property(nonatomic,strong)ChatRoomModel *chatroomModel;
@property(nonatomic,strong)UIView *userListBgView;
@property(nonatomic,strong)UIControl *removeUserlistviewControl;
@property(nonatomic,strong)NSTimer *heartTimer;
@property(nonatomic,strong)NSTimer *roomRealtimeInfomationTimer;
@property(nonatomic,assign)BOOL isBarrage;
@property(nonatomic,strong)ZBLiveBarrage *barrageView;
@property(nonatomic,strong)LiveProfileView *profieView;
@property(nonatomic,strong)UIControl *profileControl;

@end

@implementation LiveRoomViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataService changeReturnButton:self];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardAction) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longPress:) name:@"longPress" object:nil];
    
    _commonMsgMarr = [NSMutableArray array];
    _onlineUserArr = [NSMutableArray array];
    _giftAnimateMarr = [NSMutableArray array];
    
    [[AccountManager sharedAccountManager].zegoApi setPublisherDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi enableBeautifying:ZEGO_BEAUTIFY_POLISH | ZEGO_BEAUTIFY_WHITEN];
//    [[AccountManager sharedAccountManager].zegoApi setFilter:ZEGO_FILTER_LOMO];
    [[AccountManager sharedAccountManager].zegoApi enableRateControl:YES];
    [[AccountManager sharedAccountManager].zegoApi setFrontCam:YES];
    [[AccountManager sharedAccountManager].zegoApi enableMic:YES];
    [[AccountManager sharedAccountManager].zegoApi setPreviewView:self.preview];
    [[AccountManager sharedAccountManager].zegoApi setPreviewViewMode:ZegoVideoViewModeScaleAspectFill];
    [[AccountManager sharedAccountManager].zegoApi startPreview];
    [[AccountManager sharedAccountManager].zegoApi setIMDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setRoomDelegate:self];
    
    ZegoAVConfig *config = [ZegoAVConfig presetConfigOf:ZegoAVConfigPreset_Generic];
    config.fps = ZegoAVConfigVideoFps_High;
    config.bitrate = ZegoAVConfigVideoBitrate_Generic;
    [[AccountManager sharedAccountManager].zegoApi setAVConfig:config];
    
    [ZegoLiveRoomApi requireHardwareEncoder:YES];
}

#pragma mark - 数据
//聊天室实时信息
- (void)roomRealtimeInfomationData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatroomModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/getChatroomRtInfo" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSLog(@"roomRealtimeInfomationData:%@",data);
            NSDictionary *dic = data[@"data"];

            NSMutableArray *listenersArr = [UserModel mj_objectArrayWithKeyValuesArray:dic[@"listeners"]];

            self.chatroomModel.listeners = listenersArr;

            //在线人数
            [_onlineUserArr removeAllObjects];
            [_onlineUserArr addObjectsFromArray:listenersArr];
            _userListTableview.userListArr = _onlineUserArr.copy;
            [_userListTableview reloadData];
            
            for (NSInteger i = 0; i < _onlineUserArr.count; i++) {
                for (NSInteger j = i+1;j < _onlineUserArr.count; j++) {
                    UserModel *tempModel = _onlineUserArr[i];
                    UserModel *model = _onlineUserArr[j];
                    if ([tempModel.user_id isEqualToString:model.user_id]) {
                        [_onlineUserArr removeObject:model];
                    }
                }
            }
            [_liveView.onlineCV reloadData];
            
            if (_onlineUserArr.count <= 0) {
                _liveView.onlineBtn.hidden = YES;
            }else if (_onlineUserArr.count < 1000 && _onlineUserArr.count > 0) {
                _liveView.onlineBtn.hidden = NO;
                [_liveView.onlineBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_onlineUserArr.count] forState:UIControlStateNormal];
            }else {
                _liveView.onlineBtn.hidden = NO;
                [_liveView.onlineBtn setTitle:[NSString stringWithFormat:@"%.1luk",_onlineUserArr.count/1000] forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//心跳
- (void)heartBeatData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatroomModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/heartbeat" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"heartBeatData:%@",data);
        if ([data[@"status"] integerValue] == 1) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)openRoomData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    [AccountManager sharedAccountManager].locationDic = [WYFileManager getCustomObjectWithKey:@"location"];
    if ([AccountManager sharedAccountManager].locationDic == nil) {
        [AccountManager sharedAccountManager].locationDic = @{@"city":@"Unknow",@"latitude":@"",@"longitude":@""};
    }
    NSString *city = [AccountManager sharedAccountManager].locationDic[@"city"];
    
    NSDictionary *dic = [NSDictionary dictionary];
    if ([_bgView.decTF.text isEqualToString:@""]) {
        dic = @{@"token":[AccountManager sharedAccountManager].token,@"type":@"live",@"city":city,@"room_name":_bgView.titleTF.text};
    }else {
        dic = @{@"token":[AccountManager sharedAccountManager].token,@"type":@"live",@"city":city,@"room_name":_bgView.titleTF.text,@"room_desc":_bgView.decTF.text};
    }
    
    [DataService postWithURL:@"rest3/v1/Livechatroom/openChatroom" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"openRoomData:%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            
            NSDictionary *diction = data[@"data"];
            _chatroomModel = [ChatRoomModel mj_objectWithKeyValues:diction];
            [self creatRoomContentView:_chatroomModel];
            
            //心跳`
            [self heartBeatData];
            _heartTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(heartBeatData) userInfo:nil repeats:YES];
            
            //房间实时信息
            [self roomRealtimeInfomationData];
            _roomRealtimeInfomationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(roomRealtimeInfomationData) userInfo:nil repeats:YES];
            
            //保存房间信息
            NSMutableDictionary *roomDic = [NSMutableDictionary dictionary];
            [roomDic setValue:_chatroomModel.chatroom.room_name forKey:@"roomName"];
            [roomDic setValue:_chatroomModel.chatroom.room_desc forKey:@"roomDesc"];
            
            if (_chatroomModel.chatroom.topic[@"name"] != nil) {
                [roomDic setValue:_chatroomModel.chatroom.topic[@"name"] forKey:@"topic"];
            }else {
                [roomDic setValue:@"" forKey:@"topic"];
            }
            [WYFileManager setCustomObject:roomDic forKey:@"roomInfo"];
            
        }else {
            [DataService toastWithMessage:@"Error"];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Error"];
    }];
}

//获取他人信息
- (void)getUserInfoData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic =@{@"token":[AccountManager sharedAccountManager].token,@"host_user_id":_userModel.user_id};
    [DataService postWithURL:@"rest3/v1/user/get_host_user_info" type:1 params:dic fileData:nil success:^(id data) {
        
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *userDic = data[@"data"];
            _userModel = [UserModel mj_objectWithKeyValues:userDic];
            [UIView animateWithDuration:.35 animations:^{
                
                [self creatProfileView:_userModel].top = (kScreenHeight-350)/2;
            }];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

//获取个人详情
- (void)loadMeData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic =@{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/user/get_my_info" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"ME:%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"user_info"];
            _userModel = [UserModel mj_objectWithKeyValues:diction];
            [WYFileManager setCustomObject:_userModel forKey:@"userModel"];
            [UIView animateWithDuration:.35 animations:^{
                
                [self creatProfileView:_userModel].top = (kScreenHeight-350)/2;
            }];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark - 懒加载
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_preview];
        [self.view addSubview:self.bgView];
    }
    return _preview;
}
- (StartLiveView *)bgView {
    if (!_bgView) {
        
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView = [[StartLiveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgView.titleTF.delegate = self;
        _bgView.decTF.delegate = self;
        [_bgView.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgView.beautyBtn addTarget:self action:@selector(beautyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView.startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}

- (LiveView *)liveView {
    if (!_liveView) {
        
        _liveView = [[LiveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        if (IS_IPHONE_X) {
            _liveView.frame = CGRectMake(0, kSpace, kScreenWidth, kScreenHeight-2*kSpace);
        }
        _liveView.iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoAction)];
        [_liveView.iconView addGestureRecognizer:iconTap];
        
        _liveView.incomeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *incomeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userRankAction)];
        [_liveView.incomeView addGestureRecognizer:incomeTap];
        
        _liveView.onlineCV.delegate = self;
        _liveView.onlineCV.dataSource = self;
        [_liveView.onlineCV registerClass:[OnlineCollectionViewCell class] forCellWithReuseIdentifier:@"online"];
        [_liveView.followBtn removeFromSuperview];
        _liveView.followBtn = nil;
        
        [_liveView.onlineBtn addTarget:self action:@selector(onlineBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_liveView.messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_liveView.giftBtn removeFromSuperview];
        _liveView.giftBtn = nil;
        [_liveView.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_liveView.closeBtn addTarget:self action:@selector(closeLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveView;
}

//礼物弹幕
- (LiveGiftShowCustom *)customGiftShow{
    if (!_customGiftShow) {
        _customGiftShow = [LiveGiftShowCustom addToView:self.view];
        _customGiftShow.addMode = LiveGiftAddModeAdd;
        [_customGiftShow setMaxGiftCount:3];
        [_customGiftShow setShowMode:LiveGiftShowModeFromTopToBottom];
        [_customGiftShow setAppearModel:LiveGiftAppearModeLeft];
        [_customGiftShow setHiddenModel:LiveGiftHiddenModeLeft];
        [_customGiftShow enableInterfaceDebug:YES];
        _customGiftShow.delegate = self;
    }
    return _customGiftShow;
}

- (ZBLiveBarrage *)barrageView {
    if (!_barrageView) {
        _barrageView = [[ZBLiveBarrage alloc] init];
        _barrageView.backgroundColor = [UIColor clearColor];
        _barrageView.delegate = self;
    }
    return _barrageView;
}

//欢迎视图
- (void)creatWelcomeRoomView:(NSString *)name {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"CourierNewPS-BoldItalicMT" size:15];
    label.text = [NSString stringWithFormat:@"%@ enterde the room",name];
    [label sizeToFit];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth, _chatView.top, label.width+3*kSpace, 20)];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"entertheroom-bg"]];
    [self.view addSubview:view];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(kSpace);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    
    [UIView animateWithDuration:.35 animations:^{
        view.left = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            view.right = 0;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
}

//用户列表
- (UIView *)userListBgView {
    if (!_userListBgView) {
        
        _userListBgView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenHeight, kScreenWidth-60, kScreenHeight-150)];
        _userListBgView.backgroundColor = [UIColor whiteColor];
        _userListBgView.layer.cornerRadius = kCellSpace;
        _userListBgView.layer.masksToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _userListBgView.width, 40)];
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = k51Color;
        label.text = @"Online Users";
        label.textAlignment = NSTextAlignmentCenter;
        [_userListBgView addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_userListBgView.width-40, 0, 40, 40)];
        [btn setImage:[UIImage imageNamed:@"icon-close1"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeUserListView) forControlEvents:UIControlEventTouchUpInside];
        [_userListBgView addSubview:btn];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, _userListBgView.width, 0.5)];
        lineLabel.backgroundColor = kLineColor;
        [_userListBgView addSubview:lineLabel];
        
        _userListTableview = [[UserListTableView alloc] initWithFrame:CGRectMake(0, 40.5, _userListBgView.width, kScreenHeight-150-40) style:UITableViewStylePlain];
        _userListTableview.delegate = self;
        [_userListBgView addSubview:_userListTableview];
    }
    return _userListBgView;
}

- (LiveProfileView *)creatProfileView:(UserModel *)model {
    if (!_profieView) {
        
        _profileControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _profileControl.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_profileControl];
        [_profileControl addTarget:self action:@selector(removeProfileAction) forControlEvents:UIControlEventTouchUpInside];
        
         _profieView = [[LiveProfileView alloc] initWithFrame:CGRectMake(2*kSpace, kScreenHeight, kScreenWidth-4*kSpace, 350) withUserModel:model];
        [self.view addSubview:_profieView];
        [_profieView.rightBtn addTarget:self action:@selector(managerAction) forControlEvents:UIControlEventTouchUpInside];
        
        for (int i = 0; i < 3; ++i) {
            UIButton *btn = (UIButton *)[_profieView viewWithTag:510+i];
            [btn addTarget:self action:@selector(profileBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _profieView;
}

#pragma mark - 点击事件
- (void)closeBtnAction {
    [_bgView removeFromSuperview];
    _bgView = nil;
    [[AccountManager sharedAccountManager].zegoApi setPreviewView:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//美颜开关
- (void)beautyBtnAction:(UIButton *)sender {
    if (sender.selected == YES) {
        [[AccountManager sharedAccountManager].zegoApi enableBeautifying:ZEGO_BEAUTIFY_NONE];
        sender.selected = NO;
    }else {
        [[AccountManager sharedAccountManager].zegoApi enableBeautifying:ZEGO_BEAUTIFY_POLISH | ZEGO_BEAUTIFY_WHITEN];
        sender.selected = YES;
    }
}

//开始直播
- (void)startBtnAction {
    if ([_bgView.titleTF.text isEqualToString:@""]) {
        [DataService toastWithMsg:@"Please enter live's title"];
        return;
    }
    [self openRoomData];
}
//开启直播间成功后的视图
- (void)creatRoomContentView:(ChatRoomModel *)model {
    [_bgView removeFromSuperview];
    _bgView = nil;
    [self.view addSubview:self.liveView];
    
    [[AccountManager sharedAccountManager].zegoApi loginRoom:model.chatroom.chatroom_id roomName:self.chatroomModel.chatroom.room_name role:ZEGO_ANCHOR withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
        
        if (errorCode == 0) {
            [[AccountManager sharedAccountManager].zegoApi stopPublishing];
            [[AccountManager sharedAccountManager].zegoApi startPublishing:model.chatroom.chatroom_id title:model.chatroom.room_name flag:ZEGO_SINGLE_ANCHOR];
        }else {
            [DataService toastWithMessage:@"Login room error"];
        }
    }];
    
    _chatView = [[ChatTableView alloc] initWithFrame:CGRectMake(kSpace,kScreenHeight-70-200, kScreenWidth-kSpace- 75 - kSpace, 200) style:UITableViewStylePlain];
    _chatView.delegate = self;
    [_liveView addSubview:_chatView];
    
    [_liveView addSubview:self.barrageView];
    [_barrageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_chatView.mas_top).offset(-30);
        make.height.mas_equalTo(100);
    }];
    [_barrageView start];
    
    [_liveView.iconView sd_setImageWithURL:[NSURL URLWithString:model.chatroom.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _liveView.nameeLabel.text = model.chatroom.creator_user_info.name;
    _liveView.idLabel.text = [NSString stringWithFormat:@"@%@",model.chatroom.creator_user_info.user_id];
    _liveView.incomeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigdiamond" bounds:CGRectMake(0, -2, 10, 9) str:[NSString stringWithFormat:@" %@",model.chatroom.creator_user_info.income]];
    
    //创建聊天输入视图
    CGFloat inputHeight = 50;
    _chatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, inputHeight)];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, inputHeight)];
    bgview.backgroundColor = [UIColor whiteColor];
    [_chatInputView addSubview:bgview];
    
    LLSwitch *barrageSwitcher = [[LLSwitch alloc] initWithFrame:CGRectMake(10, 10, 60, 30)];
    barrageSwitcher.animationDuration = 0.7;
    barrageSwitcher.onColor = kBlueColor;
    barrageSwitcher.offColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    barrageSwitcher.delegate = self;
    [barrageSwitcher setOn:NO animated:YES];
    [bgview addSubview:barrageSwitcher];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(barrageSwitcher.right+10, 17.5, 0.5,15)];
    lineLabel1.backgroundColor = kLineColor;
    [bgview addSubview:lineLabel1];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(kScreenWidth-68, 0, 68, inputHeight);
    [sendBtn setTitleColor:kNavColor forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [sendBtn setTitle:@"send" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:sendBtn];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 17.5, 0.5, 15)];
    lineLabel2.backgroundColor = kLineColor;
    [bgview addSubview:lineLabel2];
    
    _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(lineLabel1.right+kCellSpace, 0, lineLabel2.left-lineLabel1.right-kSpace, inputHeight)];
    _inputTF.placeholder = @"说点什么吧";
    _inputTF.font = [UIFont systemFontOfSize:16];
    _inputTF.delegate = self;
    [bgview addSubview:_inputTF];
    
    [_liveView addSubview:_chatInputView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [_liveView.incomeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_liveView.iconView.mas_left);
        make.top.mas_equalTo(_liveView.iconView.mas_bottom).offset(kCellSpace);
        make.height.offset(16);
        make.width.offset(_liveView.incomeLabel.width + kSpace);
    }];
    
}

//手势
- (void)tapAction {
    
    [_bgView.decTF resignFirstResponder];
    [_bgView.titleTF resignFirstResponder];
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

//主播资料
- (void)userInfoAction {
    
    _userModel = self.chatroomModel.chatroom.creator_user_info;
    [self loadMeData];
}

//排行榜
- (void)userRankAction {
    
    RewardRankViewController *vc = [[RewardRankViewController alloc] init];
    vc.userid = [AccountManager sharedAccountManager].userID;
    [self.navigationController pushViewController:vc animated:YES];
}

//在线用户
- (void)onlineBtnAction {
    _removeUserlistviewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_removeUserlistviewControl addTarget:self action:@selector(removeUsertlistViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeUserlistviewControl];
    
    [self.view addSubview:self.userListBgView];
    _userListTableview.userListArr = _onlineUserArr.copy;
    [_userListTableview reloadData];
    [UIView animateWithDuration:.35 animations:^{
        _userListBgView.top = 100;
    }];
}
//弹出键盘
- (void)messageBtnAction {
    
    [_inputTF becomeFirstResponder];
}

//键盘弹出
- (void)showKeyboardAction:(NSNotification *)noti {
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat inputHeight = rect.size.height+50;
    
    [UIView animateWithDuration:.35 animations:^{
        _chatInputView.transform = CGAffineTransformMakeTranslation(0, -inputHeight);
        _liveView.bottomView.transform = CGAffineTransformMakeTranslation(0, 55);
    }];
    
    if (_hideKeyboardControl) {
        return;
    }
    
    _hideKeyboardControl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardAction)];
    [self.view addGestureRecognizer:_hideKeyboardControl];
}

//收回键盘
- (void)hideKeyboardAction {
    
    [_inputTF resignFirstResponder];
    _inputTF.text = @"";
    
    [self.view removeGestureRecognizer:_hideKeyboardControl];
    _hideKeyboardControl = nil;

    [UIView animateWithDuration:.3 animations:^{

        _liveView.bottomView.transform = CGAffineTransformIdentity;
        _chatInputView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}

//分享
- (void)shareBtnAction {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupFacebookParamsByText:@"Come and watch the live broadcast" image:nil url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/vcoze/id1392171229?mt=8"] urlTitle:nil urlName:nil attachementUrl:nil type:SSDKContentTypeWebPage];
    [shareParams SSDKEnableUseClientShare];
    [ShareSDK share:SSDKPlatformTypeFacebook parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSLog(@"%lu",(unsigned long)state);
    }];
}

//发消息
- (void)sendMessageAction {
    if ([_inputTF.text isEqualToString:@""]) {
        return;
    }
    if (_isBarrage) {
        
        NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
        [DataService postWithURL:@"rest3/v1/gift/barrage" type:1 params:dic fileData:nil success:^(id data) {
            if ([data[@"status"] isEqual:@1]) {
                [self sendChatMessage:DANMAKU WithGiftKey:nil];
            }else if ([data[@"status"] isEqual:@30008]) {
                UIAlertController *balanceAlert = [UIAlertController alertControllerWithTitle:nil message:@"Your account balance is not enougn, whether to exchange silver coins" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *recharge = [UIAlertAction actionWithTitle:@"Go Exchange" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    GoldViewController *goldVC = [[GoldViewController alloc] init];
                    [self.navigationController pushViewController:goldVC animated:YES];
                }];
                [balanceAlert addAction:cancelAction];
                [balanceAlert addAction:recharge];
                
                [self presentViewController:balanceAlert animated:YES completion:nil];
            }
        } failure:^(NSError *error) {
            [DataService toastWithMessage:error.userInfo.description];
        }];
    }else {
        [self sendChatMessage:CHAT WithGiftKey:nil];
    }
}

//开启关闭弹幕
- (void)valueDidChanged:(LLSwitch *)llSwitch on:(BOOL)on {
    
    if (on) {
        _inputTF.placeholder = @"Open the barrage，1 silver coin";
        _isBarrage = YES;
    }else {
        
        _inputTF.placeholder = @"Say something...";
        _isBarrage = NO;
    }
}

- (void)removeUsertlistViewAction {
    if (_removeUserlistviewControl) {
        [_removeUserlistviewControl removeFromSuperview];
        _removeUserlistviewControl = nil;
    }
    [self closeUserListView];
}
//关闭userlist
- (void)closeUserListView {
    [UIView animateWithDuration:.35 animations:^{
        
        _userListBgView.top = kScreenHeight;
    }];
}

//关闭直播
- (void)closeLiveAction {
    
    UIAlertController *closeAlert = [UIAlertController alertControllerWithTitle:nil message:@"Whether to close the current room" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leave = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self exitRoom];
    }];
    UIAlertAction *stay = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [closeAlert addAction:leave];
    [closeAlert addAction:stay];
    [self presentViewController:closeAlert animated:YES completion:nil];
}

- (void)longPress:(NSNotification *)noti {
    
    MessageModel *model = noti.userInfo[@"model"];
    if ([model.fromUserId isKindOfClass:[NSNull class]] || !model.fromUserId || [[AccountManager sharedAccountManager].userID isEqualToString:model.fromUserId]) {
        return;
    }
    
    [self _atActionWithName:model.fromUserName];
}

//@功能
- (void)_atActionWithName:(NSString *)name {
    
    [self messageBtnAction];
    
    _atNameString = [NSString stringWithFormat:@"@%@\t",name];
    
    if (_inputTF.text.length == 0) {
        _inputTF.text = _atNameString;
    }else {
        
        NSRange tempRange = [_inputTF.text rangeOfRegex:@"@[^@]+\t"];
        if (tempRange.location != NSNotFound && tempRange.location+tempRange.length <= _inputTF.text.length) {
            _inputTF.text = [_inputTF.text stringByReplacingCharactersInRange:tempRange withString:_atNameString];
        }else {
            
            _inputTF.text = [_inputTF.text stringByAppendingString:_atNameString];
            [self _substringOfInputText];
        }
    }
    _atNameRange = [_inputTF.text rangeOfString:_atNameString];
}

- (void)_substringOfInputText {
    
    if ( _inputTF.text.length > 14) {
        _inputTF.text = [_inputTF.text substringToIndex:14];
    }else if ( _inputTF.text.length > 30) {
        _inputTF.text = [_inputTF.text substringToIndex:30];
    }
    
    if (_atNameString) {
        NSRange tempRange = [_inputTF.text rangeOfString:_atNameString];
        if (tempRange.location == NSNotFound) {
            _inputTF = nil;
            _atNameRange = NSMakeRange(0, 0);
        }
    }
}

//举报 拉黑 禁言 踢出房间
- (void)managerAction {

    [self removeProfileAction];
    UIAlertController *alertController = nil;
    if (IS_PAD) {
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    }else {
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *black = [UIAlertAction actionWithTitle:@"Drag into blacklist" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSelector:@selector(blackAction) withObject:nil afterDelay:1.0];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       UIAlertController *blockAlert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"He'cant enter your room anymore,are you sure to ban Him?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *block = [UIAlertAction actionWithTitle:@"Block" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self reportData:_userModel.user_id];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [blockAlert addAction:block];
        [blockAlert addAction:cancel];
        [self presentViewController:blockAlert animated:YES completion:nil];
    }];
    UIAlertAction *kidOut = [UIAlertAction actionWithTitle:@"Kicked Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self kickedOutAction];
    }];
    UIAlertAction *nosay = [UIAlertAction actionWithTitle:@"Ban" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *nosayAlert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"He'cant send any message or bullet screen,are you sure to ban Him?>" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"Ban" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self nosay];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [nosayAlert addAction:no];
        [nosayAlert addAction:cancel];
        [self presentViewController:nosayAlert animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:black];
    [alertController addAction:ok];
    [alertController addAction:kidOut];
    [alertController addAction:nosay];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)reportData:(NSString *)uid {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"warn_user_id":uid};
    [DataService postWithURL:@"rest3/v1/Warn/report" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"We will verify the information and contact you as soon as possible"];
        }else {
            [DataService toastWithMessage:@"Network Error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Network Error"];
    }];
}

- (void)blackAction {
    [self kickedOutAction];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"black_user_id":_userModel.user_id};
    [DataService postWithURL:@"rest3/v1/Blacklist/addBlackUser" type:1 params:dic fileData:nil success:^(id data) {
        [DataService toastWithMessage:@"Oeration success!"];
    } failure:^(NSError *error) {
        
    }];
}

//禁言
- (void)nosay {
    NSDictionary *pram = @{@"user_id":_userModel.user_id,@"chatroom_id":self.chatroomModel.chatroom.chatroom_id,@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Livechatroom/postBan" type:1 params:pram fileData:nil success:^(id data) {
        
        NSDictionary *dic = @{@"name":@"FORBIDDEN",@"num":@"",@"uid":_userModel.user_id};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:FORBIDDEN completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

//踢出房间
- (void)kickedOutAction {
    NSLog(@"踢出房间");
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatroomModel.chatroom.chatroom_id,@"kicked_user_id":_userModel.user_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/kickoutChatroom" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *dic = @{@"name":@"ROOM_KICKEDOUT",@"num":@"",@"uid":_userModel.user_id};
            NSString *jsonStr = [dic dictionaryToJsonString];
            [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:ROOM_KICKEDOUT priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                if (errorCode == 0) {
                    [self roomRealtimeInfomationData];
                    [DataService toastWithMessage:@"We will verify the information and contact you as soon as possible"];
                }
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)profileBtnAction:(UIButton *)sender {
    if (sender.tag == 510) {
        if ([_userModel.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
            ProfileViewController *vc = [[ProfileViewController alloc] init];
            vc.type = 1;
            vc.uid = _userModel.user_id;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        //关注
        if ([sender.titleLabel.text isEqualToString:@"Follow"]) {
            [sender setTitle:@"Followed" forState:UIControlStateNormal];
        }else {
            [sender setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }else if (sender.tag == 511) {
        [self removeProfileAction];
        [self _atActionWithName:_userModel.name];
    }else {
        ProfileViewController *vc = [[ProfileViewController alloc] init];
        vc.type = 2;
        vc.uid = _userModel.user_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)removeProfileAction {
    [UIView animateWithDuration:.35 animations:^{
       
        _profieView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [_profileControl removeFromSuperview];
        _profileControl = nil;
        [_profieView removeFromSuperview];
        _profieView = nil;
    }];
}

#pragma mark 发送消息
- (void)sendChatMessage:(ZegoMessageCategory)type WithGiftKey:(NSString *)giftKey {
    
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    NSDictionary *dic = [NSDictionary dictionary];
    
    if (type == CHAT || type == DANMAKU) {
        dic = @{@"name":_inputTF.text,@"num":model.active_lv,@"gender":model.gender,@"mainHeadImg":model.image};
    }
    
    NSString *jsonStr = [dic dictionaryToJsonString];
    
    NSDictionary *message = @{@"fromUserId":model.user_id,@"fromUserName":model.name,@"messageId":@(14),@"content":jsonStr,@"type":@(1),@"category":@(type)};
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:type priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        
        if (errorCode == 0) {
            if (type == LIKE) {
                return ;
            }
            MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
            if (_isBarrage) {
                
                LiveBarrageCell *barrageCell = [[LiveBarrageCell alloc] init];
                barrageCell.barrageShowDuration = [@[@3,@4,@5,@6][rand()%4] floatValue];
                // 弹道数
                barrageCell.channelCount = 2;
                // 距离上一条弹幕的距离，可固定值
                barrageCell.margin = 10;
                // 给弹幕 模型赋值
                barrageCell.barrageModel = model;
                // 插入跑到
                [_barrageView insertBarrages:@[barrageCell]];
                _inputTF.text = @"";
                
            }else {
                [_commonMsgMarr addObject:model];
                [self refreshCommonChatMsg];
                [self hideKeyboardAction];
            }
        }
    }];
}

- (void)refreshCommonChatMsg {
    _chatView.messageMarr = _commonMsgMarr;
    _chatView.onlineUserMarr = _onlineUserArr;
    
    [_chatView reloadData];
    if (_chatViewIsForbiddenScroll || _commonMsgMarr.count == 0) {
        return;
    }
    [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatView.messageMarr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)onUserUpdate:(NSArray<ZegoUserState *> *)userList updateType:(ZegoUserUpdateType)type {
    [self roomRealtimeInfomationData];
    NSLog(@"userupdate");
    for (ZegoUserState *state in userList) {
        [self roomRealtimeInfomationData];
        if (state.updateFlag == 1) {
            //进入房间 欢迎
            //            NSLog(@"%@,%@",state.userID,state.userName);
            if ([state.userID isEqualToString:self.chatroomModel.chatroom.creator_user_id]) {
                return;
            }
            [self creatWelcomeRoomView:state.userName];
        }
    }
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:_tap];
    }
    return YES;
}

#pragma mark - 推流代理
- (void)onPublishStateUpdate:(int)stateCode streamID:(NSString *)streamID streamInfo:(NSDictionary *)info {
    /*
    stateCode = 0，直播开始。
    stateCode = 3，直播遇到严重问题（如出现，请联系 ZEGO 技术支持）。
    stateCode = 4，创建直播流失败。
    stateCode = 5，获取流信息失败。
    stateCode = 6，无流信息。
    stateCode = 7，媒体服务器连接失败（请确认推流端是否正常推流、正式环境和测试环境是否设置同一个、网络是否正常）。
    stateCode = 8，DNS 解析失败。
    stateCode = 9，未登录
    stateCode = 10，逻辑服务器网络错误(网络断开时间过长时容易出现此错误)。
    stateCode = 105，发布流名被占用。
    */
    NSLog(@"stateCode:%d,%@",stateCode,info);
    switch (stateCode) {
        case 4:
        case 5:
        case 6:
            {
                [[AccountManager sharedAccountManager].zegoApi stopPublishing];
                [[AccountManager sharedAccountManager].zegoApi startPublishing:self.chatroomModel.chatroom.chatroom_id title:self.chatroomModel.chatroom.room_name flag:ZEGO_SINGLE_ANCHOR];
            }
            break;
        case 7:
        case 8:
        case 10:
        {
            [DataService toastWithMessage:@"Network connection failed"];
        }
            break;
        case 9:
        {
            [[AccountManager sharedAccountManager].zegoApi loginRoom:self.chatroomModel.chatroom.chatroom_id roomName:self.chatroomModel.chatroom.room_name role:ZEGO_ANCHOR withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
                
                if (errorCode == 0) {
                    [[AccountManager sharedAccountManager].zegoApi stopPublishing];
                    [[AccountManager sharedAccountManager].zegoApi startPublishing:self.chatroomModel.chatroom.chatroom_id title:self.chatroomModel.chatroom.room_name flag:ZEGO_SINGLE_ANCHOR];
                }else {
                    [DataService toastWithMessage:@"Login room error"];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 收到消息
- (void)onReceiveCustomCommand:(NSString *)fromUserID userName:(NSString *)fromUserName content:(NSString *)content roomID:(NSString *)roomID {
    
    NSDictionary *dic = [NSDictionary dictionaryWithJsonString:content];
    _liveView.incomeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigdiamond" bounds:CGRectMake(0, -2, 10, 9) str:[NSString stringWithFormat:@" %@",dic[@"income"]]];
}
- (void)onRecvRoomMessage:(NSString *)roomId messageList:(NSArray<ZegoRoomMessage *> *)messageList {
    for (ZegoRoomMessage *message in messageList) {
        MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
        switch (message.category) {
            case CHAT:
                {
                    [_commonMsgMarr addObject:model];
                    [self refreshCommonChatMsg];
                }
                break;
            case DANMAKU:
            {
                LiveBarrageCell *barrageCell = [[LiveBarrageCell alloc] init];
                barrageCell.barrageShowDuration = [@[@3,@4,@5,@6][rand()%4] floatValue];
                // 弹道数
                barrageCell.channelCount = 2;
                // 距离上一条弹幕的距离，可固定值
                barrageCell.margin = 10;
                // 给弹幕 模型赋值
                barrageCell.barrageModel = model;
                // 插入跑到
                [_barrageView insertBarrages:@[barrageCell]];
            }
                break;
            case GIFT:
            {
                [_commonMsgMarr addObject:model];
                [self refreshCommonChatMsg];
                
                NSDictionary *giftDic = [NSDictionary dictionary];
                NSString *type = @"";
                for (int i = 0; i < [AccountManager sharedAccountManager].giftModelMarr.count; ++i) {
                    GiftModel *giftModel = [AccountManager sharedAccountManager].giftModelMarr[i];
                    if ([giftModel.gift_key isEqualToString:model.content.name]) {
                        giftDic = @{@"picUrl":giftModel.gift_image_key,@"type":@(i)};
                        type = giftModel.type;
                        break;
                    }
                }
                NSDictionary *userDic = @{@"name":model.fromUserName,@"iconUrl":model.content.mainHeadImg,@"toName":model.content.toUserName,@"toIconUrl":@""};
                LiveGiftShowModel *showModel = [LiveGiftShowModel giftModel:giftDic userModel:userDic];
                if ([type isEqualToString:@"1"]) {
                    [_giftAnimateMarr addObject:showModel];
                    [self creatBigAnimate];
                    
                }else {
                    [self.customGiftShow animatedWithGiftModel:showModel];
                }
            }
                break;
            case ROOM_KICKEDOUT:
            {
                
            }
                break;
            case ROOM_LEAVE:
            {
                    [self roomRealtimeInfomationData];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 大动画
- (void)creatBigAnimate {
    
    LiveGiftShowModel *model = _giftAnimateMarr[0];
    
    _parser = [[SVGAParser alloc] init];
    [_parser parseWithNamed:model.giftModel.picUrl inBundle:[NSBundle mainBundle] completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
        if (videoItem != nil) {
            self.animatePlayer.videoItem = videoItem;
            [self.animatePlayer startAnimation];
        }
        
        self.giftLabel.text = [NSString stringWithFormat:@"%@ give one %@ to %@",model.user.name,model.giftModel.picUrl,model.user.toName];
        [self.giftLabel sizeToFit];
        [UIView animateWithDuration:5 animations:^{
            self.giftLabel.right = 0;
        } completion:^(BOOL finished) {
            [self.giftBG removeFromSuperview];
            self.giftBG = nil;
            [self.giftLabel removeFromSuperview];
            self.giftLabel = nil;
        }];
    } failureBlock:^(NSError * _Nonnull error) {
        
    }];
    
}

- (UILabel *)giftLabel {
    if (!_giftLabel) {
        _giftBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 50)];
        _giftBG.image = [UIImage imageNamed:@"giftAniBG"];
        [self.view addSubview:_giftBG];
        
        _giftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth, 10, 0, 0)];
        _giftLabel.font = [UIFont fontWithName:@"Marker Felt" size:25];
        _giftLabel.textColor = [UIColor colorWithRed:255/255.0 green:97/255.0 blue:0 alpha:1];
        _giftLabel.layer.shadowColor = [UIColor colorWithRed:0 green:255/255.0 blue:0 alpha:1].CGColor;
        _giftLabel.layer.shadowRadius = kCellSpace;
        _giftLabel.layer.shadowOpacity = 0.5;
        _giftLabel.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        [_giftBG addSubview:_giftLabel];
    }
    return _giftLabel;
}
- (SVGAPlayer *)animatePlayer {
    if (_animatePlayer == nil) {
        _animatePlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 2*kSpace, kScreenWidth, kScreenHeight-7*kSpace)];
        _animatePlayer.delegate = self;
        _animatePlayer.loops = 1;
        _animatePlayer.clearsAfterStop = YES;
        [self.view addSubview:_animatePlayer];
    }
    return _animatePlayer;
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    
    [self.animatePlayer removeFromSuperview];
    self.animatePlayer = nil;
    [_giftAnimateMarr removeObjectAtIndex:0];
    if (_giftAnimateMarr.count > 0) {
        [self creatBigAnimate];
    }
}

#pragma mark - collection's datasource delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _onlineUserArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OnlineCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"online" forIndexPath:indexPath];
    
    UserModel *model = _onlineUserArr[indexPath.item];
    cell.userModel = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _userModel = _onlineUserArr[indexPath.row];
    
    [self getUserInfoData];
}



#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatView) {
        MessageModel *message = _commonMsgMarr[indexPath.row];
        for (UserModel *model in _onlineUserArr) {
            if ([message.fromUserId isEqualToString:model.user_id] && ![message.fromUserId isEqualToString:[AccountManager sharedAccountManager].userID]) {
                
                _userModel = model;
            }
        }
    }else if (tableView == _userListTableview) {
        _userModel = _onlineUserArr[indexPath.row];
        [self removeUsertlistViewAction];
    }
    [self getUserInfoData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _userListTableview) {
        return 90;
    }else{
        TYTextContainer *textContainer = _chatView.textContainers[indexPath.row];
        return textContainer.textHeight+20;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_chatView]) {
        
        _chatViewIsForbiddenScroll = YES;
        [self _invalidateForbiddenScrollTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if ([scrollView isEqual:_chatView]) {
        
        [self _createForbidderScrollTimer];
    }
}

#pragma mark - 定时器
- (void)_createForbidderScrollTimer {
    
    if (!_forbiddenScrollTimer) {
        
        _forbiddenScrollTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollToBottom) userInfo:nil repeats:YES];
    }
}
- (void)scrollToBottom {
    
    _chatViewIsForbiddenScroll = NO;
    
    [self _invalidateForbiddenScrollTimer];
}
- (void)_invalidateForbiddenScrollTimer {
    
    if (_forbiddenScrollTimer) {
        
        [_forbiddenScrollTimer invalidate];
        _forbiddenScrollTimer = nil;
    }
}

//离开房间
- (void)exitRoom {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatroomModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/exitChatroom" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            
            NSDictionary *diction = @{@"name":@""};
            NSString *str = [diction dictionaryToJsonString];
            [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:str type:ZEGO_TEXT category:ROOM_LEAVE priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                
            }];
            
            [self closeRoom];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [DataService toastWithMessage:@"Unknow Error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Network Error"];
    }];
}

//关闭房间
- (void)closeRoom {
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[AccountManager sharedAccountManager].zegoApi setPreviewView:nil];
    [_preview removeFromSuperview];
    _preview = nil;
    [[AccountManager sharedAccountManager].zegoApi stopPublishing];
    [[AccountManager sharedAccountManager].zegoApi logoutRoom];
    [_liveView removeFromSuperview];
    _liveView = nil;
    [self _invalidateForbiddenScrollTimer];
    [_heartTimer invalidate];
    _heartTimer = nil;
    [_roomRealtimeInfomationTimer invalidate];
    _roomRealtimeInfomationTimer = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"longPress" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
