//
//  RoomViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RoomViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DataService.h"
#import "CommonPrex.h"
#import "ChatRoomModel.h"
#import <MJExtension.h>
#import <MarqueeLabel.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import <Masonry.h>
#import "AccountManager.h"
#import "ChooseGiftView.h"
#import "WalletModel.h"
#import "RoomLimitImageView.h"
#import "RoomSettingViewController.h"
#import <UIButton+WebCache.h>
#import "ProfileCardView.h"
#import "OnlineCollectionViewCell.h"
#import "ChatTableView.h"
#import "MessageModel.h"
#import "WYFileManager.h"
#import "NSDictionary+Jsonstring.h"
#import "UserListTableView.h"
#import <RegexKitLite.h>
#import "LiveGiftShowCustom.h"
#import "GiftModel.h"
#import <ZegoLiveRoom/ZegoLiveRoom.h>
#import "RechargeViewController.h"
#import "MusicPlayerViewController.h"
#import "MusicPlayerViewController.h"
#import "GoldViewController.h"
#import "ProfileViewController.h"
#import <SVGA.h>


@interface RoomViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,CAAnimationDelegate,ZegoRoomDelegate,ZegoLivePlayerDelegate,ZegoLivePublisherDelegate,ZegoIMDelegate,UITextFieldDelegate,UIAlertViewDelegate,CAAnimationDelegate,UITableViewDelegate,LiveGiftShowCustomDelegate,ZegoLiveEventDelegate,SVGAPlayerDelegate>

@property(nonatomic,strong)UIView *chatInputView;
@property(nonatomic,strong)UITextField *commentText;
@property(nonatomic,strong)UIControl *hidekeyBoardControl;
@property(nonatomic,strong)UIAlertView *closeAlertView;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UIButton *refreshBtn;
@property(nonatomic,assign)BOOL isHeart;
@property(nonatomic,strong)NSTimer *heartTimer;
@property(nonatomic,strong)NSTimer *roomRealtimeInfomationTimer;
@property(nonatomic,strong)UIButton *heartBtn;
@property(nonatomic,strong)ChooseGiftView *giftView;
@property(nonatomic,strong)UIControl *removeGiftviewControl;
@property(nonatomic,strong)RoomLimitImageView *limitView;
@property(nonatomic,strong)UIControl *removeLimitViewControl;
@property(nonatomic,copy)NSString *enterLimitStr;
@property(nonatomic,copy)NSString *isAuth;
@property(nonatomic,assign)BOOL isSpeaker; //扬声器
@property(nonatomic,assign)BOOL isMute; //麦克风静音
@property(nonatomic,strong)NSMutableArray *applySpeaksMarr;
@property(nonatomic,strong)UILabel *applyLabel;
@property(nonatomic,strong)ProfileCardView *profileCardView;
@property(nonatomic,strong)UIControl *removeProfileControl;
@property(nonatomic,strong)UserModel *usermodel;
@property(nonatomic,strong)NSMutableArray *onlineUserArr;
@property(nonatomic,strong)NSMutableArray *commonMsgMarr;
@property(nonatomic,strong)ChatTableView *chatView;
@property(nonatomic,strong)NSTimer *forbiddenScrollTimer;
@property(nonatomic,assign)BOOL chatViewIsForbiddenScroll;
@property(nonatomic,strong)UIView *userListBgView;
@property(nonatomic,strong)UserListTableView *userListTableview;
@property(nonatomic,strong)UIControl *removeUserlistviewControl;
@property(nonatomic,copy)NSString *atNameString;
@property(nonatomic,assign)NSRange atNameRange;
@property(nonatomic,weak) LiveGiftShowCustom * customGiftShow;
@property(nonatomic,copy)NSString *pasStr;
@property(nonatomic,strong)NSMutableArray *followsMarr;
@property(nonatomic,strong)NSMutableArray *diceResultArr;
@property(nonatomic,strong)CABasicAnimation *spin1;
@property(nonatomic,strong)CABasicAnimation *spin2;
@property(nonatomic,strong)CABasicAnimation *spin3;
@property(nonatomic,strong)CABasicAnimation *spin4;
@property(nonatomic,strong)CABasicAnimation *hostSpin;
@property(nonatomic,strong)UIImageView *hostDiceImage;
@property(nonatomic,strong)UIImageView *diceImage1;
@property(nonatomic,strong)UIImageView *diceImage2;
@property(nonatomic,strong)UIImageView *diceImage3;
@property(nonatomic,strong)UIImageView *diceImage4;
@property(nonatomic,strong)UIView *newusersAwardView;
@property(nonatomic,strong)NSTimer *likeTimer;
@property(nonatomic,assign)NSInteger likeCount;
@property(nonatomic,strong)MusicPlayerViewController *musicVC;
@property(nonatomic,strong)SVGAPlayer *animatePlayer;
@property(nonatomic,strong)SVGAParser *parser;
@property(nonatomic,strong)NSMutableArray *giftAnimateMarr;
@property(nonatomic,strong)UILabel *giftLabel;
@property(nonatomic,strong)UIImageView *giftBG;

//监控声音
@property(nonatomic,strong)NSMutableArray *streamMarr;
@property(nonatomic,strong)NSMutableArray *speakerMarr;
@property(nonatomic,strong)dispatch_source_t anchorTimer;
@property(nonatomic,strong)dispatch_source_t firstTimer;
@property(nonatomic,strong)dispatch_source_t secondTimer;
@property(nonatomic,strong)dispatch_source_t thirdTimer;
@property(nonatomic,strong)dispatch_source_t fiouthTimer;
@property(nonatomic,strong)NSMutableArray *imageArr;


@end


@implementation RoomViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = YES;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
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
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    _isSpeaker = NO;
    _isMute = NO;
    
    _applySpeaksMarr = [NSMutableArray array];
    _onlineUserArr = [NSMutableArray array];
    _commonMsgMarr = [NSMutableArray array];
    _streamMarr = [NSMutableArray array];
    _speakerMarr = [NSMutableArray array];
    _imageArr = [NSMutableArray array];
    _giftAnimateMarr = [NSMutableArray array];
    
    for (int i = 0; i < 5; ++i) {
        NSString *imagename = [NSString stringWithFormat:@"icon-voice%d",i+1];
        UIImage *image = [UIImage imageNamed:imagename];
        [_imageArr addObject:image];
    }
    
    [[AccountManager sharedAccountManager].zegoApi setRoomDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setPlayerDelegate:self];    //播放代理
    [[AccountManager sharedAccountManager].zegoApi setPublisherDelegate:self]; //推流代理
    [[AccountManager sharedAccountManager].zegoApi setIMDelegate:self];        //消息代理
    [[AccountManager sharedAccountManager].zegoApi setRoomConfig:NO userStateUpdate:YES];
    [[AccountManager sharedAccountManager].zegoApi setLiveEventDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi enableAux:YES];
    [[AccountManager sharedAccountManager].zegoApi setAuxVolume:30];
    [[AccountManager sharedAccountManager].zegoApi setRoomConfig:NO userStateUpdate:YES];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboardAction) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(longPress:) name:@"longPress" object:nil];
    
    if (self.type == 1) {
        //如果是主播
        [[AccountManager sharedAccountManager].zegoApi loginRoom:self.chatModel.chatroom.chatroom_id role:ZEGO_ANCHOR withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
            if (errorCode == 0) {
                
                [[AccountManager sharedAccountManager].zegoApi startPublishing:[AccountManager sharedAccountManager].userID title:_chatModel.chatroom.room_name flag:ZEGO_JOIN_PUBLISH];
            }
        }];
    }else {
        [[AccountManager sharedAccountManager].zegoApi loginRoom:self.chatModel.chatroom.chatroom_id role:ZEGO_AUDIENCE withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
            
            NSLog(@"errorCode:%d",errorCode);
            for (ZegoStream *stream in streamList) {
                NSLog(@"ZegoStream:%@",stream.userName);
                _streamMarr = [NSMutableArray arrayWithArray:streamList];
                [[AccountManager sharedAccountManager].zegoApi startPlayingStream:stream.streamID inView:nil];
            }
        }];
    }
    
    //心跳`
    [self heartBeatData];
    _heartTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(heartBeatData) userInfo:nil repeats:YES];
    
    //房间实时信息
    [self roomRealtimeInfomationData];
    _roomRealtimeInfomationTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(roomRealtimeInfomationData) userInfo:nil repeats:YES];
    
    [self setupUI];
    [self loadWalletData];
    
    _isAuth = @"0";
    _enterLimitStr = @"all";
    _pasStr = @"";
    
    //初始化弹幕
    [self customGiftShow];
    
    [self getFollowsUser];
    _musicVC = [[MusicPlayerViewController alloc] init];
    
    [self creatTimer];
}

- (void) setupUI {
    
    //背景图片
    UIImageView *backgroundImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backgroundImageview.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:backgroundImageview];
    
    //头部视图
    _topView = [[InroomTopView alloc] init];
    if (IS_IPHONE_X) {
        _topView.frame = CGRectMake(15, 44, kScreenWidth-30, 35);
    }else {
        _topView.frame = CGRectMake(15, 35, kScreenWidth-30, 35);
    }
    _topView.nameLabel.text = self.chatModel.chatroom.room_name;
    _topView.onlineCollectionview.dataSource = self;
    _topView.onlineCollectionview.delegate = self;
    [_topView.onlineCollectionview registerClass:[OnlineCollectionViewCell class] forCellWithReuseIdentifier:@"online"];
    [_topView.followBtn addTarget:self action:@selector(followBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_topView.reportRoomBtn addTarget:self action:@selector(reportRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    if (self.chatModel.chatroom.has_liked == YES) {
        _topView.followBtn.hidden = YES;
    }else {
        _topView.followBtn.hidden = NO;
    }
    
    //中间部分
    _centerView = [[InroomCenterView alloc] initWithFrame:CGRectMake(0, 95, kScreenWidth, (220+15+18+10+15+20+60+30+10)/2)];
    [self.view addSubview:_centerView];
    
    NSInteger onlineCount;
    if (self.type == 1) {
        onlineCount = [self.chatModel.live_count_info[@"online_count"] integerValue];
        _likeCount = [self.chatModel.live_count_info[@"like_count"] integerValue];
    }else {
        onlineCount = [self.chatModel.countInfo[@"online_count"] integerValue];
        _likeCount = [self.chatModel.countInfo[@"like_count"] integerValue];
    }
    
    _topView.onlineLabel.text = [NSString stringWithFormat:@"%ld online",(long)onlineCount];
    _topView.likeLabel.text = [NSString stringWithFormat:@"%ld like",(long)_likeCount];
    [_topView.onlineCollectionview reloadData];
    
    [_centerView.iconView sd_setImageWithURL:[NSURL URLWithString:_chatModel.chatroom.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _centerView.nicknameLabel.text = self.chatModel.chatroom.creator_user_info.name;
    _centerView.signatureLabel.text = self.chatModel.chatroom.room_desc;
    if (self.chatModel.chatroom.topic == nil) {
        _centerView.topicBtn.hidden = YES;
    }else {
        
        [_centerView.topicBtn setTitle:self.chatModel.chatroom.topic[@"name"] forState:UIControlStateNormal];
        [_centerView.topicBtn.titleLabel sizeToFit];
    }
    _centerView.voiceImageview.hidden = YES;
    _centerView.voiceImageview.animationImages = _imageArr;
    _centerView.voiceImageview.animationRepeatCount = 0;
    _centerView.voiceImageview.animationDuration = 1;
    _centerView.voiceImageview.contentMode = UIViewContentModeCenter;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userProfile)];
    [_centerView.iconView addGestureRecognizer:tap];
    
    //排麦四个按钮
    CGFloat w = (kScreenWidth - 120)/4;
    for (int i = 0; i < 4; ++i) {
        
        UIImageView *bgview = [[UIImageView alloc] initWithFrame:CGRectMake(10+i*(w+30), _centerView.bottom+15, w, w)];
        bgview.backgroundColor = [UIColor clearColor];
        bgview.tag = 105+i;
        bgview.userInteractionEnabled = YES;
        [self.view addSubview:bgview];
        
        UIButton *sayBtn = [[UIButton alloc] init];
        sayBtn.tag = i+100;
        [sayBtn setBackgroundImage:[UIImage imageNamed:@"icon-sofa"] forState:UIControlStateNormal];
        sayBtn.layer.cornerRadius = (w-10)/2;
        sayBtn.layer.masksToBounds = YES;
        [bgview addSubview:sayBtn];
        [sayBtn addTarget:self action:@selector(forbidenPositionAndUserinfo:) forControlEvents:UIControlEventTouchUpInside];
        
        [sayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(bgview.mas_centerX);
            make.centerY.mas_equalTo(bgview.mas_centerY);
            make.width.offset(w-10);
            make.height.offset(w-10);
        }];
        
        UIImageView *monitoringSoundImageView = [[UIImageView alloc] init];
        monitoringSoundImageView.image = [UIImage imageNamed:@"icon-voice1"];
        monitoringSoundImageView.tag = 120+i;
        [bgview addSubview:monitoringSoundImageView];
        [monitoringSoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(bgview.mas_right).offset(-2*kSpace);
            make.top.mas_equalTo(bgview.mas_bottom).offset(-2*kSpace);
            make.width.height.equalTo(@15);
        }];
        monitoringSoundImageView.hidden = YES;
        monitoringSoundImageView.animationImages = _imageArr;
        monitoringSoundImageView.animationRepeatCount = 0;
        monitoringSoundImageView.animationDuration = 1;
        monitoringSoundImageView.contentMode = UIViewContentModeCenter;
    }
    
    //底部视图
    //弹出键盘
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [button setTitle:@"Say Somthing..." forState:UIControlStateNormal];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    button.layer.cornerRadius = 20;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(showTextField) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    if (IS_IPHONE_X) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.view.mas_left).offset(15);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30);
            make.width.offset(175);
            make.height.offset(40);
        }];
    }else {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(self.view.mas_left).offset(15);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-15);
            make.width.offset(175);
            make.height.offset(40);
        }];
    }
    
    
    //功能按钮
    int buttonCount;
    NSArray *imagearr = [NSArray array];
    if (self.type == 1) {
        buttonCount = 4;
        imagearr = @[@"icon-close",@"more",@"icon-dice",@"icon-chatroom-gift"];
    }else {
        buttonCount = 3;
        imagearr = @[@"icon-close",@"more",@"icon-chatroom-gift"];
    }
    for (int i = buttonCount; i > 0; --i) {
        
        UIButton *btn = [[UIButton alloc] init];
        if (IS_IPHONE_X) {
            btn.frame = CGRectMake(kScreenWidth-15-i*40-(i-1)*10, kScreenHeight-40-30, 40, 40);
        }else {
            btn.frame = CGRectMake(kScreenWidth-15-i*40-(i-1)*10, kScreenHeight-40-15, 40, 40);
        }
        btn.tag = 150+i;
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [self.view addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:imagearr[i-1]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //创建点赞和上麦按钮
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"icon-voice"] forState:UIControlStateNormal];
//    voiceBtn.layer.cornerRadius = 20;
//    voiceBtn.layer.masksToBounds = YES;
    [voiceBtn addTarget:self action:@selector(voiceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceBtn];
    [voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.bottom.mas_equalTo(button.mas_top).offset(-30);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    _applyLabel = [[UILabel alloc] init];
    _applyLabel.textColor = [UIColor whiteColor];
    _applyLabel.font = [UIFont systemFontOfSize:15];
    _applyLabel.textAlignment = NSTextAlignmentCenter;
    [_applyLabel sizeToFit];
    _applyLabel.backgroundColor = [UIColor redColor];
    _applyLabel.layer.cornerRadius = kSpace;
    _applyLabel.layer.masksToBounds = YES;
    _applyLabel.hidden = YES;
    [voiceBtn addSubview:_applyLabel];
    [_applyLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.mas_equalTo(voiceBtn.mas_right);
        make.top.mas_equalTo(voiceBtn.mas_top);
        make.width.height.equalTo(@20);
    }];
    
    _heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_heartBtn setBackgroundImage:[UIImage imageNamed:@"icon-chatroom-like"] forState:UIControlStateNormal];
    _heartBtn.layer.cornerRadius = 20;
    _heartBtn.layer.masksToBounds = YES;
    [_heartBtn addTarget:self action:@selector(heartBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_heartBtn];
    [_heartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(voiceBtn.mas_right);
        make.bottom.mas_equalTo(voiceBtn.mas_top).offset(-15);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    //如果是主持人
    if (self.type == 1) {
        _topView.followBtn.hidden = YES;
        voiceBtn.hidden = YES;
        [_heartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view.mas_right).offset(-30);
            make.bottom.mas_equalTo(button.mas_top).offset(-30);
            make.width.offset(50);
            make.height.offset(50);
        }];
    }
    
    _chatView = [[ChatTableView alloc] initWithFrame:CGRectMake(kSpace,_centerView.bottom+15+w+kSpace, kScreenWidth-kSpace- 75 - kSpace, kScreenHeight-_centerView.bottom-15-w-kSpace - 55) style:UITableViewStylePlain];
    if (IS_IPHONE_X) {
        _chatView.frame = CGRectMake(kSpace,_centerView.bottom+15+w+kSpace, kScreenWidth-kSpace- 75 - kSpace, kScreenHeight-_centerView.bottom-30-w-kSpace - 55);
    }
    _chatView.delegate = self;
    [self.view addSubview:_chatView];
    
    //选择礼物视图
    _giftView = [[ChooseGiftView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 250)];
    _giftView.alpha = 0;
    [self.view addSubview:_giftView];
    
    _giftView.destinationLabel.text = [NSString stringWithFormat:@"Give:%@",self.chatModel.chatroom.creator_user_info.name];
    [_giftView.iconView sd_setImageWithURL:[NSURL URLWithString:self.chatModel.chatroom.creator_user_info.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    [_giftView.rechargeBtn addTarget:self action:@selector(rechargeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_giftView.arrowBtn addTarget:self action:@selector(choiceUser) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < [AccountManager sharedAccountManager].giftListMarr.count; ++i) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendGift:)];
        UIView *button = (UIView *)[_giftView.bgScrollView viewWithTag:500+i];
        
        [button addGestureRecognizer:tap];
    }
    
    //背景音乐按钮
    if (self.type == 1) {
        UIButton *musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-90, 200, 90, 30)];
        [musicBtn setImage:[UIImage imageNamed:@"Shareentrance"] forState:UIControlStateNormal];
        [musicBtn addTarget:self action:@selector(shareMusicAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:musicBtn];
    }
}

//键盘上面的输入视图
- (void)createCommentsView {
    
    if (!_chatInputView) {

        _chatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0)];
        _chatInputView.backgroundColor = [UIColor whiteColor];
        [self.view.window addSubview:_chatInputView];//添加到window上或者其他视图也行，只要在视图以外就好了

        _commentText = [[UITextField alloc] initWithFrame:CGRectMake(kSpace, 0, kScreenWidth-2*kSpace-30-10, 44)];
        _commentText.placeholder = @"Say somthing...";
        _commentText.inputAccessoryView  = _chatInputView;
        _commentText.backgroundColor     = [UIColor clearColor];
        _commentText.returnKeyType       = UIReturnKeySend;
        _commentText.delegate            = self;
        _commentText.font                = [UIFont systemFontOfSize:15.0];
        [_chatInputView addSubview:_commentText];
        
        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sendBtn.frame = CGRectMake(kScreenWidth-15-30, 7, 30, 30);
        [sendBtn setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendChatMessage) forControlEvents:UIControlEventTouchUpInside];
        [_chatInputView addSubview:sendBtn];
    }
    [_commentText becomeFirstResponder];
    //让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}

- (void)showCommentText {
    [self createCommentsView];
    
    [_commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
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

//新用户在麦十分钟奖励
- (UIView *)newusersAwardViewWithDate:(NSInteger)date AwardCount:(NSInteger)awardCount {
    if (!_newusersAwardView) {
        
        _newusersAwardView = [[UIView alloc] initWithFrame:CGRectMake(50, (kScreenHeight-375)/2, kScreenWidth-100, 375)];
        _newusersAwardView.backgroundColor = [UIColor whiteColor];
        _newusersAwardView.layer.cornerRadius = kCellSpace;
        _newusersAwardView.layer.masksToBounds = YES;
        [self.view addSubview:_newusersAwardView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:24];
        titleLabel.textColor = k51Color;
        titleLabel.text = @"New User Rewards";
        [titleLabel sizeToFit];
        [_newusersAwardView addSubview:titleLabel];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textColor = k102Color;
        dateLabel.font = [UIFont systemFontOfSize:18];
        switch (date) {
            case 1:dateLabel.text = [NSString stringWithFormat:@"The %ldst day",date];break;
            case 2:dateLabel.text = [NSString stringWithFormat:@"The %ldnd day",date];break;
            case 3:dateLabel.text = [NSString stringWithFormat:@"The %ldrd day",date];break;
            case 4:dateLabel.text = [NSString stringWithFormat:@"The %ldth day",date];break;
            case 5:dateLabel.text = [NSString stringWithFormat:@"The %ldth day",date];break;
            case 6:dateLabel.text = [NSString stringWithFormat:@"The %ldth day",date];break;
            case 7:dateLabel.text = [NSString stringWithFormat:@"The %ldth day",date];break;
                
            default:
                break;
        }
        
        [dateLabel sizeToFit];
        [_newusersAwardView addSubview:dateLabel];
        
        UIImageView *silverImageview = [[UIImageView alloc] init];
        silverImageview.image = [UIImage imageNamed:@"icon-bigsilver"];
        [_newusersAwardView addSubview:silverImageview];
        
        UILabel *awardLabel = [[UILabel alloc] init];
        awardLabel.font = [UIFont systemFontOfSize:24];
        awardLabel.textColor = k51Color;
        awardLabel.text = [NSString stringWithFormat:@"Silver + %ld",awardCount];
        [awardLabel sizeToFit];
        [_newusersAwardView addSubview:awardLabel];
        
        UIButton *reciveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reciveBtn.backgroundColor = kNavColor;
        reciveBtn.layer.cornerRadius = 22;
        reciveBtn.layer.masksToBounds = YES;
        [reciveBtn setTitle:@"RECEIVE" forState:UIControlStateNormal];
        [reciveBtn addTarget:self action:@selector(receiveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_newusersAwardView addSubview:reciveBtn];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(_newusersAwardView.mas_top).offset(25);
            make.centerX.mas_equalTo(_newusersAwardView.mas_centerX);
        }];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(37);
            make.centerX.mas_equalTo(titleLabel.mas_centerX);
        }];
        [silverImageview mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_newusersAwardView.mas_centerX);
            make.top.mas_equalTo(dateLabel.mas_bottom).offset(25);
            make.height.width.equalTo(@85);
        }];
        [awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_newusersAwardView.mas_centerX);
            make.top.mas_equalTo(silverImageview.mas_bottom).offset(30);
        }];
        [reciveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_newusersAwardView.mas_centerX);
            make.bottom.mas_equalTo(_newusersAwardView.mas_bottom).offset(-30);
            make.width.offset(kScreenWidth-100-100);
            make.height.offset(44);
        }];
    }
    return _newusersAwardView;
}

#pragma mark - 获取数据
//心跳
- (void)heartBeatData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/heartbeat" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"heartBeatData:%@",data);
        if ([data[@"status"] integerValue] == 1) {
            
            NSDictionary *dataDic = data[@"data"];
            if ([dataDic isKindOfClass:[NSNull class]] || dataDic == nil) {
                return ;
            }
            NSDictionary *awardDic = data[@"data"][@"checkin_award_info"];
            if (![awardDic isKindOfClass:[NSNull class]] && awardDic != nil) {
                NSInteger count = [awardDic[@"award_count"] integerValue];
                NSInteger date = [awardDic[@"continue_checkin_day_count"] integerValue];
                [self newusersAwardViewWithDate:date AwardCount:count];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

//聊天室实时信息
- (void)roomRealtimeInfomationData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/getChatroomRtInfo" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSLog(@"roomRealtimeInfomationData:%@",data);
            NSDictionary *dic = data[@"data"];
            NSMutableArray *applySpeakersArr = [UserModel mj_objectArrayWithKeyValuesArray:dic[@"applySpeakers"]];
            NSMutableArray *listenersArr = [UserModel mj_objectArrayWithKeyValuesArray:dic[@"listeners"]];
            NSMutableArray *speakerArr = [UserModel mj_objectArrayWithKeyValuesArray:dic[@"speakers"]];
            
            self.chatModel.authUpSpeaker = dic[@"authUpSpeaker"];
            self.chatModel.banSpeakerPostions = dic[@"banSpeakerPostions"];
            if (self.type == 1) {
                self.chatModel.live_count_info = dic[@"countInfo"];
            }else {
                self.chatModel.countInfo = dic[@"countInfo"];
            }
            self.chatModel.playingGame = dic[@"playingGame"];
            self.chatModel.listeners = listenersArr;
            self.chatModel.speakers = speakerArr;
            self.chatModel.applySpeakers = applySpeakersArr;
            
            //监听说话的人存到数组
            [_speakerMarr removeAllObjects];
            for (UserModel *model in speakerArr) {
                if (![_speakerMarr containsObject:model.user_id]) {
                    [_speakerMarr addObject:model.user_id];
                }
            }
            
            //预约排麦
            [_applySpeaksMarr removeAllObjects];
            [_applySpeaksMarr addObjectsFromArray:applySpeakersArr];
            if (_applySpeaksMarr.count == 0) {
                _applyLabel.text = @"";
                _applyLabel.hidden = YES;
            }else {
                _applyLabel.hidden = NO;
                _applyLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_applySpeaksMarr.count];
            }
            
            
            //在线人数
            [_onlineUserArr removeAllObjects];
            [_onlineUserArr addObject:self.chatModel.chatroom.creator_user_info];
            [_onlineUserArr addObjectsFromArray:listenersArr];
            [_onlineUserArr addObjectsFromArray:speakerArr];
            
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
            
            NSInteger onlineCount;
            if (self.type == 1) {
                onlineCount = [self.chatModel.live_count_info[@"online_count"] integerValue];
                _likeCount = [self.chatModel.live_count_info[@"like_count"] integerValue];
            }else {
                onlineCount = [self.chatModel.countInfo[@"online_count"] integerValue];
                _likeCount = [self.chatModel.countInfo[@"like_count"] integerValue];
            }
            
            _topView.onlineLabel.text = [NSString stringWithFormat:@"%ld online",onlineCount];
            _topView.likeLabel.text = [NSString stringWithFormat:@"%ld like",_likeCount];
            [_topView.onlineCollectionview reloadData];
            
            
            for (int i = 0; i < 4; ++i) {
                UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
                [btn setBackgroundImage:[UIImage imageNamed:@"icon-sofa"] forState:UIControlStateNormal];
            }
            
            int index = 0;
            if (self.chatModel.speakers.count > 4) {
                index = 4;
            }else {
                index = (int)self.chatModel.speakers.count;
            }
            for (int i = 0; i < index; ++i) {
                
                if (self.chatModel.speakers.count <= 4) {
                    UserModel *model = self.chatModel.speakers[i];
                    UIButton *btn = (UIButton *)[self.view viewWithTag:100+i];
                    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon-people"]];
                }
            }
            
            if (self.chatModel.speakers.count <= 4) {
                for (UserModel *model in self.chatModel.speakers) {
                    if (self.type != 1 && [model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
                        self.type = 2;
                        [[AccountManager sharedAccountManager].zegoApi startPublishing:model.user_id title:model.name flag:ZEGO_JOIN_PUBLISH];
                    }
                }
            }
        }
             
    } failure:^(NSError *error) {
        
    }];
}

//点赞
- (void)loadHeartData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/likeChatroom" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            _isHeart = YES;
            _likeTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(likeTimeAction) userInfo:nil repeats:YES];
        }
    } failure:^(NSError *error) {
        
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

//发送礼物
- (void)sendGiftDta:(NSString *)key WithShowModel:(LiveGiftShowModel *)showModel{
    
    NSDictionary *dic = @{@"gift_key":key,@"token":[AccountManager sharedAccountManager].token,@"gift_count":@1,@"to_user_id":_usermodel.user_id};
    [DataService postWithURL:@"rest3/v1/Gift/give_gift" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"wallet"];
            _giftView.goldLabel.text = [NSString stringWithFormat:@"%ld",[diction[@"coin_total"] integerValue]];
            _giftView.diamondLabel.text = [NSString stringWithFormat:@"%ld",[diction[@"diamond_total"] integerValue]];
            
            [self sendChatMessage:GIFT WithGiftKey:key];
            if ([showModel.giftModel.type isEqualToString:@"1"]) {
//                [self creatBigAnimateWithImageName:showModel.giftModel.picUrl];
                [_giftAnimateMarr addObject:showModel];
                [self creatBigAnimate];
            }else {
            
                [self.customGiftShow animatedWithGiftModel:showModel];
            }
        }else if ([data[@"status"] integerValue] == 30007) {
            
            [self removeGiftview];
            //余额不足
            UIAlertController *balanceAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Your account balance is not enougn,whether to recharge immediately" preferredStyle:UIAlertControllerStyleAlert];
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
            UIAlertController *balanceAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Your account balance is not enougn, whether to exchange silver coins" preferredStyle:UIAlertControllerStyleAlert];
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

//设置房间权限
- (void)congigureRoomLimit:(NSString *)enterLimimt Password:(NSString *)password Auth:(NSString *)upspeaker{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"chatroom_id":self.chatModel.chatroom.chatroom_id,@"token":[AccountManager sharedAccountManager].token,@"enter_limit":enterLimimt,@"upspeaker_auth_status":upspeaker}];
    
    if (![password isEqualToString:@""]) {
        [dic setObject:password forKey:@"enter_pass"];
    }
    [DataService postWithURL:@"rest3/v1/chatroom/updateChatroomLimit" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == 1) {
            _enterLimitStr = enterLimimt;
            [DataService toastWithMessage:@"Setting Success"];
        }
    } failure:^(NSError *error) {
        
    }];
}

//举报
- (void)reportAndBlackAction {
    UIAlertController *alertController = nil;
    if (IS_PAD) {
        alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Drag into blacklist Or Report" preferredStyle:UIAlertControllerStyleAlert];
    }else {
        alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Drag into blacklist Or Report" preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *black = [UIAlertAction actionWithTitle:@"Drag into blacklist" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSelector:@selector(blackAction) withObject:nil afterDelay:1.0];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reportData:_usermodel.user_id];
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
    [DataService toastWithMessage:@"Operation success"];
}

//获取我关注的用户
- (void)getFollowsUser {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"page":@"1",@"limit":@"1000"};
    [DataService postWithURL:@"rest3/v1/follow/get_star_list" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"star_list"];
            _followsMarr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
        }
    } failure:^(NSError *error) {
        
    }];
}
//关注用户
- (void)followUserData:(NSString *)userID {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"star_user_id":userID};
    [DataService postWithURL:@"rest3/v1/follow/follow" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            [DataService toastWithMessage:@"follow success"];
            [self getFollowsUser];
        }else {
            [DataService toastWithMessage:@"follow error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"follow error"];
    }];
}

//同意申请上麦
- (void)agreeUpSpeak {
    
    for (UserModel *model in self.chatModel.speakers) {
        if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
            return;
        }
    }
    //如果人数大于4 就预约上麦
    if (self.chatModel.speakers.count >= 4) {
        for (UserModel *model in _applySpeaksMarr) {
            if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
                return;
            }
        }
        NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
        [DataService postWithURL:@"rest3/v1/Livechatroom/orderSpeaker" type:1 params:dic fileData:nil success:^(id data) {
            if ([data[@"status"] integerValue] == 1) {
                [DataService toastWithMessage:@"Appointment is successful"];
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
        NSDictionary *dic = @{@"chatroom_id":self.chatModel.chatroom.chatroom_id,@"position":@(self.chatModel.speakers.count+1),@"user_id":[AccountManager sharedAccountManager].userID};
        [DataService postWithURL:@"rest3/v1/Livechatroom/upSpeakerByUserID" type:1 params:dic fileData:nil success:^(id data) {
            if ([data[@"status"] integerValue] == 1) {
                
                [self roomRealtimeInfomationData];
                [DataService toastWithMessage:@"Wheat success"];
                NSDictionary *dic = @{@"name":@"JOIN_MC",@"num":@(self.chatModel.speakers.count+1)};
                NSString *jsonStr = [dic dictionaryToJsonString];
                [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:JOIN_MC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                    
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 点击事件
//关注房间
- (void)followBtnAction {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Chatroom/likeChatroom" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == 1) {
            //关注成功
            _topView.followBtn.hidden = YES;
        }else {
            [DataService toastWithMessage:@"Follow Error"];
        }
    } failure:^(NSError *error) {
        
    }];
}
//房间内在线的人列表
- (void)moreBtnAction {
    
    _removeUserlistviewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_removeUserlistviewControl addTarget:self action:@selector(removeUsertlistViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeUserlistviewControl];
    
    [self.view addSubview:self.userListBgView];
    [self roomRealtimeInfomationData];
    [UIView animateWithDuration:.35 animations:^{
        _userListBgView.top = 100;
    }];
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

//弹出键盘
- (void)showTextField {
    if (_chatInputView) {
        [_chatInputView removeFromSuperview];
        _chatInputView = nil;
    }
    if (_commentText) {
        [_commentText removeFromSuperview];
        _commentText = nil;
    }
    //这里是为了防止连续点击
    [self showCommentText];
}

//隐藏键盘
- (void)hideKeyboard {
    [_commentText resignFirstResponder];
    _commentText.text = @"";
}

//禁麦或者查看个人资料
- (void)forbidenPositionAndUserinfo:(UIButton *)sender {
    
    if (sender.tag-99 > self.chatModel.speakers.count) {
        if (self.type != 1) {
            [self voiceBtnAction];
        }
        /*
        if (self.type == 1) {
            NSDictionary *dic =@{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id,@"position":@(sender.tag-99)};
            [DataService postWithURL:@"rest3/v1/Livechatroom/banSpeakerPosition" type:1 params:dic fileData:nil success:^(id data) {
                if ([data[@"status"] integerValue] == 1) {
                    [DataService toastWithMessage:@"Banned wheat success"];
                }
            } failure:^(NSError *error) {
                
            }];
        }
         */
        return;
    }
    _usermodel = self.chatModel.speakers[sender.tag-100];
    if (self.type == 1) {
        [self creatProfileCadView:YES height:350 withModel:_usermodel];
        [_profileCardView.inviteBtn setBackgroundImage:[UIImage imageNamed:@"button-cancelspeaking"] forState:UIControlStateNormal];
        _profileCardView.leftLabel.text = @"Cancel Speaking";
        
        [_profileCardView.inviteBtn removeTarget:self action:@selector(inviteToTalkAction) forControlEvents:UIControlEventTouchUpInside];
        [_profileCardView.inviteBtn addTarget:self action:@selector(kickDownSpeakAction) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        [self creatProfileCadView:NO height:300 withModel:_usermodel];
    }
}

//查看主播
- (void)userProfile {
    _usermodel = self.chatModel.chatroom.creator_user_info;
    [self creatProfileCadView:NO height:300 withModel:_usermodel];
}

//个人资料卡
- (void)creatProfileCadView:(BOOL)ishost height:(CGFloat)h withModel:(UserModel *)model{
    
    if (!_removeProfileControl) {
        _removeProfileControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [_removeProfileControl addTarget:self action:@selector(removeProfileViewAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_removeProfileControl];
    }
    for (UserModel *follow in _followsMarr) {
        if ([follow.user_id isEqualToString:model.user_id]) {
            model.has_follow = YES;
            break;
        }
    }
    if (!_profileCardView) {
        _profileCardView = [[ProfileCardView alloc] initWithFrame:CGRectMake((kScreenWidth-300)/2, (kScreenHeight-h)/2, 300, h) withModel:model type:ishost];
        [_profileCardView.reportBtn addTarget:self action:@selector(reportAndBlackAction) forControlEvents:UIControlEventTouchUpInside];
        [_profileCardView.closeBtn addTarget:self action:@selector(removeProfileViewAction) forControlEvents:UIControlEventTouchUpInside];
        [_profileCardView.sendGiftBtn addTarget:self action:@selector(profileViewSendGift) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileAction)];
        [_profileCardView.iconImageView addGestureRecognizer:tap];
        
        UIButton *btn = (UIButton *)[_profileCardView viewWithTag:211];
        [btn addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.type == 1) {
            [_profileCardView.inviteBtn addTarget:self action:@selector(inviteToTalkAction) forControlEvents:UIControlEventTouchUpInside];
            [_profileCardView.kickedoutBtn addTarget:self action:@selector(kickedOutAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.chatModel.speakers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UserModel *userModel = (UserModel *)obj;
                if ([userModel.user_id isEqualToString:model.user_id]) {
                    *stop = YES;
                    if (*stop == YES) {
                        [_profileCardView.inviteBtn setImage:[UIImage imageNamed:@"button-cancelspeaking"] forState:UIControlStateNormal];
                        _profileCardView.leftLabel.text = @"Cancel Speaking";
                        [_profileCardView.inviteBtn removeTarget:self action:@selector(inviteToTalkAction) forControlEvents:UIControlEventTouchUpInside];
                        [_profileCardView.inviteBtn addTarget:self action:@selector(kickDownSpeakAction) forControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }];
        }
        [self.view addSubview:_profileCardView];
    }
}

//移除个人资料卡
- (void)removeProfileViewAction {
    if (_removeProfileControl) {
        [_removeProfileControl removeFromSuperview];
        _removeProfileControl = nil;
    }
    if (_profileCardView) {
        [_profileCardView removeFromSuperview];
        _profileCardView = nil;
    }
    
}

//查看资料
- (void)profileAction {
    
    ProfileViewController *proVC = [[ProfileViewController alloc] init];
    proVC.type = 2;
    proVC.uid = _usermodel.user_id;
    [self.navigationController pushViewController:proVC animated:YES];
}

//关注用户
- (void)followUser {
    [self removeProfileViewAction];
    [self followUserData:_usermodel.user_id];
}

//上麦
- (void)voiceBtnAction {
    for (UserModel *model in self.chatModel.speakers) {
        if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
            return;
        }
    }
    //如果在麦人数大于4 就预约
    if (self.chatModel.speakers.count >= 4) {
        
        for (UserModel *model in _applySpeaksMarr) {
            if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
                return;
            }
        }
        
        NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
        [DataService postWithURL:@"rest3/v1/Livechatroom/orderSpeaker" type:1 params:dic fileData:nil success:^(id data) {
            if ([data[@"status"] integerValue] == 1) {
                [DataService toastWithMessage:@"Appointment is successful"];
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
     
        NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id,@"position":@(self.chatModel.speakers.count+1)};
        [DataService postWithURL:@"rest3/v1/Livechatroom/upSpeaker" type:1 params:dic fileData:nil success:^(id data) {
            if ([data[@"status"] integerValue] == 1) {
                
                [self roomRealtimeInfomationData];
                [DataService toastWithMessage:@"Wheat success"];
                
                NSDictionary *dic = @{@"name":@"JOIN_MC",@"num":@(self.chatModel.speakers.count+1)};
                NSString *jsonStr = [dic dictionaryToJsonString];
                [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:JOIN_MC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                    
                }];
            }else if ([data[@"status"] integerValue] == 50007) {
                UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
                NSDictionary *dic = @{@"name":@"REQUEST_MC",@"num":@"",@"uid":model.user_id,@"toUserName":model.name};
                NSString *jsonStr = [dic dictionaryToJsonString];
                [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:REQUEST_MIC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                    if (errorCode == 0) {
                        [DataService toastWithMessage:@"Request success"];
                    }
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

//主持人邀请某人上麦
- (void)inviteToTalkAction {
    NSLog(@"邀请上麦");
    [self removeProfileViewAction];
    
    NSDictionary *dic = @{@"name":@"INVITE_MC",@"num":@(self.chatModel.speakers.count+1),@"uid":_usermodel.user_id};
    NSString *jsonStr = [dic dictionaryToJsonString];
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:INVITE_MC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        if (errorCode == 0) {
            [DataService toastWithMessage:@"Invite success"];
        }
    }];
}
//踢下麦
- (void)kickDownSpeakAction {
    NSLog(@"下麦");
    [self removeProfileViewAction];
    NSDictionary *dic = @{@"name":@"BEOUT_MC",@"num":_usermodel.position,@"uid":_usermodel.user_id};
    NSString *jsonStr = [dic dictionaryToJsonString];
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:BEOUT_MC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        if (errorCode == 0) {
            [self roomRealtimeInfomationData];
            [DataService toastWithMessage:@"Operation success"];
        }
    }];
}

//主动下麦
- (void)downSpeakerAction:(NSInteger)uid {
    
    [[AccountManager sharedAccountManager].zegoApi stopPublishing];
    [self.chatModel.speakers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UserModel *userModel = (UserModel *)obj;
        if ([userModel.user_id integerValue] == uid) {
            *stop = YES;
            if (*stop == YES) {
                _usermodel = userModel;
            }
        }
    }];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id,@"position":_usermodel.position};
    [DataService postWithURL:@"rest3/v1/Livechatroom/offSpeaker" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            
            [self roomRealtimeInfomationData];
            
            self.type = 3;
            [self removeLimitViewAction];
            
            NSDictionary *dic = @{@"name":@"OUTMC",@"num":_usermodel.position,@"uid":_usermodel.user_id};
            NSString *jsonStr = [dic dictionaryToJsonString];
            [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:OUTMC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                if (errorCode == 0) {

//                    [DataService toastWithMessage:@"Operation success"];
                }
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

//踢出房间
- (void)kickedOutAction {
    NSLog(@"踢出房间");
    [self removeProfileViewAction];
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id,@"kicked_user_id":_usermodel.user_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/kickoutChatroom" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *dic = @{@"name":@"ROOM_KICKEDOUT",@"num":@"",@"uid":_usermodel.user_id};
            NSString *jsonStr = [dic dictionaryToJsonString];
            [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:ROOM_KICKEDOUT priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                if (errorCode == 0) {
                    [self roomRealtimeInfomationData];
                    [DataService toastWithMessage:@"Operation success"];
                }
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

//点赞
- (void)heartBtnAction {
    
    [self praiseAnimation];
    if (_isHeart == NO) {
        [self loadHeartData];
        [self sendChatMessage:LIKE WithGiftKey:nil];
    }
}

//功能按钮
- (void)menuBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 151:
            {//关闭
                _closeAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Whether to leave the current room" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"YES", nil];
                [_closeAlertView show];
            }
            break;
        case 152:
        {//更多
            
            [self creatLimitView:sender];
            
        }
            break;
        case 153:
        {//如果是主持人就是骰子,如果是普通用户就是礼物
            if (self.type == 1) {
                //骰子
                sender.userInteractionEnabled = NO;
                [self showDice];
            }else {
                //礼物
                _usermodel = self.chatModel.chatroom.creator_user_info;
                [self sendGiftView];
                [self loadWalletData];
            }
        }
            break;
        case 154:
        {//礼物
            _usermodel = self.chatModel.chatroom.creator_user_info;
            [self sendGiftView];
            [self loadWalletData];
        }
            break;
            
        default:
            break;
    }
}

//显示骰子
- (void)showDice {
    [self loadDiceAnimate:_centerView.iconView];
    for (int i = 0; i < self.chatModel.speakers.count; ++i) {
        UIImageView *bgview = (UIImageView *)[self.view viewWithTag:105+i];
        [self loadDiceAnimate:bgview];
    }
    if (self.type == 1) {
        NSDictionary *dic = @{@"name":@""};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:DICE_PLAY priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            
        }];
    }
}
//创建更多功能视图
- (void)creatLimitView:(UIButton *)sender {
    _removeLimitViewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_removeLimitViewControl addTarget:self action:@selector(removeLimitViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_removeLimitViewControl];
    
    CGFloat h;
    if (self.type == 1 || self.type == 2) {
        h = 175;
    }else {
        h = 175/2; 
    }
    //type 1主持人 2上麦 3普通用户
    _limitView = [[RoomLimitImageView alloc] initWithFrame:CGRectMake(15, kScreenHeight, kScreenWidth - 30, h) Type:self.type Speaker:_isSpeaker Mute:_isMute];
    [self.view addSubview:_limitView];
    [UIView animateWithDuration:.35 animations:^{
        _limitView.top = sender.top-2*kSpace-h;
    }];
    
    for (int i = 0; i < 4; ++i) {
        UIButton *btn = (UIButton *)[_limitView viewWithTag:250+i];
        [btn addTarget:self action:@selector(limtBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//个人资料卡 送礼物
- (void)profileViewSendGift {
    
    [self sendGiftView];
}

//发送礼物视图
- (void)sendGiftView {
    
    [_giftView.iconView sd_setImageWithURL:[NSURL URLWithString:_usermodel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
    _giftView.destinationLabel.text = [NSString stringWithFormat:@"Give:%@",_usermodel.name];
    [self removeProfileViewAction];
    [UIView animateWithDuration:.35 animations:^{
        _giftView.alpha = 1;
        if (IS_IPHONE_X) {
            _giftView.bottom = kScreenHeight-30;
        }else {
            _giftView.bottom = kScreenHeight;
        }
    }completion:^(BOOL finished) {
        _removeGiftviewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - _giftView.height)];
        _removeGiftviewControl.backgroundColor = [UIColor clearColor];
        [_removeGiftviewControl addTarget:self action:@selector(removeGiftview) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_removeGiftviewControl];
    }];
}

//发送礼物事件
- (void)sendGift:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = (UIView *)tap.view;
    
    UserModel *usermodel = [WYFileManager getCustomObjectWithKey:@"userModel"];
    GiftModel *giftModel = [AccountManager sharedAccountManager].giftModelMarr[view.tag-500];
    
#pragma mark - 更改礼物type
    NSDictionary *giftDic = @{@"picUrl":giftModel.gift_image_key,@"type":giftModel.type};
    NSDictionary *userDic = @{@"name":usermodel.name,@"iconUrl":usermodel.image,@"toName":_usermodel.name,@"toIconUrl":_usermodel.image};
    LiveGiftShowModel *showModel = [LiveGiftShowModel giftModel:giftDic userModel:userDic];
    [self sendGiftDta:giftModel.gift_key WithShowModel:showModel];
}

//移除礼物视图
- (void)removeGiftview {
    [UIView animateWithDuration:.35 animations:^{
        _giftView.top = kScreenHeight;
        _giftView.alpha = 0;
    } completion:^(BOOL finished) {
        if (_removeGiftviewControl) {
            [_removeGiftviewControl removeFromSuperview];
            _removeGiftviewControl = nil;
        }
    }];
}

//选择要送礼物的人
- (void)choiceUser {
    [self moreBtnAction];
}

//房间权限按钮
- (void)limtBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 250:
            {
                if (self.type == 1) {
                    [self removeLimitViewAction];
                    [self creatLimitSheet];
                }else if (self.type == 2) {
                    //下麦
                     [self downSpeakerAction:[[AccountManager sharedAccountManager].userID integerValue]];
                }else {
                    //上麦
                    [self voiceBtnAction];
                }
            }
            break;
        case 251:
        {
            //主持人房间设置
            if (self.type == 1) {
                [DataService changeReturnButton:self];
                
                RoomSettingViewController *settingVC = [[RoomSettingViewController alloc] init];
                [self.navigationController pushViewController:settingVC animated:YES];
            }else {
                UILabel *label = (UILabel *)[_limitView viewWithTag:261];
                if (_isSpeaker == NO) {
                    _isSpeaker = YES;
                    label.text = @"Hands-Free:Yes";
                    [sender setImage:[UIImage imageNamed:@"button-hands-freeno"] forState:UIControlStateNormal];
                }else {
                    _isSpeaker = NO;
                    label.text = @"Hands-Free:No";
                    [sender setImage:[UIImage imageNamed:@"button-hands-free"] forState:UIControlStateNormal];
                }
                [[AccountManager sharedAccountManager].zegoApi setBuiltInSpeakerOn:!_isSpeaker];
            }
            
        }
            break;
        case 252:
        {
            if (self.type == 1) {
                UILabel *label = (UILabel *)[_limitView viewWithTag:262];
                //主持人 扬声器
                if (_isSpeaker == NO) {
                    _isSpeaker = YES;
                    label.text = @"Hands-Free:Yes";
                    [sender setImage:[UIImage imageNamed:@"button-hands-freeno"] forState:UIControlStateNormal];
                }else {
                    _isSpeaker = NO;
                    label.text = @"Hands-Free:No";
                    [sender setImage:[UIImage imageNamed:@"button-hands-free"] forState:UIControlStateNormal];
                }
                [[AccountManager sharedAccountManager].zegoApi setBuiltInSpeakerOn:!_isSpeaker];
            }else if (self.type == 2) {
                UILabel *label = (UILabel *)[_limitView viewWithTag:262];
                if (_isMute == NO) {
                    _isMute = YES;
                    label.text = @"Mute:ON";
                    [sender setImage:[UIImage imageNamed:@"button-onwheat"] forState:UIControlStateNormal];
                }else {
                    _isMute = NO;
                    label.text = @"Mute:OFF";
                    [sender setImage:[UIImage imageNamed:@"button-microphone"] forState:UIControlStateNormal];
                }
                [[AccountManager sharedAccountManager].zegoApi enableMic:!_isMute];
            }
            
        }
            break;
        case 253:
        {
            //主持人麦克风
            UILabel *label = (UILabel *)[_limitView viewWithTag:263];
            if (_isMute == NO) {
                _isMute = YES;
                label.text = @"Mute:ON";
                [sender setImage:[UIImage imageNamed:@"button-onwheat"] forState:UIControlStateNormal];
            }else {
                _isMute = NO;
                label.text = @"Mute:OFF";
                [sender setImage:[UIImage imageNamed:@"button-microphone"] forState:UIControlStateNormal];
            }
            [[AccountManager sharedAccountManager].zegoApi enableMic:!_isMute];
        }
            break;
            
        default:
            break;
    }
}

//创建actionsheet
- (void)creatLimitSheet {
    
    UIButton *sender = (UIButton *)[self.view viewWithTag:151];
    
    //弹出UIactionSheet 举报 如果已关注就取消关注
    UIAlertController *actionSheetController = nil;
    if (IS_PAD) {
        actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    }else {
        actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *button1 = [UIAlertAction actionWithTitle:@"There are no restrictions" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self congigureRoomLimit:@"all" Password:_pasStr Auth:_isAuth];
    }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"Only friends enter" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self congigureRoomLimit:@"friend" Password:@"" Auth:_isAuth];
    }];
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"Use password for enter" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"Enter password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Please enter password";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.delegate = self;
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *passTF = passAlert.textFields.firstObject;
            passTF.keyboardType = UIKeyboardTypeNumberPad;
            if ([passTF.text isEqualToString:@""]) {
                [DataService toastWithMessage:@"Password cannot be empty"];
                return ;
            }
            if (passTF.text.length != 6) {
                [DataService toastWithMessage:@"Please enter the six password"];
                return;
            }
            if ([self isNum:passTF.text] == NO) {
                [DataService toastWithMessage:@"Password can only be digital"];
                return;
            }
            _pasStr = passTF.text;
            _enterLimitStr = @"password";
            [self congigureRoomLimit:_enterLimitStr Password:_pasStr Auth:_isAuth];
            
        }];
        [passAlert addAction:cancel];
        [passAlert addAction:ok];
        [self presentViewController:passAlert animated:YES completion:nil];
    }];
    UIAlertAction *button4 = [UIAlertAction actionWithTitle:@"Into the microphone need to congirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if ([_isAuth isEqualToString:@"0"]) {
            _isAuth = @"1";
        }else {
            _isAuth = @"0";
        }
        [self congigureRoomLimit:_enterLimitStr Password:_pasStr Auth:_isAuth];
        
    }];
    
    [button1 setValue:k102Color forKey:@"_titleTextColor"];
    [button2 setValue:k102Color forKey:@"_titleTextColor"];
    [button3 setValue:k102Color forKey:@"_titleTextColor"];
    [button4 setValue:k102Color forKey:@"_titleTextColor"];

    // 添加响应方式
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:button1];
    [actionSheetController addAction:button2];
    [actionSheetController addAction:button3];
    [actionSheetController addAction:button4];
    
    // 显示
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

//移除房间权限设置视图
- (void)removeLimitViewAction {
    [UIView animateWithDuration:.35 animations:^{
        _limitView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [_limitView removeFromSuperview];
        _limitView = nil;
        [_removeLimitViewControl removeFromSuperview];
        _removeLimitViewControl = nil;
    }];
}

//骰子动画
- (void)loadDiceAnimate:(UIView *)view {
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"chat_room_dice_anim_1"],
                         [UIImage imageNamed:@"chat_room_dice_anim_2"],
                         [UIImage imageNamed:@"chat_room_dice_anim_3"],
                         [UIImage imageNamed:@"chat_room_dice_anim_4"],
                         [UIImage imageNamed:@"chat_room_dice_anim_5"],
                         [UIImage imageNamed:@"chat_room_dice_anim_6"],
                         [UIImage imageNamed:@"chat_room_dice_anim_7"],
                         [UIImage imageNamed:@"chat_room_dice_anim_8"]
                         ,nil];
    
    switch (view.tag) {
        case 104:
        {
            _hostDiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
            _hostDiceImage.animationImages = myImages;
            _hostDiceImage.animationDuration = 1;
            [_hostDiceImage startAnimating];
            [self.view addSubview:_hostDiceImage];
            
            _hostSpin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            [_hostSpin setToValue: [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI*2 ,1.0,1.0, 1.0)]];
            [_hostSpin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
            [_hostSpin setDuration:4];
            [_hostSpin setDelegate:self];
            [_hostSpin setValue:@"host" forKey:@"AnimationKey"];
            [_hostDiceImage.layer addAnimation:_hostSpin forKey:@"rotation"];
            
            [_hostDiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.offset(60);
                make.height.offset(60);
            }];
        }
            break;
        case 105:
        {
            _diceImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
            _diceImage1.animationImages = myImages;
            _diceImage1.animationDuration = 1;
            [_diceImage1 startAnimating];
            [self.view addSubview:_diceImage1];
            
            _spin1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            [_spin1 setToValue: [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI*2 ,1.0,1.0, 1.0)]];
            [_spin1 setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
            [_spin1 setDuration:4];
            [_spin1 setDelegate:self];
            [_spin1 setValue:@"1" forKey:@"AnimationKey"];
            [_diceImage1.layer addAnimation:_spin1 forKey:@"rotation"];
            [_diceImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.offset(60);
                make.height.offset(60);
            }];
        }
            break;
        case 106:
        {
            _diceImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
            _diceImage2.animationImages = myImages;
            _diceImage2.animationDuration = 1;
            [_diceImage2 startAnimating];
            [self.view addSubview:_diceImage2];
            
            _spin2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            [_spin2 setToValue: [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI*2 ,1.0,1.0, 1.0)]];
            [_spin2 setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
            [_spin2 setDuration:4];
            [_spin2 setDelegate:self];
            [_spin2 setValue:@"2" forKey:@"AnimationKey"];
            [_diceImage2.layer addAnimation:_spin2 forKey:@"rotation"];
            [_diceImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.offset(60);
                make.height.offset(60);
            }];
        }
            break;
        case 107:
        {
            _diceImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
            _diceImage3.animationImages = myImages;
            _diceImage3.animationDuration = 1;
            [_diceImage3 startAnimating];
            [self.view addSubview:_diceImage3];
            
            _spin3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            [_spin3 setToValue: [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI*2 ,1.0,1.0, 1.0)]];
            [_spin3 setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
            [_spin3 setDuration:4];
            [_spin3 setDelegate:self];
            [_spin3 setValue:@"3" forKey:@"AnimationKey"];
            [_diceImage3.layer addAnimation:_spin3 forKey:@"rotation"];
            [_diceImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.offset(60);
                make.height.offset(60);
            }];
        }
            break;
        case 108:
        {
            _diceImage4 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
            _diceImage4.animationImages = myImages;
            _diceImage4.animationDuration = 1;
            [_diceImage4 startAnimating];
            [self.view addSubview:_diceImage4];
            
            _spin4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            [_spin4 setToValue: [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI*2 ,1.0,1.0, 1.0)]];
            [_spin4 setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
            [_spin4 setDuration:4];
            [_spin4 setDelegate:self];
            [_spin4 setValue:@"4" forKey:@"AnimationKey"];
            [_diceImage4.layer addAnimation:_spin4 forKey:@"rotation"];
            [_diceImage4 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerX.mas_equalTo(view.mas_centerX);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.offset(60);
                make.height.offset(60);
            }];
        }
            break;
            
        default:
            break;
    }
}

//筛子刷新
- (void)refreshDice {
    if (self.type == 1) {
        NSDictionary *dic = @{@"name":@""};
        NSString *json = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:json type:ZEGO_TEXT category:DICE_PLAY priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            
        }];
    }
    [self closeDice];
    [self showDice];
}
//筛子关闭
- (void)closeDice {
    UIButton *btn = [self.view viewWithTag:153];
    btn.userInteractionEnabled = YES;
    if (_refreshBtn) {
        [_refreshBtn removeFromSuperview];
        _refreshBtn = nil;
    }
    if (_closeBtn) {
        [_closeBtn removeFromSuperview];
        _closeBtn = nil;
    }
    
    if (_hostDiceImage) {
        [_hostDiceImage removeFromSuperview];
        _hostDiceImage = nil;
    }
    if (_diceImage1) {
        [_diceImage1 removeFromSuperview];
        _diceImage1 = nil;
    }
    if (_diceImage2) {
        [_diceImage2 removeFromSuperview];
        _diceImage2 = nil;
    }
    if (_diceImage3) {
        [_diceImage3 removeFromSuperview];
        _diceImage3 = nil;
    }
    if (_diceImage4) {
        [_diceImage4 removeFromSuperview];
        _diceImage4 = nil;
    }
    if (self.type == 1) {
        NSDictionary *dic = @{@"name":@""};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:DICE_GONE priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            
        }];
    }
}

- (void)sendChatMessage {
    [self sendChatMessage:CHAT WithGiftKey:nil];
}

//发送消息
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
    
    if (type == CHAT) {
        dic = @{@"name":_commentText.text,@"num":model.active_lv,@"gender":model.gender};
    }else if (type == GIFT) {
        dic = @{@"name":giftKey,@"num":@"1",@"mainHeadImg":model.image,@"uid":_usermodel.user_id,@"toUserName":_usermodel.name,@"toHeadImg":_usermodel.image,@"type":gift_type};
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
            [_commonMsgMarr addObject:model];
            [self refreshCommonChatMsg];
            [self hideKeyboard];
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

//接受到主持人上麦邀请
- (void)reciveInviteWheatWithModel:(MessageModel *)model {
    
    if ([[AccountManager sharedAccountManager].userID integerValue] == model.content.uid) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"On wheat invitation" message:@"The host invited you to the wheat" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"Refuse" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UserModel *usermodel = [WYFileManager getCustomObjectWithKey:@"userModel"];
            
            NSDictionary *dic = @{@"name":@"REFUSE_MC",@"num":@(model.content.num),@"uid":usermodel.user_id,@"toUserName":usermodel.name};
            NSString *jsonStr = [dic dictionaryToJsonString];
            [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:INVITE_MC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                if (errorCode == 0) {
                    [DataService toastWithMessage:@"Refuse success"];
                }
            }];
        }];
        
        UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [self voiceBtnAction];
        }];
        
        [alert addAction:refuseAction];
        [alert addAction:acceptAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//接到用户上麦的申请
- (void)reciveUserRequestMC:(MessageModel *)messageModel {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"On wheat invitation" message:[NSString stringWithFormat:@"Received %@'s application for wheat",messageModel.content.toUserName] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *refuseAction = [UIAlertAction actionWithTitle:@"Refuse" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic = @{@"name":@"REFUSE_MC",@"num":@"",@"uid":messageModel.fromUserId};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:REQUEST_MIC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            if (errorCode == 0) {
                [DataService toastWithMessage:@"Refuse success"];
            }
        }];
    }];
    
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"Agree" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic = @{@"name":@"AGREE_MC",@"num":@"",@"uid":messageModel.fromUserId};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:REQUEST_MIC priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            if (errorCode == 0) {
                [DataService toastWithMessage:@"Agree success"];
            }
        }];
    }];
    
    [alert addAction:refuseAction];
    [alert addAction:acceptAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//收到在线十分钟奖励
- (void)receiveBtnAction {
    if (_newusersAwardView) {
        [_newusersAwardView removeFromSuperview];
        _newusersAwardView = nil;
    }
}

//添加背景音乐
- (void)shareMusicAction {
    [self.navigationController pushViewController:_musicVC animated:YES];
}

- (void)reportRoomAction:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Report chatRoom" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self reportData:self.chatModel.chatroom.creator_user_id];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    if (IS_PAD) {
        UIPopoverPresentationController *controller = [alertController popoverPresentationController];
        controller.sourceView = sender;
        controller.sourceRect = sender.bounds;
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)rechargeBtnAction {
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self removeGiftview];
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
    _usermodel = _onlineUserArr[indexPath.row];
    if (self.type == 1) {
        [self creatProfileCadView:YES height:350 withModel:_usermodel];
    }else {
        [self creatProfileCadView:NO height:300 withModel:_usermodel];
    }
}

#pragma - mark delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    CABasicAnimation *animation = (CABasicAnimation *)anim;
    
    if ([[animation valueForKey:@"AnimationKey"] isEqualToString:@"host"] && self.type == 1) {
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"dice"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeDice) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeBtn];
        
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn setImage:[UIImage imageNamed:@"Refresh"] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(refreshDice) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_refreshBtn];
        
        [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_centerView.iconView.mas_left).offset(kSpace);
            make.centerY.mas_equalTo(_centerView.iconView.mas_top).offset(kSpace);
            make.width.offset(30);
            make.height.offset(30);
        }];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(_centerView.iconView.mas_right).offset(-kSpace);
            make.centerY.mas_equalTo(_centerView.iconView.mas_top).offset(kSpace);
            make.width.offset(30);
            make.height.offset(30);
        }];
    }
    if (self.type == 1) {
        [_hostDiceImage stopAnimating];
        [_diceImage1 stopAnimating];
        [_diceImage2 stopAnimating];
        [_diceImage3 stopAnimating];
        [_diceImage4 stopAnimating];
        [self diceResult:nil];
    }
}

- (void)diceResult:(NSArray *)arr {
    
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    int result = (rand() % 5) +1;  //产生1～6的数
    if (self.type != 1) {
        result = [arr[4] intValue];
    }
    switch (result) {
        case 1:_hostDiceImage.image = [UIImage imageNamed:@"chat_room_dice_game_result_1"];break;
        case 2:_hostDiceImage.image = [UIImage imageNamed:@"chat_room_dice_game_result_2"];break;
        case 3:_hostDiceImage.image = [UIImage imageNamed:@"chat_room_dice_game_result_3"];break;
        case 4:_hostDiceImage.image = [UIImage imageNamed:@"chat_room_dice_game_result_4"];break;
        case 5:_hostDiceImage.image = [UIImage imageNamed:@"chat_room_dice_game_result_5"];break;
        case 6:_hostDiceImage.image = [UIImage imageNamed:@"chat_room_dice_game_result_6"];break;
    }
    
    int result1 = (rand() % 5) +1 ;  //产生1～6的数
    if (self.type != 1) {
        result1 = [arr[0] intValue];
    }
    switch (result1) {
        case 1:_diceImage1.image = [UIImage imageNamed:@"chat_room_dice_game_result_1"];break;
        case 2:_diceImage1.image = [UIImage imageNamed:@"chat_room_dice_game_result_2"];break;
        case 3:_diceImage1.image = [UIImage imageNamed:@"chat_room_dice_game_result_3"];break;
        case 4:_diceImage1.image = [UIImage imageNamed:@"chat_room_dice_game_result_4"];break;
        case 5:_diceImage1.image = [UIImage imageNamed:@"chat_room_dice_game_result_5"];break;
        case 6:_diceImage1.image = [UIImage imageNamed:@"chat_room_dice_game_result_6"];break;
    }
    
    int result2 = (rand() % 5) +1 ;  //产生1～6的数
    if (self.type != 1) {
        result2 = [arr[1] intValue];
    }
    switch (result2) {
        case 1:_diceImage2.image = [UIImage imageNamed:@"chat_room_dice_game_result_1"];break;
        case 2:_diceImage2.image = [UIImage imageNamed:@"chat_room_dice_game_result_2"];break;
        case 3:_diceImage2.image = [UIImage imageNamed:@"chat_room_dice_game_result_3"];break;
        case 4:_diceImage2.image = [UIImage imageNamed:@"chat_room_dice_game_result_4"];break;
        case 5:_diceImage2.image = [UIImage imageNamed:@"chat_room_dice_game_result_5"];break;
        case 6:_diceImage2.image = [UIImage imageNamed:@"chat_room_dice_game_result_6"];break;
    }
    int result3= (rand() % 5) +1 ;  //产生1～6的数
    if (self.type != 3) {
        result3 = [arr[2] intValue];
    }
    switch (result3) {
        case 1:_diceImage3.image = [UIImage imageNamed:@"chat_room_dice_game_result_1"];break;
        case 2:_diceImage3.image = [UIImage imageNamed:@"chat_room_dice_game_result_2"];break;
        case 3:_diceImage3.image = [UIImage imageNamed:@"chat_room_dice_game_result_3"];break;
        case 4:_diceImage3.image = [UIImage imageNamed:@"chat_room_dice_game_result_4"];break;
        case 5:_diceImage3.image = [UIImage imageNamed:@"chat_room_dice_game_result_5"];break;
        case 6:_diceImage3.image = [UIImage imageNamed:@"chat_room_dice_game_result_6"];break;
    }
    
    int result4 = (rand() % 5) +1 ;  //产生1～6的数
    if (self.type != 4) {
        result4 = [arr[3] intValue];
    }
    switch (result4) {
        case 1:_diceImage4.image = [UIImage imageNamed:@"chat_room_dice_game_result_1"];break;
        case 2:_diceImage4.image = [UIImage imageNamed:@"chat_room_dice_game_result_2"];break;
        case 3:_diceImage4.image = [UIImage imageNamed:@"chat_room_dice_game_result_3"];break;
        case 4:_diceImage4.image = [UIImage imageNamed:@"chat_room_dice_game_result_4"];break;
        case 5:_diceImage4.image = [UIImage imageNamed:@"chat_room_dice_game_result_5"];break;
        case 6:_diceImage4.image = [UIImage imageNamed:@"chat_room_dice_game_result_6"];break;
    }
    if (self.type == 1) {
        _diceResultArr = [NSMutableArray array];
        [_diceResultArr addObject:@(result1)];
        [_diceResultArr addObject:@(result2)];
        [_diceResultArr addObject:@(result3)];
        [_diceResultArr addObject:@(result4)];
        [_diceResultArr addObject:@(result)];
        
        NSDictionary *dic = @{@"name":@"",@"nums":_diceResultArr};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:DICE_STOP priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            
        }];
    }
}

//拉流代理
- (void)onPlayStateUpdate:(int)stateCode streamID:(NSString *)streamID {
    switch (stateCode) {
        case 0:
            //成功
            break;
        case 5:
            //获取信息流失败
            break;
        case 6:
        case 7:
            //连接失败
        {
        }
            break;
        case 8:
            //解析失败
            break;
        case 10:
            //网络连接断开
            [DataService toastWithMessage:@"Network Error"];
            break;
        default:
            break;
    }
}

- (void)onStreamUpdated:(int)type streams:(NSArray<ZegoStream *> *)streamList roomID:(NSString *)roomID {
    
    //自己收不到回调
    ZegoStream *stream = streamList[0];
    if (type == ZEGO_STREAM_ADD) {
        [_streamMarr addObject:stream];
        for (ZegoStream *stream in _streamMarr) {
            NSLog(@"ZegoStream:%@",stream.userName);
            [[AccountManager sharedAccountManager].zegoApi startPlayingStream:stream.streamID inView:nil];
        }
    }else {
        [_streamMarr enumerateObjectsUsingBlock:^(ZegoStream *stre, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([stre.userID isEqualToString:stream.userID]) {
                [_streamMarr removeObject:stream];
            }
        }];
    }
}

- (void)onPlayQualityUpate:(NSString *)streamID quality:(ZegoApiPlayQuality)quality {
//    NSLog(@"音频码率:%f,延时%d,丢包率:%d,直播质量:%d,音频卡顿率:%f",quality.akbps,quality.rtt,quality.pktLostRate,quality.quality,quality.audioBreakRate);
}

//推流代理
- (void)onPublishStateUpdate:(int)stateCode streamID:(NSString *)streamID streamInfo:(NSDictionary *)info {
    NSLog(@"=====publishStatecode:%d========\n========stream:%@=======",stateCode,info);
    ZegoStream *stream = [[ZegoStream alloc] init];
    stream.streamID = streamID;
    stream.userID = [AccountManager sharedAccountManager].userID;
    [_streamMarr addObject:stream];
}

- (void)onPublishQualityUpdate:(NSString *)streamID quality:(ZegoApiPublishQuality)quality {
    
    NSLog(@"音频码率:%f,延时%d,丢包率:%d,直播质量:%d",quality.akbps,quality.rtt,quality.pktLostRate,quality.quality);
}

- (void)onRecvRoomMessage:(NSString *)roomId messageList:(NSArray<ZegoRoomMessage *> *)messageList {
    for (ZegoRoomMessage *message in messageList) {
        NSLog(@"=========category:%d===========",message.category);
        MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
        switch (message.category) {
            case CHAT:
                {
                    [_commonMsgMarr addObject:model];
                    [self refreshCommonChatMsg];
                }
                break;
            case ROOM_LEAVE:
            {
                if ([message.fromUserId isEqualToString:self.chatModel.chatroom.creator_user_id]) {
                    //房间关闭
                    [DataService toastWithMessage:@"Room closed"];
                    [self closeRoom];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self roomRealtimeInfomationData];
                }
            }
                break;
            case ROOM_NAME:
            {
                self.chatModel.chatroom.room_name = model.content.name;
                _topView.nameLabel.text = self.chatModel.chatroom.room_name;
                
            }
                break;
            case ROOM_TYPE:
            {
                if (model.content.name == nil) {
                    _centerView.topicBtn.hidden = YES;
                }else {
                    
                    [_centerView.topicBtn setTitle:model.content.name forState:UIControlStateNormal];
                    [_centerView.topicBtn.titleLabel sizeToFit];
                }
                
            }
                break;
            case ROOM_DESC:
            {
                self.chatModel.chatroom.room_desc = model.content.name;
                _centerView.signatureLabel.text = model.content.name;
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
                NSDictionary *userDic = @{@"name":model.fromUserName,@"iconUrl":model.content.mainHeadImg,@"toName":model.content.toUserName,@"toIconUrl":model.content.toHeadImg};
                LiveGiftShowModel *showModel = [LiveGiftShowModel giftModel:giftDic userModel:userDic];
                if ([type isEqualToString:@"1"]) {
                    [_giftAnimateMarr addObject:showModel];
                    [self creatBigAnimate];
                    
                }else {
                    [self.customGiftShow animatedWithGiftModel:showModel];
                }
            }
                break;
            case LIKE:
            {
                _likeCount += 1;
                _topView.likeLabel.text = [NSString stringWithFormat:@"%ld like",_likeCount];
                [self praiseAnimation];
            }
                break;
            case JOIN_MC:
            {
                [self roomRealtimeInfomationData];
            }
                break;
            case OUTMC:
            {
                if (_applySpeaksMarr.count > 0 && self.chatModel.speakers.count <4) {
                    UserModel *model = _applySpeaksMarr[0];
                    if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
                        [self voiceBtnAction];
                    }else {
                        [self roomRealtimeInfomationData];
                    }
                }else {
                   [self roomRealtimeInfomationData];
                }
                
            }
                break;
            case INVITE_MC:
            {
                MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
                if (self.type == 1 && [model.content.name isEqualToString:@"REFUSE_MC"]) {
                    [DataService toastWithMessage:[NSString stringWithFormat:@"%@ refuse your invitation.",model.content.toUserName]];
                }else {
                    [self reciveInviteWheatWithModel:model];
                }
            }
                break;
            case BEOUT_MC:
            {
                if ([[AccountManager sharedAccountManager].userID integerValue] == model.content.uid) {
                    [[AccountManager sharedAccountManager].zegoApi stopPublishing];
                    [self downSpeakerAction:model.content.uid];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You are kicked down" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }else {
                    if (_applySpeaksMarr.count > 0 && self.chatModel.speakers.count <4) {
                        UserModel *model = _applySpeaksMarr[0];
                        if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
                            [self voiceBtnAction];
                        }else {
                            [self roomRealtimeInfomationData];
                        }
                    }else {
                        [self roomRealtimeInfomationData];
                    }
                }
                
            }
                break;
            case ROOM_KICKEDOUT:
            {
                if ([[AccountManager sharedAccountManager].userID integerValue] == model.content.uid) {
                    
                    [self exitRoom];
                    [DataService toastWithMessage:@"You were kicked out of the room!"];
                }else {
                    if (_applySpeaksMarr.count > 0 && self.chatModel.speakers.count <4) {
                        UserModel *model = _applySpeaksMarr[0];
                        if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
                            [self voiceBtnAction];
                        }else {
                            [self roomRealtimeInfomationData];
                        }
                    }else {
                        [self roomRealtimeInfomationData];
                    }
                }
            }
                break;
            case DICE_SHOW:
            {
                //第一次显示骰子
                [self refreshDice];
            }
            break;
            case DICE_PLAY:
            {
                //重玩
                [self refreshDice];
            }
                break;
            case DICE_GONE:
            {
                //隐藏
                [self closeDice];
            }
                break;
            case DICE_STOP:
            {
                //游戏停止显示结果
                [_hostDiceImage stopAnimating];
                [_diceImage1 stopAnimating];
                [_diceImage2 stopAnimating];
                [_diceImage3 stopAnimating];
                [_diceImage4 stopAnimating];
                _diceResultArr = [NSMutableArray arrayWithArray:model.content.nums];
                NSLog(@"%@",model.content.nums);
                [self diceResult:model.content.nums];
            }
                break;
            case REQUEST_MIC:
            {//收到上麦申请
                if (self.type == 1) {
                    if ([model.content.name isEqualToString:@"REQUEST_MC"]) {
                        [self reciveUserRequestMC:model];
                    }
                }else {
                    if ([model.content.name isEqualToString:@"AGREE_MC"]) {
                        [self agreeUpSpeak];
                    }else if ([model.content.name isEqualToString:@"REFUSE_MC"]) {
                        [DataService toastWithMsg:@"Anchor reject your application"];
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)onUserUpdate:(NSArray<ZegoUserState *> *)userList updateType:(ZegoUserUpdateType)type {
    [self roomRealtimeInfomationData];
    NSLog(@"userupdate");
    for (ZegoUserState *state in userList) {
        if (state.updateFlag == 1) {
            //进入房间 欢迎
//            NSLog(@"%@,%@",state.userID,state.userName);
            if ([state.userID isEqualToString:self.chatModel.chatroom.creator_user_id]) {
                return;
            }
            [self creatWelcomeRoomView:state.userName];
        }else {
            if ([state.userID isEqualToString:self.chatModel.chatroom.creator_user_id]) {
                [DataService toastWithMessage:@"Room closed"];
                [self closeRoom];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self exitRoom];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatView) {
        MessageModel *message = _commonMsgMarr[indexPath.row];
        for (UserModel *model in _onlineUserArr) {
            if ([message.fromUserId isEqualToString:model.user_id] && ![message.fromUserId isEqualToString:[AccountManager sharedAccountManager].userID]) {
                
                _usermodel = model;
                if (self.type == 1) {
                    [self creatProfileCadView:YES height:350 withModel:model];
                }else {
                    [self creatProfileCadView:NO height:300 withModel:model];
                }
            }
        }
    }else if (tableView == _userListTableview) {
        _usermodel = _onlineUserArr[indexPath.row];
        if ([_usermodel.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
            [DataService toastWithMsg:@"Can't choose yourself"];
            return;
        }
        [_giftView.iconView sd_setImageWithURL:[NSURL URLWithString:_usermodel.image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
        _giftView.destinationLabel.text = [NSString stringWithFormat:@"Give:%@",_usermodel.name];
        [self removeUsertlistViewAction];
    }
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

//判断是否为数字
- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _commentText) {
        [self sendChatMessage:CHAT WithGiftKey:nil];
    }else {
        //如果是密码
        
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _commentText) {
        return YES;
    }else {
        if (range.location > 5) {
            return NO;
        }else {
            return YES;
        }
    }
}

//礼物回调
- (void)giftDidRemove:(LiveGiftShowModel *)showModel {
    WLog(@"用户：%@ 送出了 %li 个 %@", showModel.user.name, showModel.currentNumber, showModel.giftModel.name);
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

//点赞定时
- (void)likeTimeAction {
    _isHeart = NO;
}

//创建定时器
- (void)creatTimer {
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.anchorTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(0.5 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.anchorTimer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.anchorTimer, ^{
        if (_streamMarr.count > 0) {
            ZegoStream *sream = _streamMarr[0];
            float value = 0.0;
            if ([[AccountManager sharedAccountManager].userID isEqualToString:sream.userID]) {
                value = [[AccountManager sharedAccountManager].zegoApi getCaptureSoundLevel];
            }else {
                value = [[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:sream.streamID];
            }
            if ( value >= 5) {
                _centerView.voiceImageview.hidden = NO;
                
                [_centerView.voiceImageview startAnimating];
            }else {
                [_centerView.voiceImageview stopAnimating];
                _centerView.voiceImageview.hidden = YES;
            }
        }
    });
    dispatch_resume(self.anchorTimer);
    
    self.firstTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.firstTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.firstTimer, ^{
        if (_speakerMarr.count > 0) {
            
            NSString *uid = _speakerMarr[0];
            float value = 0.0;
            
            for (ZegoStream *stream in _streamMarr) {
                if ([uid isEqualToString:stream.userID]) {
                    
                    if ([[AccountManager sharedAccountManager].userID isEqualToString:stream.userID]) {
                        value = [[AccountManager sharedAccountManager].zegoApi getCaptureSoundLevel];
                    }else {
                        value = [[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID];
                    }
                    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:120];
                    if (value >= 5) {
                        
                        imageView.hidden = NO;
                        [imageView startAnimating];
                    }else {
                        imageView.hidden = YES;
                        [imageView stopAnimating];
                    }
                }
            }
        }
    });
    dispatch_resume(self.firstTimer);
    
    self.secondTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.secondTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.secondTimer, ^{
        if (_speakerMarr.count > 1) {
            NSString *uid = _speakerMarr[1];
            float value = 0.0;
            
            for (ZegoStream *stream in _streamMarr) {
                if ([uid isEqualToString:stream.userID]) {
                    if ([[AccountManager sharedAccountManager].userID isEqualToString:stream.userID]) {
                        value = [[AccountManager sharedAccountManager].zegoApi getCaptureSoundLevel];
                    }else {
                        value = [[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID];
                    }
                    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:121];
                    if ([[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID] >= 5) {
                        
                        imageView.hidden = NO;
                        [imageView startAnimating];
                    }else {
                        imageView.hidden = YES;
                        [imageView stopAnimating];
                    }
                }
            }
        }
    });
    dispatch_resume(self.secondTimer);
    
    self.thirdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.thirdTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.thirdTimer, ^{
        if (_speakerMarr.count > 2) {
            NSString *uid = _speakerMarr[2];
            float value = 0.0;
            
            for (ZegoStream *stream in _streamMarr) {
                if ([uid isEqualToString:stream.userID]) {
                    if ([[AccountManager sharedAccountManager].userID isEqualToString:stream.userID]) {
                        value = [[AccountManager sharedAccountManager].zegoApi getCaptureSoundLevel];
                    }else {
                        value = [[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID];
                    }
                    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:122];
                    if ([[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID] >= 5) {
                        
                        imageView.hidden = NO;
                        [imageView startAnimating];
                    }else {
                        imageView.hidden = YES;
                        [imageView stopAnimating];
                    }
                }
            }
        }
    });
    dispatch_resume(self.thirdTimer);
    
    self.fiouthTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.fiouthTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.fiouthTimer, ^{
        if (_speakerMarr.count > 3) {
            NSString *uid = _speakerMarr[3];
            float value = 0.0;
            for (ZegoStream *stream in _streamMarr) {
                if ([uid isEqualToString:stream.userID]) {
                    if ([[AccountManager sharedAccountManager].userID isEqualToString:stream.userID]) {
                        value = [[AccountManager sharedAccountManager].zegoApi getCaptureSoundLevel];
                    }else {
                        value = [[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID];
                    }
                    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:123];
                    if ([[AccountManager sharedAccountManager].zegoApi getSoundLevelOfStream:stream.streamID] >= 5) {
                        
                        imageView.hidden = NO;
                        [imageView startAnimating];
                    }else {
                        imageView.hidden = YES;
                        [imageView stopAnimating];
                    }
                }
            }
        }
    });
    dispatch_resume(self.fiouthTimer);
}

#pragma mark - notification
- (void)showKeyboardAction:(NSNotificationCenter *)noti {
    
    if (!_hidekeyBoardControl) {
        _hidekeyBoardControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _hidekeyBoardControl.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_hidekeyBoardControl];
        [_hidekeyBoardControl addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    }
}

//键盘将要隐藏
- (void)hideKeyboardAction {
    if (_chatInputView) {
        [_chatInputView removeFromSuperview];
        _chatInputView = nil;
    }
    if (_commentText) {
        [_commentText removeFromSuperview];
        _commentText = nil;
    }
    if (_hidekeyBoardControl) {
        
        [_hidekeyBoardControl removeFromSuperview];
        _hidekeyBoardControl = nil;
    }
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
    
    [self showTextField];
    
    _atNameString = [NSString stringWithFormat:@"@%@\t",name];
    
    if (_commentText.text.length == 0) {
        _commentText.text = _atNameString;
    }else {
        
        NSRange tempRange = [_commentText.text rangeOfRegex:@"@[^@]+\t"];
        if (tempRange.location != NSNotFound && tempRange.location+tempRange.length <= _commentText.text.length) {
            _commentText.text = [_commentText.text stringByReplacingCharactersInRange:tempRange withString:_atNameString];
        }else {
            
            _commentText.text = [_commentText.text stringByAppendingString:_atNameString];
            [self _substringOfInputText];
        }
    }
    _atNameRange = [_commentText.text rangeOfString:_atNameString];
}

- (void)_substringOfInputText {
    
    if ( _commentText.text.length > 14) {
        _commentText.text = [_commentText.text substringToIndex:14];
    }else if ( _commentText.text.length > 30) {
        _commentText.text = [_commentText.text substringToIndex:30];
    }
    
    if (_atNameString) {
        
        NSRange tempRange = [_commentText.text rangeOfString:_atNameString];
        if (tempRange.location == NSNotFound) {
            
            _commentText = nil;
            _atNameRange = NSMakeRange(0, 0);
        }
    }
}
#pragma mark - 动画
- (void)praiseAnimation {
    UIImageView *imageView = [[UIImageView alloc] init];
    CGRect frame = self.view.frame;
    //  初始frame，即设置了动画的起点
    imageView.frame = CGRectMake(_heartBtn.left+15, _heartBtn.top - 30, 30, 30);
    //  初始化imageView透明度为0
    imageView.alpha = 0;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.clipsToBounds = YES;
    //  用0.2秒的时间将imageView的透明度变成1.0，同时将其放大1.3倍，再缩放至1.1倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(_heartBtn.left+15, _heartBtn.top - 30, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self.view addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 100;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    // 随机生成一个0~7的数，以便下面拼接图片名
    int imageName = round(random() % 9)+1;
    
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d.png",imageName]];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
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

- (void)dealloc{
    if (_heartTimer) {
        [_heartTimer invalidate];
        _heartTimer = nil;
    }
    if (_roomRealtimeInfomationTimer) {
        [_roomRealtimeInfomationTimer invalidate];
        _roomRealtimeInfomationTimer = nil;
    }
    [self _invalidateForbiddenScrollTimer];
}
//离开房间
- (void)exitRoom {
    
    NSDictionary *diction = @{@"name":@""};
    NSString *str = [diction dictionaryToJsonString];
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:str type:ZEGO_TEXT category:ROOM_LEAVE priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        
    }];
    
    for (UserModel *model in self.chatModel.speakers) {
        if ([model.user_id isEqualToString:[AccountManager sharedAccountManager].userID]) {
            [self downSpeakerAction:[model.user_id integerValue]];
        }
    }
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"chatroom_id":self.chatModel.chatroom.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/exitChatroom" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
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
    [_likeTimer invalidate];
    _likeTimer = nil;
    
    [_heartTimer invalidate];
    _heartTimer = nil;
    
    [_roomRealtimeInfomationTimer invalidate];
    _roomRealtimeInfomationTimer = nil;
    [self _invalidateForbiddenScrollTimer];
    
    [[AccountManager sharedAccountManager].zegoApi stopPublishing];
    [[AccountManager sharedAccountManager].zegoApi logoutRoom];
    
    if (_giftView) {
        [_giftView removeFromSuperview];
        _giftView = nil;
    }
    [_musicVC.musicTimer invalidate];
    _musicVC.musicTimer = nil;
    [_musicVC removeFromParentViewController];
    _musicVC = nil;
    
    dispatch_cancel(self.anchorTimer);
    dispatch_cancel(self.firstTimer);
    dispatch_cancel(self.secondTimer);
    dispatch_cancel(self.thirdTimer);
    dispatch_cancel(self.fiouthTimer);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zego_onLiveEvent:(ZegoLiveEvent)event info:(NSDictionary<NSString *,NSString *> *)info {
    
}


@end
