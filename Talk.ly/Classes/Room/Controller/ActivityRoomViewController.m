//
//  ActivityRoomViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/3.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ActivityRoomViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import "AccountManager.h"
#import <UIImageView+WebCache.h>
#import <ZegoLiveRoom/ZegoLiveRoom.h>
#import "ActivityModel.h"
#import <MJExtension.h>
#import "QuestionModel.h"
#import "ActivityWaitingView.h"
#import "ChatTableView.h"
#import "UserModel.h"
#import "WYFileManager.h"
#import "MessageModel.h"
#import "NSDictionary+Jsonstring.h"
#import "AnsweringView.h"
#import "AnswerEndView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ActivityRulesViewController.h"

@interface ActivityRoomViewController ()<ZegoIMDelegate,ZegoLivePlayerDelegate,ZegoRoomDelegate,ZegoChatRoomDelegate,ZegoLivePublisherDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDelegate>

@property(nonatomic,strong)NSMutableArray *answerListMarr;
@property(nonatomic,strong)ActivityModel *model;
@property(nonatomic,strong)ActivityWaitingView *waitView;
@property(nonatomic,strong)AnswerEndView *endView;
@property(nonatomic,strong)ChatTableView *chatView;
@property(nonatomic,strong)UIView *startActivityView;
@property(nonatomic,strong)UIView *chatInputView;
@property(nonatomic,strong)UITextField *commentText;
@property(nonatomic,strong)UIControl *hidekeyBoardControl;
@property(nonatomic,strong)NSMutableArray *commonMsgMarr;
@property(nonatomic,strong)UILabel *onlineLabel;
@property(nonatomic,strong)AnsweringView *answeringView;
@property(nonatomic,strong)NSTimer *answerTimer;
@property(nonatomic,strong)NSTimer *publihTimer;
@property(nonatomic,strong)QuestionModel *qmodel;
@property(nonatomic,assign)int isRight;
@property(nonatomic,copy)NSString *choice;
@property(nonatomic,strong)NSMutableArray *userMarr;
@property(nonatomic,assign)BOOL hasLogin;
@property(nonatomic,assign)BOOL hasJoinActivity;
@property(nonatomic,strong)NSMutableArray *resutMarr;
@property(nonatomic,strong)UIControl *answerCoverControl;
@property(nonatomic,assign)BOOL isWatch;
@property(nonatomic,strong)UIButton *privateBtn;


@end


@implementation ActivityRoomViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [DataService changeReturnButton:self];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:bgImageView];
    bgImageView.image = [UIImage imageNamed:@"bg_activity"];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"icon-return"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnActionActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _privateBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-120, 30, 120, 20)];
    [_privateBtn setTitle:@"Official Rules" forState:UIControlStateNormal];
    [_privateBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:.8] forState:UIControlStateNormal];
    [_privateBtn addTarget:self action:@selector(privateBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _privateBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_privateBtn];
    
    _onlineLabel = [[UILabel alloc] init];
    _onlineLabel.font = [UIFont systemFontOfSize:18];
    _onlineLabel.textColor = [UIColor whiteColor];
    _onlineLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-default" bounds:CGRectMake(0, -3, 20, 20) str:@" 0 Online"];
    [_onlineLabel sizeToFit];
    [self.view addSubview:_onlineLabel];
    [_onlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.view.mas_top).offset(60);
    }];
    _onlineLabel.hidden = YES;
    
    _commonMsgMarr = [NSMutableArray array];
    _resutMarr = [NSMutableArray array];
    
    [[AccountManager sharedAccountManager].zegoApi setPublisherDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setIMDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setRoomDelegate:self];    //播放代理
    [[AccountManager sharedAccountManager].zegoApi setPlayerDelegate:self];
    [[AccountManager sharedAccountManager].zegoApi setChatRoomDelegate:self];
    
    [self getCurrentActivityData];
    
}

#pragma mark - 加载UI
- (ActivityWaitingView *)waitView {
    if (!_waitView) {
        
        _waitView = [[ActivityWaitingView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-60)];
        _waitView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_waitView];
    }
    return _waitView;
}

- (void)creatEndView:(NSString *)count bonus:(NSString *)bonus success:(BOOL)success {
    if (!_endView) {
        
        _endView = [[AnswerEndView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-60) withcount:count withbonus:bonus withsuccess:success jackport:_model.jackpot];
        _endView.backgroundColor = [UIColor clearColor];
        [_endView.iconView sd_setImageWithURL:[NSURL URLWithString:_model.header_image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
        [self.view addSubview:_endView];
    }
}

- (UIControl *)answerCoverControl {
    if (!_answerCoverControl) {
        _answerCoverControl = [[UIControl alloc] initWithFrame:_answeringView.bounds];
        _answerCoverControl.backgroundColor = [UIColor clearColor];
        [_answerCoverControl addTarget:self action:@selector(answerCoverControlAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answerCoverControl;
}

- (UIView *)startActivityView {
    if (!_startActivityView) {
        
        _onlineLabel.hidden = NO;
        
        _startActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight-60)];
        _startActivityView.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-150)/2, kSpace, 150, 150)];
        [iconView sd_setImageWithURL:[NSURL URLWithString:_model.header_image] placeholderImage:[UIImage imageNamed:@"icon-people"]];
        iconView.layer.cornerRadius = 75;
        iconView.layer.masksToBounds = YES;
        [_startActivityView addSubview:iconView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = _model.name;
        nameLabel.font = [UIFont systemFontOfSize:24];
        nameLabel.textColor = [UIColor whiteColor];
        [nameLabel sizeToFit];
        [_startActivityView addSubview:nameLabel];
        
        UILabel *questionCountLabel = [[UILabel alloc] init];
        questionCountLabel.textColor = [UIColor whiteColor];
        questionCountLabel.text = @"Answer 12 questions";
        questionCountLabel.font = [UIFont systemFontOfSize:18];
        [questionCountLabel sizeToFit];
        [_startActivityView addSubview:questionCountLabel];
        
        UILabel *shareLabel = [[UILabel alloc] init];
        shareLabel.textColor = [UIColor whiteColor];
        shareLabel.text = [NSString stringWithFormat:@"Share %ld bonuses",(long)_model.jackpot];
        shareLabel.font = [UIFont systemFontOfSize:18];
        [shareLabel sizeToFit];
        [_startActivityView addSubview:shareLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_startActivityView.mas_centerX);
            make.top.mas_equalTo(iconView.mas_bottom).offset(kSpace);
        }];
        [questionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_startActivityView.mas_centerX);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(kSpace);
        }];
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_startActivityView.mas_centerX);
            make.top.mas_equalTo(questionCountLabel.mas_bottom).offset(kSpace);
        }];
        
        _chatView = [[ChatTableView alloc] initWithFrame:CGRectMake(15, shareLabel.bottom+50, kScreenWidth-80-15, 100) style:UITableViewStylePlain];
        _chatView.delegate = self;
        [_startActivityView addSubview:_chatView];
        
        [_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(_startActivityView.mas_left).offset(15);
            make.right.mas_equalTo(_startActivityView.mas_right).offset(-100);
            make.top.mas_equalTo(shareLabel.mas_bottom).offset(50);
            make.bottom.mas_equalTo(_startActivityView.mas_bottom).offset(-kSpace);
        }];
        
        UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [messageBtn setImage:[UIImage imageNamed:@"icon-massage"] forState:UIControlStateNormal];
        [_startActivityView addSubview:messageBtn];
        [messageBtn addTarget:self action:@selector(showTextField) forControlEvents:UIControlEventTouchUpInside];
        
        [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.right.mas_equalTo(_startActivityView.mas_right).offset(-30);
            make.bottom.mas_equalTo(_startActivityView.mas_bottom).offset(-30);
            make.width.height.equalTo(@50);
        }];
    }
    return _startActivityView;
}

- (AnsweringView *)answeringView {
    if (!_answeringView) {
        
        _answeringView = [[AnsweringView alloc] initWithFrame:CGRectMake(25, -375, kScreenWidth-50, 375)];
        _answeringView.aBtn.tag = 500;
        _answeringView.bBtn.tag = 501;
        _answeringView.cBtn.tag = 502;
        [_answeringView.aBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_answeringView.bBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
        [_answeringView.cBtn addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _answeringView;
}

//键盘上面的输入视图
- (void)createCommentsView {
    
    if (!_chatInputView) {
        
        _chatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kTabBarHeight - 44.0, kScreenWidth, 44.0)];
        _chatInputView.backgroundColor = [UIColor whiteColor];
        
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
    [self.view.window addSubview:_chatInputView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [_commentText becomeFirstResponder];
    //让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}

- (void)showCommentText {
    [self createCommentsView];
    
    [_commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}

//弹出键盘
- (void)showTextField {
    //这里是为了防止连续点击
    [self showCommentText];
}

//隐藏键盘
- (void)hideKeyboard {
    [_commentText resignFirstResponder];
    _commentText.text = @"";
}

//发送消息
- (void)sendChatMessage{
    
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    
    NSDictionary *dic = @{@"name":_commentText.text,@"num":model.active_lv,@"gender":model.gender};
    
    NSString *jsonStr = [dic dictionaryToJsonString];
    
    NSDictionary *message = @{@"fromUserId":model.user_id,@"fromUserName":model.name,@"messageId":@(14),@"content":jsonStr,@"type":@(1),@"category":@(CHAT)};
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:CHAT priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        if (errorCode == 0) {
            
            MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
            [_commonMsgMarr addObject:model];
            [self refreshCommonChatMsg];
            [self hideKeyboard];
        }
    }];
}
- (void)refreshCommonChatMsg {
    _chatView.messageMarr = _commonMsgMarr;
    
    [_chatView reloadData];
    
    [_chatView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatView.messageMarr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 数据获取
//获取当前活动
- (void)getCurrentActivityData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Answer/getCurrActivity" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        [hud hideAnimated:YES];
        
        if ([data[@"status"] integerValue] == 1) {
            NSString *withdraw = data[@"data"][@"can_withdraw_total"];
            NSString *wintotal = data[@"data"][@"win_total"];
            NSDictionary *diction = data[@"data"][@"curr_activity"];
            
            if ([diction isKindOfClass:[NSNull class]]) {
                
                self.waitView.jackpotLabel.text = @"$ 0 prize";
                self.waitView.wintotalLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-money" bounds:CGRectMake(0, 2, 20, 20) str:[NSString stringWithFormat:@"%.2f",[wintotal floatValue]]];
                self.waitView.cashLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-money" bounds:CGRectMake(0, 2, 20, 20) str:[NSString stringWithFormat:@"%.2f",[withdraw floatValue]]];
            }else {
                _model = [ActivityModel mj_objectWithKeyValues:diction];
                _model.can_withdraw_total = [withdraw floatValue];
                _model.win_total = [wintotal floatValue];
                
                [self getAnswerlistDataWithID:_model.answer_activity_id];
                
                [[AccountManager sharedAccountManager].zegoApi loginRoom:_model.room_id role:ZEGO_AUDIENCE withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
                    if (errorCode == 0) {
                        _hasLogin = YES;
                        for (ZegoStream *stream in streamList) {
                            NSLog(@"ZegoStream:%@",stream.userName);
                            [[AccountManager sharedAccountManager].zegoApi startPlayingStream:stream.streamID inView:nil];
                        }
                        [self getJoinDataWith];
                    }else {
                        _hasLogin = NO;
                    }
                }];
                
                if ([_model.status isEqualToString:@"waiting"] || [_model.status isEqualToString:@"end"]) {
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
                    NSDate *cdate = [formatter dateFromString:_model.curr_time];
                    NSTimeInterval interval = [[NSTimeZone systemTimeZone] secondsFromGMT];
                    cdate = [cdate dateByAddingTimeInterval:interval];
                    NSString *current = [formatter stringFromDate:cdate];
                    
                    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
                    NSArray *zoneArray = [[NSString stringWithFormat:@"%@", localTimeZone] componentsSeparatedByString:@"("];
                    NSString *tempTZ = [NSString stringWithFormat:@"%@", zoneArray.lastObject];
                    NSArray *arr = [[NSString stringWithFormat:@"%@", tempTZ] componentsSeparatedByString:@")"];
                    NSString *gmt = [NSString stringWithFormat:@"%@",arr.firstObject];
                    
                    self.waitView.creatTimeLabel.text = [NSString stringWithFormat:@"%@ %@",current,gmt];
                    self.waitView.jackpotLabel.text = [NSString stringWithFormat:@"$ %ld prize",(long)_model.jackpot];
                    self.waitView.wintotalLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-money" bounds:CGRectMake(0, 2, 20, 20) str:[NSString stringWithFormat:@"%.2f",_model.win_total]];
                    self.waitView.cashLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-money" bounds:CGRectMake(0, 2, 20, 20) str:[NSString stringWithFormat:@"%.2f",_model.can_withdraw_total]];
                    
                }else if ([_model.status isEqualToString:@"start"]) {
                    if (_waitView) {
                        [_waitView removeFromSuperview];
                        _waitView = nil;
                    }
                    [self.view addSubview:self.startActivityView];
                    [self.view insertSubview:self.answeringView aboveSubview:self.startActivityView];
                    if (!_hasLogin) {
                        [[AccountManager sharedAccountManager].zegoApi loginRoom:_model.room_id role:ZEGO_AUDIENCE withCompletionBlock:^(int errorCode, NSArray<ZegoStream *> *streamList) {
                            if (errorCode == 0) {
                                _hasLogin = YES;
                                NSLog(@"login:%d,_hasLogin:%d",errorCode,_hasLogin);
                                [self getJoinDataWith];
                            }else {
                                _hasLogin = NO;
                            }
                        }];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Network Error"];
    }];
}

//获取活动问题列表
- (void)getAnswerlistDataWithID:(NSString *)activityID {
    NSDictionary *dic = @{@"answer_activity_id":activityID};
    [DataService postWithURL:@"rest3/v1/Answer/getActivityQuestions" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"questions"];
            _answerListMarr = [QuestionModel mj_objectArrayWithKeyValuesArray:arr];
        }
    } failure:^(NSError *error) {
        
    }];
}

//加入活动
- (void)getJoinDataWith {
    
    NSDictionary *contentDic = @{@"name":@"join"};
    NSString *jsonStr = [contentDic dictionaryToJsonString];
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:ANSWER_QUESTION priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        if (errorCode == 0) {
            NSLog(@"join:%d",errorCode);
            _hasJoinActivity = YES;
        }else {
            _hasJoinActivity = NO;
        }
    }];
}

//获取最后结果
- (void)getEndData {

    NSDictionary *dic = @{@"answer_activity_id":_model.answer_activity_id,@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Answer/getAnswerResult" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *contentDic = data[@"data"];
            NSString *count = [NSString stringWithFormat:@"%@",contentDic[@"success_count"]];
            NSString *bonus = [NSString stringWithFormat:@"%@",contentDic[@"success_bonus"]];
            bool success = [contentDic[@"success"] boolValue];
            [self creatEndView:count bonus:bonus success:success];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件
- (void)backBtnActionActivity {
//    [self getLeaveData];
    if (_hasJoinActivity) {
        NSDictionary *dic = @{@"name":@"result",@"isRight":@2};
        NSString *jsonStr = [dic dictionaryToJsonString];
        [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:ANSWER_QUESTION priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
            
        }];
    }
    __block ActivityRoomViewController *weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [[AccountManager sharedAccountManager].zegoApi logoutRoom];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

- (void)privateBtnAction {
    ActivityRulesViewController *vc = [[ActivityRulesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//答题
- (void)answerAction:(UIButton *)sender {
    
    [_answeringView addSubview:self.answerCoverControl];
    
    if (sender.tag == 500) {
        
        [_answeringView.aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _answeringView.aBtn.backgroundColor = kChoiceColor;
        _choice = @"a";
        if ([_qmodel.answer isEqualToString:@"a"]) {
            _isRight = 1;
        }else {
            _isRight = 2;
        }
    }else if (sender.tag == 501) {
        
        [_answeringView.bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _answeringView.bBtn.backgroundColor = kChoiceColor;
        _choice = @"b";
        if ([_qmodel.answer isEqualToString:@"b"]) {
            _isRight = 1;
        }else {
            _isRight = 2;
        }
    }else if (sender.tag == 502) {
        
        [_answeringView.cBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _answeringView.cBtn.backgroundColor = kChoiceColor;
        _choice = @"c";
        if ([_qmodel.answer isEqualToString:@"c"]) {
            _isRight = 1;
        }else {
            _isRight = 2;
        }
    }
    
    [_resutMarr addObject:@(_isRight)];
    
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionaryWithDictionary:@{@"name":@"result",@"choice":_choice}];
    if (_isRight == 1) {
        
        [contentDic setObject:@(_isRight) forKey:@"isRight"];
    }
    if (_qmodel.order_no == 12 && ![_resutMarr containsObject:@2]) {
        [contentDic setObject:[AccountManager sharedAccountManager].userID forKey:@"uid"];
    }
    NSString *jsonStr = [contentDic dictionaryToJsonString];
    [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:ANSWER_QUESTION priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
        
    }];
    
    [self answer];
}

- (void)answer {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"answer_question_id":@(_qmodel.answer_question_id),@"answer_activity_id":_model.answer_activity_id,@"answer":_choice};
    [DataService postWithURL:@"rest3/v1/answer/answer" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"上报答案:%@",data);
    } failure:^(NSError *error) {
        
    }];
}

- (void)answerCoverControlAction {
    [DataService toastWithMessage:@"Already selected"];
}
#pragma mark - 代理
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TYTextContainer *textContainer = _chatView.textContainers[indexPath.row];
    return textContainer.textHeight+20;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendChatMessage];
    return YES;
}

- (void)onPlayStateUpdate:(int)stateCode streamID:(NSString *)streamID {
    
}

- (void)onRecvRoomMessage:(NSString *)roomId messageList:(NSArray<ZegoRoomMessage *> *)messageList {
    for (ZegoRoomMessage *message in messageList) {
        MessageModel *model = [MessageModel mj_objectWithKeyValues:message];
        switch (model.category) {
            case CHAT:
            {
                [_commonMsgMarr addObject:model];
                [self refreshCommonChatMsg];
            }
                break;
            case ANSWER_QUESTION:
            {
                if ([model.content.name isEqualToString:@"start"]) {
                    //活动开始
                    if (_waitView) {
                        [_waitView removeFromSuperview];
                        _waitView = nil;
                    }
                    [self.view addSubview:self.startActivityView];
                    [self.view insertSubview:self.answeringView aboveSubview:self.startActivityView];
                    [self getCurrentActivityData];
                    
                }else if ([model.content.name isEqualToString:@"onlineCount"]) {
                    
                    _onlineLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-default" bounds:CGRectMake(0, -3, 20, 20) str:[NSString stringWithFormat:@" %ld Online",model.content.num]];
                    
                }else if ([model.content.name isEqualToString:@"answering"]) {
                    
                    _answeringView.label1.hidden = YES;
                    _answeringView.label2.hidden = YES;
                    _answeringView.label3.hidden = YES;
                    
                    //后进入房间和答错
                    if (model.content.num+1 - _resutMarr.count > 1 || _isRight == 2) {
                        _answeringView.userInteractionEnabled = NO;
                        _answeringView.topIconView.image = [UIImage imageNamed:@"icon-watch"];
                        _answeringView.centerLabel.text = @"";
                        _isWatch = YES;
                    }else {
                        _answeringView.topIconView.image = [UIImage imageNamed:@"icon-pen"];
                        _answeringView.userInteractionEnabled = YES;
                        _answeringView.centerLabel.text = @"Please Choose";
                        _isWatch = NO;
                    }
                    
                    [UIView animateWithDuration:.35 animations:^{
                        
                        _answeringView.top = 75;
                        _answeringView.timerLabel.text = @"10s";
                        _answerTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(answerTimerAction) userInfo:nil repeats:YES];
                        [_answerTimer fire];
                    }];
                    
                    _qmodel = _answerListMarr[model.content.num];
                    _answeringView.questionDescLabel.text = _qmodel.question;
                    _answeringView.indexLabel.text = [NSString stringWithFormat:@"No.%ld",model.content.num+1];
                    [_answeringView.aBtn setTitle:_qmodel.c forState:UIControlStateNormal];
                    [_answeringView.bBtn setTitle:_qmodel.b forState:UIControlStateNormal];
                    [_answeringView.cBtn setTitle:_qmodel.a forState:UIControlStateNormal];
                    
                }else if ([model.content.name isEqualToString:@"publish"]) {
                    
                    _answeringView.label1.hidden = NO;
                    _answeringView.label2.hidden = NO;
                    _answeringView.label3.hidden = NO;
                    
                    _answeringView.userInteractionEnabled = NO;
                    [UIView animateWithDuration:.35 animations:^{
                        _answeringView.top = 75;
                        _answeringView.timerLabel.text = @"5s";
                        _publihTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(publishTimerAction) userInfo:nil repeats:YES];
                        [_publihTimer fire];
                    }];
                    _qmodel = _answerListMarr[model.content.num];
                    _answeringView.questionDescLabel.text = _qmodel.question;
                    _answeringView.indexLabel.text = [NSString stringWithFormat:@"No.%ld",model.content.num+1];
                    _onlineLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-default" bounds:CGRectMake(0, -3, 20, 20) str:[NSString stringWithFormat:@" %ld Online",[model.content.userCount[@"online_count"] integerValue]]];
                    
                    _answeringView.label1.text = [NSString stringWithFormat:@"%ld",[model.content.userCount[@"question_count"][@"a_count"] integerValue]];
                    _answeringView.label2.text = [NSString stringWithFormat:@"%ld",[model.content.userCount[@"question_count"][@"b_count"] integerValue]];
                    _answeringView.label3.text = [NSString stringWithFormat:@"%ld",[model.content.userCount[@"question_count"][@"c_count"] integerValue]];
                    
                    [_answeringView.aBtn setTitle:_qmodel.c forState:UIControlStateNormal];
                    [_answeringView.bBtn setTitle:_qmodel.b forState:UIControlStateNormal];
                    [_answeringView.cBtn setTitle:_qmodel.a forState:UIControlStateNormal];
                    
                    if (_isRight == 1) {
                        _answeringView.topIconView.image = [UIImage imageNamed:@"icon-Correct"];
                        _answeringView.centerLabel.text = @"Correct";
                        if ([_choice isEqualToString:@"a"]) {
                            _answeringView.aBtn.backgroundColor = kNavColor;
                            [_answeringView.aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            
                            _answeringView.label1.textColor = [UIColor whiteColor];
                            _answeringView.label2.textColor = k153Color;
                            _answeringView.label3.textColor = k153Color;
                            
                        }else if ([_choice isEqualToString:@"b"]) {
                            _answeringView.bBtn.backgroundColor = kNavColor;
                            [_answeringView.bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            
                            _answeringView.label2.textColor = [UIColor whiteColor];
                            _answeringView.label1.textColor = k153Color;
                            _answeringView.label3.textColor = k153Color;
                        }else {
                            _answeringView.cBtn.backgroundColor = kNavColor;
                            [_answeringView.cBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            
                            _answeringView.label3.textColor = [UIColor whiteColor];
                            _answeringView.label1.textColor = k153Color;
                            _answeringView.label2.textColor = k153Color;
                        }
                    }else {
                        _answeringView.topIconView.image = [UIImage imageNamed:@"icon-wrong"];
                        _answeringView.centerLabel.text = @"Incorrect";
                        _answeringView.tipsLabel.hidden = NO;
                        
                        //选择的变色
                        if ([_choice isEqualToString:@"a"]) {
                            _answeringView.aBtn.backgroundColor = kErrorColor;
                            [_answeringView.aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _answeringView.label1.textColor = [UIColor whiteColor];
                            _answeringView.label2.textColor = k153Color;
                            _answeringView.label3.textColor = k153Color;
                            
                        }else if ([_choice isEqualToString:@"b"]) {
                            _answeringView.bBtn.backgroundColor = kErrorColor;
                            [_answeringView.bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _answeringView.label2.textColor = [UIColor whiteColor];
                            
                        }else if ([_choice isEqualToString:@"c"]){
                            _answeringView.cBtn.backgroundColor = kErrorColor;
                            [_answeringView.cBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _answeringView.label3.textColor = [UIColor whiteColor];
                        }else {
                            
                        }
                        
                        //显示正确答案
                        if ([_qmodel.answer isEqualToString:@"a"]) {
                            _answeringView.aBtn.backgroundColor = kNavColor;
                            [_answeringView.aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _answeringView.label1.textColor = [UIColor whiteColor];
                            
                        }else if ([_qmodel.answer isEqualToString:@"b"]) {
                            _answeringView.bBtn.backgroundColor = kNavColor;
                            [_answeringView.bBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _answeringView.label2.textColor = [UIColor whiteColor];
                            _answeringView.label1.textColor = k153Color;
                            _answeringView.label3.textColor = k153Color;
                        }else {
                            _answeringView.cBtn.backgroundColor = kNavColor;
                            [_answeringView.cBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            _answeringView.label3.textColor = [UIColor whiteColor];
                            _answeringView.label1.textColor = k153Color;
                            _answeringView.label2.textColor = k153Color;
                        }
                    }
                }else if ([model.content.name isEqualToString:@"allRight"]) {
                    
                    
                }else if ([model.content.name isEqualToString:@"end"]) {
                    //获取答题结果
                    if (_waitView) {
                        [_waitView removeFromSuperview];
                        _waitView = nil;
                    }
                    if (_startActivityView) {
                        [_startActivityView removeFromSuperview];
                        _startActivityView = nil;
                    }
                    [self getEndData];
                }
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)answerTimerAction {
    NSInteger sectionDown = [_answeringView.timerLabel.text integerValue];
    sectionDown--;
    _answeringView.timerLabel.text = [NSString stringWithFormat:@"%lds",(long)sectionDown];
    if (sectionDown <= 3) {
        _answeringView.timerLabel.textColor = [UIColor redColor];
    }
    if(sectionDown < 0) {
        
        _answeringView.timerLabel.text = @"";
        [UIView animateWithDuration:.35 animations:^{
            _answeringView.bottom = 0;
        }completion:^(BOOL finished) {
            [self changeBtnState];
        }];
        
        if (_answerCoverControl) {
            [_answerCoverControl removeFromSuperview];
            _answerCoverControl = nil;
        }
        [_answerTimer invalidate];
        _answerTimer = nil;
        return;
    }
}
- (void)publishTimerAction {
    NSInteger sectionDown = [_answeringView.timerLabel.text integerValue];
    sectionDown--;
    _answeringView.timerLabel.text = [NSString stringWithFormat:@"%lds",(long)sectionDown];
    if (sectionDown <= 3) {
        _answeringView.timerLabel.textColor = [UIColor redColor];
    }
    if(sectionDown < 0) {
        
        _choice = @"";
        _answeringView.tipsLabel.hidden = YES;
        _answeringView.userInteractionEnabled = YES;
        _answeringView.timerLabel.text = @"";
        [UIView animateWithDuration:.35 animations:^{
            _answeringView.bottom = 0;
        }completion:^(BOOL finished) {
            [self changeBtnState];
        }];
        [_publihTimer invalidate];
        _publihTimer = nil;
        return;
    }
}

- (void)changeBtnState {
    _answeringView.aBtn.backgroundColor = [UIColor whiteColor];
    [_answeringView.aBtn setTitleColor:k51Color forState:UIControlStateNormal];
    _answeringView.bBtn.backgroundColor = [UIColor whiteColor];
    [_answeringView.bBtn setTitleColor:k51Color forState:UIControlStateNormal];
    _answeringView.cBtn.backgroundColor = [UIColor whiteColor];
    [_answeringView.cBtn setTitleColor:k51Color forState:UIControlStateNormal];
    
    UILabel *label1 = (UILabel *)[_answeringView.aBtn viewWithTag:505];
    UILabel *label2 = (UILabel *)[_answeringView.bBtn viewWithTag:506];
    UILabel *label3 = (UILabel *)[_answeringView.cBtn viewWithTag:507];
    label1.textColor = k51Color;
    label2.textColor = k51Color;
    label3.textColor = k51Color;
}

- (NSString *)arrayToString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
