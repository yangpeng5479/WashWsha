//
//  LivePlayerViewController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/10.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "LivePlayerViewController.h"
#import "CommonPrex.h"
#import "LiveView.h"
#import <UIImageView+WebCache.h>
#import "OnlineCollectionViewCell.h"
#import "LLSwitch.h"
#import "ChooseGiftView.h"
#import "WYFileManager.h"
#import "GiftModel.h"
#import "LiveGiftShowModel.h"
#import "DataService.h"
#import <SVGA.h>
#import "LiveGiftShowCustom.h"
#import "GoldViewController.h"
#import "NSDictionary+Jsonstring.h"
#import "MessageModel.h"
#import <MJExtension.h>
#import "ChatTableView.h"
#import "UIViewExt.h"
#import "UserListTableView.h"
#import <RegexKitLite.h>
#import "LiveBarrageCell.h"
#import <ZBLiveBarrage.h>
#import "LiveProfileView.h"
#import "ProfileViewController.h"
#import "RechargeViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "RewardRankViewController.h"
#import <MBProgressHUD.h>
#import "WalletModel.h"


@interface LivePlayerViewController ()<ZegoLivePlayerDelegate,ZegoIMDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,LLSwitchDelegate,LiveGiftShowCustomDelegate,SVGAPlayerDelegate,UITableViewDelegate,UIScrollViewDelegate,ZBLiveBarrageDelegate>

@property(nonatomic,strong)UIView *preview;
@property(nonatomic,strong)LiveView *playerView;
@property(nonatomic,strong)UIView *chatInputView;
@property(nonatomic,strong)UITextField *inputTF;
@property(nonatomic,strong)UITapGestureRecognizer *hideKeyboardControl;
@property(nonatomic,strong)ChooseGiftView *giftView;
@property(nonatomic,strong)UIControl *removeGiftviewControl;
@property(nonatomic,strong)SVGAPlayer *animatePlayer;
@property(nonatomic,strong)SVGAParser *parser;
@property(nonatomic,strong)NSMutableArray *giftAnimateMarr;
@property(nonatomic,strong)UILabel *giftLabel;
@property(nonatomic,strong)UIImageView *giftBG;
@property(nonatomic,weak) LiveGiftShowCustom * customGiftShow;
@property(nonatomic,strong)NSMutableArray *commonMsgMarr;
@property(nonatomic,strong)NSMutableArray *onlineUserArr;
@property(nonatomic,strong)ChatTableView *chatView;
@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,strong)UserListTableView *userListTableview;
@property(nonatomic,strong)UIControl *removeUserlistviewControl;
@property(nonatomic,strong)UIView *userListBgView;
@property(nonatomic,strong)NSTimer *forbiddenScrollTimer;
@property(nonatomic,assign)BOOL chatViewIsForbiddenScroll;
@property(nonatomic,copy)NSString *atNameString;
@property(nonatomic,assign)NSRange atNameRange;
@property(nonatomic,strong)NSTimer *roomRealtimeInfomationTimer;
@property(nonatomic,assign)BOOL isBarrage;
@property(nonatomic,strong)ZBLiveBarrage *barrageView;
@property(nonatomic,strong)LiveProfileView *profieView;
@property(nonatomic,strong)UIControl *profileControl;
@property(nonatomic,strong)UIImageView *coverImageView;


@end

@implementation LivePlayerViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    [DataService changeReturnButton:self];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardAction) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longPress:) name:@"longPress" object:nil];
    
    _commonMsgMarr = [NSMutableArray array];
    _giftAnimateMarr = [NSMutableArray array];
    _onlineUserArr = [NSMutableArray array];
    
    //拉流
    [[AccountManager sharedAccountManager].zegoApi setPlayerDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setIMDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setRoomConfig:NO userStateUpdate:YES];
    
    [[AccountManager sharedAccountManager].zegoApi loginRoom:self.roomModel.chatroom.chatroom_id role:ZEGO_AUDIENCE withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
       
        if (errorCode == 0) {
            for (ZegoStream *stream in streamList) {
                NSLog(@"errorCode:%@",stream.streamID);
                [[AccountManager sharedAccountManager].zegoApi startPlayingStream:stream.streamID inView:self.preview];
                [[AccountManager sharedAccountManager].zegoApi setViewMode:ZegoVideoViewModeScaleAspectFill ofStream:stream.streamID];
                
                //房间实时信息
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self roomRealtimeInfomationData];
                    _roomRealtimeInfomationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(roomRealtimeInfomationData) userInfo:nil repeats:YES];
                });
                
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [DataService toastWithMessage:@"Room does not exist"];
                [self closeLiveAction];
            });
        }
    }];

    _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:self.roomModel.chatroom.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"bg"]];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_coverImageView];
}

#pragma mark - 懒加载
- (UIView *)preview {
    if (!_preview) {
        
        _preview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_preview];
        [self.view addSubview:self.playerView];
        [self creatContenView];
    }
    return _preview;
}

- (LiveView *)playerView {
    if (!_playerView) {
        
        _playerView = [[LiveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        if (IS_IPHONE_X) {
            _playerView.frame = CGRectMake(0, kSpace, kScreenWidth, kScreenHeight-2*kSpace);
        }
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoAction)];
        _playerView.iconView.userInteractionEnabled = YES;
        [_playerView.iconView addGestureRecognizer:iconTap];
        [_playerView.iconView sd_setImageWithURL:[NSURL URLWithString:self.roomModel.chatroom.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
        
        _playerView.incomeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigdiamond" bounds:CGRectMake(0, -2, 10, 9) str:[NSString stringWithFormat:@" %@",self.roomModel.chatroom.creator_user_info.income]];
        _playerView.incomeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *incomeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userRankAction)];
        [_playerView.incomeView addGestureRecognizer:incomeTap];
        
        _playerView.nameeLabel.text = self.roomModel.chatroom.creator_user_info.name;
        _playerView.idLabel.text = [NSString stringWithFormat:@"@%@",self.roomModel.chatroom.creator_user_info.user_id];
        
        _playerView.onlineCV.delegate = self;
        _playerView.onlineCV.dataSource = self;
        [_playerView.onlineCV registerClass:[OnlineCollectionViewCell class] forCellWithReuseIdentifier:@"online"];
        
        if (self.roomModel.chatroom.has_follow) {
            _playerView.followBtn.hidden = YES;
        }else {
           [_playerView.followBtn addTarget:self action:@selector(followBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_playerView.nameeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(45);
            }];
        }
        
        [_playerView.onlineBtn addTarget:self action:@selector(onlineBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.giftBtn addTarget:self action:@selector(giftBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.closeBtn addTarget:self action:@selector(closeLiveAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playerView;
}

//礼物弹幕
- (LiveGiftShowCustom *)customGiftShow{
    if (!_customGiftShow) {
        _customGiftShow = [LiveGiftShowCustom addToView:self.view];
        _customGiftShow.addMode = LiveGiftAddModeAdd;
        [_customGiftShow setMaxGiftCount:2];
        [_customGiftShow setShowMode:LiveGiftShowModeFromTopToBottom];
        [_customGiftShow setAppearModel:LiveGiftAppearModeLeft];
        [_customGiftShow setHiddenModel:LiveGiftHiddenModeLeft];
        [_customGiftShow enableInterfaceDebug:YES];
        _customGiftShow.delegate = self;
    }
    return _customGiftShow;
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
- (ZBLiveBarrage *)barrageView {
    if (!_barrageView) {
        _barrageView = [[ZBLiveBarrage alloc] init];
        _barrageView.backgroundColor = [UIColor clearColor];
        _barrageView.delegate = self;
    }
    return _barrageView;
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

#pragma mark - 数据
//聊天室实时信息
- (void)roomRealtimeInfomationData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.roomModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/getChatroomRtInfo" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSLog(@"roomRealtimeInfomationData:%@",data);
            NSDictionary *dic = data[@"data"];
            
            NSMutableArray *listenersArr = [UserModel mj_objectArrayWithKeyValuesArray:dic[@"listeners"]];
            self.roomModel.listeners = listenersArr;
            
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
            [_playerView.onlineCV reloadData];
            
            if (_onlineUserArr.count <= 0) {
                _playerView.onlineBtn.hidden = YES;
            }else if (_onlineUserArr.count < 1000 && _onlineUserArr.count > 0) {
                _playerView.onlineBtn.hidden = NO;
                [_playerView.onlineBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_onlineUserArr.count] forState:UIControlStateNormal];
            }else {
                _playerView.onlineBtn.hidden = NO;
                [_playerView.onlineBtn setTitle:[NSString stringWithFormat:@"%.1uk",_onlineUserArr.count/1000] forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
//发送礼物
- (void)sendGiftDta:(NSString *)key WithShowModel:(LiveGiftShowModel *)showModel{
    
    NSDictionary *dic = @{@"gift_key":key,@"token":[AccountManager sharedAccountManager].token,@"gift_count":@1,@"to_user_id":self.roomModel.chatroom.creator_user_id};
    [DataService postWithURL:@"rest3/v1/Gift/give_gift" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"wallet"];
            _giftView.goldLabel.text = [NSString stringWithFormat:@"%ld",[diction[@"coin_total"] integerValue]];
            _giftView.diamondLabel.text = [NSString stringWithFormat:@"%ld",[diction[@"diamond_total"] integerValue]];
            
            [self sendChatMessage:GIFT WithGiftKey:key];
            if ([showModel.giftModel.type isEqualToString:@"1"]) {
                [_giftAnimateMarr addObject:showModel];
                [self creatBigAnimate];
            }else {
                
                [self.customGiftShow animatedWithGiftModel:showModel];
            }
        }else if ([data[@"status"] integerValue] == 30007) {
            
            [self removeGiftview];
            //余额不足
            UIAlertController *balanceAlert = [UIAlertController alertControllerWithTitle:nil message:@"Your account balance is not enougn,whether to recharge immediately" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *recharge = [UIAlertAction actionWithTitle:@"Go Recharge" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self rechargeBtnAction];
            }];
            [balanceAlert addAction:cancelAction];
            [balanceAlert addAction:recharge];
            
            [self presentViewController:balanceAlert animated:YES completion:nil];
        }else if ([data[@"status"] integerValue] == 30008) {
            [self removeGiftview];
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
        
    }];
}

//关注
- (void)followUser:(UIButton *)sender {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"star_user_id":_userModel.user_id};
    [DataService postWithURL:@"rest3/v1/follow/follow" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [sender setTitle:@"Followed" forState:UIControlStateNormal];
            _userModel.has_follow = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

//取消关注
- (void)unfollowUser:(UIButton *)sender {
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"star_user_id":_userModel.user_id};
    [DataService postWithURL:@"rest3/v1/follow/unfollow" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [sender setTitle:@"Follow" forState:UIControlStateNormal];
            _userModel.has_follow = NO;
        }
    } failure:^(NSError *error) {
        
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

//获取个人财产
- (void)loadWalletData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Wallet/get_wallet" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            WalletModel *walletModel = [WalletModel mj_objectWithKeyValues:diction];
            _giftView.goldLabel.text = [NSString stringWithFormat:@"%ld",[walletModel.wallet[@"coin_total"] integerValue]];
            _giftView.diamondLabel.text = [NSString stringWithFormat:@"%ld",[walletModel.wallet[@"diamond_total"] integerValue]];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 视图
- (void)creatContenView {
    //聊天视图
    _chatView = [[ChatTableView alloc] initWithFrame:CGRectMake(kSpace,kScreenHeight-70-200, kScreenWidth-kSpace- 75 - kSpace, 200) style:UITableViewStylePlain];
    _chatView.delegate = self;
    [_playerView addSubview:_chatView];
    
    [_playerView addSubview:self.barrageView];
    [_barrageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(_chatView.mas_top).offset(-30);
        make.height.mas_equalTo(100);
    }];
    [_barrageView start];
    
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
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [bgview addSubview:sendBtn];
    
    UILabel *lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-70, 17.5, 0.5, 15)];
    lineLabel2.backgroundColor = kLineColor;
    [bgview addSubview:lineLabel2];
    
    _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(lineLabel1.right+kCellSpace, 0, lineLabel2.left-lineLabel1.right-kSpace, inputHeight)];
    _inputTF.placeholder = @"Say something";
    _inputTF.font = [UIFont systemFontOfSize:16];
    _inputTF.delegate = self;
    [bgview addSubview:_inputTF];
    
    [_playerView addSubview:_chatInputView];
    
    //选择礼物视图
    _giftView = [[ChooseGiftView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 270)];
    _giftView.alpha = 0;
    [self.view addSubview:_giftView];
    
    [_giftView.destinationLabel removeFromSuperview];
    _giftView.destinationLabel = nil;
    [_giftView.iconView removeFromSuperview];
    _giftView.iconView = nil;
    [_giftView.arrowBtn removeFromSuperview];
    _giftView.arrowBtn = nil;
    [_giftView.rechargeBtn addTarget:self action:@selector(rechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < [AccountManager sharedAccountManager].giftListMarr.count; ++i) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendGift:)];
        UIView *button = (UIView *)[_giftView.bgScrollView viewWithTag:500+i];
        
        [button addGestureRecognizer:tap];
    }
    
    [self loadWalletData];
}
//发送礼物视图
- (void)sendGiftView {
    
    [UIView animateWithDuration:.35 animations:^{
        CGFloat off = 55;
        if (IS_IPHONE_X) {
            off = 65;
        }
        _playerView.bottomView.transform = CGAffineTransformMakeTranslation(0, off);
        _giftView.alpha = 1;
        _giftView.bottom = kScreenHeight;
        
    }completion:^(BOOL finished) {
        _removeGiftviewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - _giftView.height)];
        _removeGiftviewControl.backgroundColor = [UIColor clearColor];
        [_removeGiftviewControl addTarget:self action:@selector(removeGiftview) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_removeGiftviewControl];
    }];
}

//移除礼物视图
- (void)removeGiftview {
    [UIView animateWithDuration:.35 animations:^{
        _giftView.top = kScreenHeight;
        _giftView.alpha = 0;
        _playerView.bottomView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (_removeGiftviewControl) {
            [_removeGiftviewControl removeFromSuperview];
            _removeGiftviewControl = nil;
        }
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

#pragma mark - 点击事件
//主播资料
- (void)userInfoAction {
    _userModel = self.roomModel.chatroom.creator_user_info;
    [UIView animateWithDuration:.35 animations:^{
        
        [self creatProfileView:_userModel].top = (kScreenHeight-350)/2;
    }];
}

//排行榜
- (void)userRankAction {
    RewardRankViewController *vc = [[RewardRankViewController alloc] init];
    vc.userid = self.roomModel.chatroom.creator_user_id;
    [self.navigationController pushViewController:vc animated:YES];
}

//关注主播
- (void)followBtnAction {
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"star_user_id":self.roomModel.chatroom.creator_user_id};
    [DataService postWithURL:@"rest3/v1/follow/follow" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == 1) {
            //关注成功
            _playerView.followBtn.hidden = YES;
            self.roomModel.chatroom.has_follow = YES;
            [_playerView.nameeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(70);
            }];
        }else {
            [DataService toastWithMessage:@"Follow Error"];
        }
    } failure:^(NSError *error) {
        
    }];
}
//在线列表
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
    if (self.roomModel.postBanned) {
        [DataService toastWithMsg:@"You are got muted by the anchor"];
        return;
    }
    [_inputTF becomeFirstResponder];
}
//发送消息
- (void)sendMessageAction {
    
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
//礼物视图
- (void)giftBtnAction {
    [self sendGiftView];
}
//发送礼物事件
- (void)sendGift:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = (UIView *)tap.view;
    
    UserModel *usermodel = [WYFileManager getCustomObjectWithKey:@"userModel"];
    GiftModel *giftModel = [AccountManager sharedAccountManager].giftModelMarr[view.tag-500];
    
#pragma mark - 更改礼物type
    NSDictionary *giftDic = @{@"picUrl":giftModel.gift_image_key,@"type":giftModel.type};
    NSDictionary *userDic = @{@"name":usermodel.name,@"iconUrl":usermodel.image,@"toName":usermodel.name,@"toIconUrl":@""};
    LiveGiftShowModel *showModel = [LiveGiftShowModel giftModel:giftDic userModel:userDic];
    [self sendGiftDta:giftModel.gift_key WithShowModel:showModel];
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
            //点击按钮 进行关注
            [self followUser:sender];
        }else {
            [self unfollowUser:sender];
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

//举报 拉黑 踢出房间
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
        [self reportData:_userModel.user_id];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:black];
    [alertController addAction:ok];
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
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"black_user_id":_userModel.user_id};
    [DataService postWithURL:@"rest3/v1/Blacklist/addBlackUser" type:1 params:dic fileData:nil success:^(id data) {
        [DataService toastWithMessage:@"Oeration success!"];
    } failure:^(NSError *error) {
        
    }];
}

//充值
- (void)rechargeBtnAction {
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self removeGiftview];
}
//分享
- (void)shareBtnAction {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    [shareParams SSDKSetupFacebookParamsByText:@"Come and watch the live broadcast..." image:nil url:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/vcoze/id1392171229?mt=8"] urlTitle:nil urlName:nil attachementUrl:nil type:SSDKContentTypeWebPage];
    [shareParams SSDKEnableUseClientShare];
    [ShareSDK share:SSDKPlatformTypeFacebook parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSLog(@"%lu",(unsigned long)state);
    }];
}
//离开直播
- (void)closeLiveAction {
    
    UIAlertController *closeAlert = [UIAlertController alertControllerWithTitle:nil message:@"Whether to leave the current room" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *leave = [UIAlertAction actionWithTitle:@"Leave" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self exitRoom];
    }];
    UIAlertAction *stay = [UIAlertAction actionWithTitle:@"Stay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [closeAlert addAction:leave];
    [closeAlert addAction:stay];
    [self presentViewController:closeAlert animated:YES completion:nil];
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

#pragma mark 发送消息
- (void)sendChatMessage:(ZegoMessageCategory)type WithGiftKey:(NSString *)giftKey {
    
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *gift_type = @"";
    for (GiftModel *model in [AccountManager sharedAccountManager].giftModelMarr) {
        if ([model.gift_key isEqualToString:giftKey]) {
            gift_type = model.type;
            break;
        }
    }
    if (type == CHAT || type == DANMAKU) {
        dic = @{@"name":_inputTF.text,@"num":model.active_lv,@"gender":model.gender,@"mainHeadImg":model.image};
    }else if (type == GIFT) {
        dic = @{@"name":giftKey,@"num":@"1",@"mainHeadImg":model.image,@"uid":self.roomModel.chatroom.creator_user_id,@"toUserName":self.roomModel.chatroom.creator_user_info.name,@"toHeadImg":self.roomModel.chatroom.creator_user_info.image,@"type":gift_type};
    }else if (type == LIKE) {
        dic = @{@"name":@"heart"};
    }
    
    NSString *jsonStr = [dic dictionaryToJsonString];
    
    NSDictionary *message = @{@"fromUserId":model.user_id,@"fromUserName":model.name,@"messageId":@(14),@"content":jsonStr,@"type":@(1),@"category":@(type)};
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:type priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        
        if (errorCode == 0) {
            if (type == LIKE) {
                return ;
            }
            MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
            if (_isBarrage && type != GIFT) {
                
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
#pragma mark - 大动画
- (void)creatBigAnimate {
    
    [self removeGiftview];
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

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    
    [self.animatePlayer removeFromSuperview];
    self.animatePlayer = nil;
    [_giftAnimateMarr removeObjectAtIndex:0];
    if (_giftAnimateMarr.count > 0) {
        [self creatBigAnimate];
    }
}

#pragma mark - 播放代理
- (void)onPlayStateUpdate:(int)stateCode streamID:(NSString *)streamID {
    if (stateCode == 0) {
        if (_coverImageView) {
            [_coverImageView removeFromSuperview];
            _coverImageView = nil;
        }
    }
    NSLog(@"stateCode:%d,%@",stateCode,streamID);
}

#pragma mark - 收到消息
- (void)onUserUpdate:(NSArray<ZegoUserState *> *)userList updateType:(ZegoUserUpdateType)type {
    [self roomRealtimeInfomationData];
    NSLog(@"userupdate");
    for (ZegoUserState *state in userList) {
        if (state.updateFlag == 1) {
            //进入房间 欢迎
            //            NSLog(@"%@,%@",state.userID,state.userName);
            if ([state.userID isEqualToString:self.roomModel.chatroom.creator_user_id]) {
                return;
            }
            [self creatWelcomeRoomView:state.userName];
        }else {
            if ([state.userID isEqualToString:self.roomModel.chatroom.creator_user_id]) {
                [DataService toastWithMessage:@"Room closed"];
                [self closeRoom];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

//收到系统消息
- (void)onReceiveCustomCommand:(NSString *)fromUserID userName:(NSString *)fromUserName content:(NSString *)content roomID:(NSString *)roomID {
    NSDictionary *dic = [NSDictionary dictionaryWithJsonString:content];
    _playerView.incomeLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigdiamond" bounds:CGRectMake(0, -2, 10, 9) str:[NSString stringWithFormat:@" %@",dic[@"income"]]];
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
                if ([[AccountManager sharedAccountManager].userID integerValue] == model.content.uid) {
                    
                    [DataService toastWithMessage:@"You were kicked out of the room!"];
                    [self exitRoom];
                }else {
                    
                    [self roomRealtimeInfomationData];
                }
            }
                break;
            case FORBIDDEN:
            {
                if ([[AccountManager sharedAccountManager].userID integerValue] == model.content.uid) {
                    
                    [DataService toastWithMsg:@"You were got muted by the anchor"];
                    self.roomModel.postBanned = YES;
                }
            }
                break;
            case ROOM_LEAVE:
            {
                if ([message.fromUserId isEqualToString:self.roomModel.chatroom.creator_user_id]) {
                    //房间关闭
                    [DataService toastWithMessage:@"Room closed"];
                    [self closeRoom];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self roomRealtimeInfomationData];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - LLswitch delegate
//开启关闭弹幕
- (void)valueDidChanged:(LLSwitch *)llSwitch on:(BOOL)on {
    
    if (on) {
        _inputTF.placeholder = @"Open the barrage，1 silver coin";
        _isBarrage = YES;
    }else {
        _inputTF.placeholder = @"Say something";
        _isBarrage = NO;
    }
}

#pragma mark - 通知
//键盘弹出
- (void)showKeyboardAction:(NSNotification *)noti {
    
    CGRect rect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat inputHeight = rect.size.height+50;

    if (IS_IPHONE_X) {
        inputHeight += kSpace;
    }
    [UIView animateWithDuration:.35 animations:^{
        _chatInputView.transform = CGAffineTransformMakeTranslation(0, -inputHeight);
        _playerView.bottomView.transform = CGAffineTransformMakeTranslation(0, 55);
    }];
    
    if (_hideKeyboardControl) {
        return;
    }
    
    _hideKeyboardControl = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardAction)];
    [self.view addGestureRecognizer:_hideKeyboardControl];
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

//收回键盘
- (void)hideKeyboardAction {
    
    [_inputTF resignFirstResponder];
    _inputTF.text = @"";
    [self.view removeGestureRecognizer:_hideKeyboardControl];
    _hideKeyboardControl = nil;
    [UIView animateWithDuration:.3 animations:^{
        _playerView.bottomView.transform = CGAffineTransformIdentity;
        _chatInputView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
       
    }];
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
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.roomModel.chatroom.chatroom_id};
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
    [[AccountManager sharedAccountManager].zegoApi setPreviewView:nil];
    [_preview removeFromSuperview];
    _preview = nil;
    [[AccountManager sharedAccountManager].zegoApi logoutRoom];
    [_playerView removeFromSuperview];
    _playerView = nil;
    [self _invalidateForbiddenScrollTimer];
    [_roomRealtimeInfomationTimer invalidate];
    _roomRealtimeInfomationTimer = nil;
}

- (void)dealloc {
    [_barrageView stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"longPress" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
