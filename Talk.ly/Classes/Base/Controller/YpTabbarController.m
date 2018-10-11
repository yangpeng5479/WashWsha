//
//  YpTabbarController.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "YpTabbarController.h"
#import "YpTabbar.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "CommonPrex.h"
#import "BaseNavigationController.h"
#import "OpenRoomView.h"
#import "LiveRoomViewController.h"
#import "StartRadioView.h"
#import "DataService.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ChatRoomModel.h"
#import "RoomViewController.h"
#import "WYFileManager.h"
#import <MJExtension.h>

@interface YpTabbarController ()<YpTabBarDelegate,UITabBarControllerDelegate,UITextFieldDelegate>

@property(nonatomic,strong)OpenRoomView *openView;
@property(nonatomic,strong)UIControl *coverControl;
@property(nonatomic,strong)StartRadioView *startView;
@property(nonatomic,strong)UITapGestureRecognizer *tap;

@end

@implementation YpTabbarController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    homeVC.tabBarItem.title = @"Home";
    homeVC.tabBarItem.image = [UIImage imageNamed:@"icon-home-default"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-home-click"];
    
    FindViewController *findVC = [[FindViewController alloc] init];
    findVC.tabBarItem.title = @"Top";
    findVC.tabBarItem.image = [UIImage imageNamed:@"icon-TOP-default"];
    findVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon-TOP-click"];

    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlueColor} forState:UIControlStateSelected];
    
    NSArray *arr = @[homeVC,findVC];
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:arr[i]];
        [marr addObject:nav];
    }
    
    YpTabbar *tabbar = [[YpTabbar alloc] init];
    tabbar.ypTabBarDelegate = self;
    [tabbar setBackgroundColor:[UIColor whiteColor]];
    [tabbar setBarTintColor:[UIColor whiteColor]];
    [tabbar setTintColor:kBlueColor];
    [self setValue:tabbar forKey:@"tabBar"];
    self.viewControllers = marr;
}

- (void)addButtonClick:(YpTabbar *)tabBar {
    NSLog(@"addButtonClick:%ld",self.selectedIndex);
    if (self.selectedIndex == 0) {
        [self creatOpenview];
        [UIView animateWithDuration:.35 animations:^{
           
            _openView.bottom = kScreenHeight;
        }];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"Home"]) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        
    }else {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
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

- (void)creatOpenview {
    if (!_openView) {
        _openView = [[OpenRoomView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 180)];
        [self.view addSubview:_openView];
        
        _coverControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-180)];
        _coverControl.backgroundColor = [UIColor clearColor];
        [_coverControl addTarget:self action:@selector(removeOpenViewAction)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_coverControl];
        
        UIButton *liveBtn = (UIButton *)[_openView viewWithTag:350];
        UIButton *radioBtn = (UIButton *)[_openView viewWithTag:351];
        UIButton *closeBtn = (UIButton *)[_openView viewWithTag:370];
        [liveBtn addTarget:self action:@selector(liveBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [radioBtn addTarget:self action:@selector(radioBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (StartRadioView *)startView {
    
    if (!_startView) {
        
        _startView = [[StartRadioView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_startView];
        [_startView.closeBtn addTarget:self action:@selector(closeStartView) forControlEvents:UIControlEventTouchUpInside];
        _startView.titleTF.delegate = self;
        _startView.decTF.delegate = self;
        [_startView.startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startView;
}

//视频
- (void)liveBtnAction {
    [AccountManager sharedAccountManager].zegoApi = nil;
    [ZegoLiveRoomApi setBusinessType:0];
    [ZegoLiveRoomApi setVerbose:YES];
    [ZegoLiveRoomApi setUserID:[DEFAULTS objectForKey:@"userid"] userName:[DEFAULTS objectForKey:@"name"]];
    Byte signkey[] = {0xb9,0xfa,0xc0,0xce,0x98,0x5c,0x36,0x16,0x9a,0x47,0xaf,0xe3,0x25,0x93,0x70,0x83,0x6c,0xf7,0xc6,0x26,0xc3,0x43,0x3b,0x1d,0xfe,0x68,0x4e,0x4a,0xed,0xf7,0x2d,0xcd};
    [AccountManager sharedAccountManager].zegoApi = [[ZegoLiveRoomApi alloc] initWithAppID:3969131734 appSignature:[NSData dataWithBytes:signkey length:32]];
    [[AccountManager sharedAccountManager].zegoApi enableCamera:YES];
    
    [self closeBtnAction];
    LiveRoomViewController *live = [[LiveRoomViewController alloc] init];
    BaseNavigationController *home = (BaseNavigationController *)self.viewControllers[self.selectedIndex];
    live.hidesBottomBarWhenPushed = YES;
    [home pushViewController:live animated:YES];
}

//语音
- (void)radioBtnAction {
    [self closeBtnAction];
    [UIView animateWithDuration:.35 animations:^{
       
        self.startView.bottom = kScreenHeight;
    }];
}

//移除
- (void)removeOpenViewAction {
    [self closeBtnAction];
}
- (void)closeBtnAction {
    [UIView animateWithDuration:.35 animations:^{
        _openView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [_openView removeFromSuperview];
        _openView = nil;
        [_coverControl removeFromSuperview];
        _coverControl = nil;
    }];
}

- (void)closeStartView {
    [UIView animateWithDuration:.35 animations:^{
        self.startView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [_startView removeFromSuperview];
        _startView = nil;
    }];
}

- (void)tapAction {
    
    [_startView.titleTF resignFirstResponder];
    [_startView.decTF resignFirstResponder];
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

//开启语音直播
- (void)startBtnAction {
    
    [AccountManager sharedAccountManager].zegoApi = nil;
    [ZegoLiveRoomApi setBusinessType:2];
    [ZegoLiveRoomApi setVerbose:YES];
    [ZegoLiveRoomApi setUserID:[DEFAULTS objectForKey:@"userid"] userName:[DEFAULTS objectForKey:@"name"]];
    Byte signkey[] = {0xb9,0xfa,0xc0,0xce,0x98,0x5c,0x36,0x16,0x9a,0x47,0xaf,0xe3,0x25,0x93,0x70,0x83,0x6c,0xf7,0xc6,0x26,0xc3,0x43,0x3b,0x1d,0xfe,0x68,0x4e,0x4a,0xed,0xf7,0x2d,0xcd};
    [AccountManager sharedAccountManager].zegoApi = [[ZegoLiveRoomApi alloc] initWithAppID:3969131734 appSignature:[NSData dataWithBytes:signkey length:32]];
    [[AccountManager sharedAccountManager].zegoApi enableCamera:NO];
    [self openRoomData];
}

//主持人开启自己的聊天室
- (void)openRoomData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Livechatroom/openChatroom" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            [self closeStartView];
            
            NSDictionary *diction = data[@"data"];
            ChatRoomModel *chatModel = [ChatRoomModel mj_objectWithKeyValues:diction];
            
            RoomViewController *roomVC = [[RoomViewController alloc] init];
            roomVC.hidesBottomBarWhenPushed = YES;
            roomVC.chatModel = chatModel;
            roomVC.type = 1;
            
            //保存房间信息
            NSMutableDictionary *roomDic = [NSMutableDictionary dictionary];
            [roomDic setValue:chatModel.chatroom.room_name forKey:@"roomName"];
            [roomDic setValue:chatModel.chatroom.room_desc forKey:@"roomDesc"];
            
            if (chatModel.chatroom.topic[@"name"] != nil) {
                [roomDic setValue:chatModel.chatroom.topic[@"name"] forKey:@"topic"];
            }else {
                [roomDic setValue:@"" forKey:@"topic"];
            }
            [WYFileManager setCustomObject:roomDic forKey:@"roomInfo"];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                BaseNavigationController *home = (BaseNavigationController *)self.viewControllers[self.selectedIndex];
                [home pushViewController:roomVC animated:YES];
            });
            
        }else {
            [DataService toastWithMessage:@"Error"];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Error"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
