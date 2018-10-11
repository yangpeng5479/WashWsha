//
//  SettingsViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/18.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "SettingsViewController.h"
#import "UITextView+YLTextView.h"
#import "CommonPrex.h"
#import "RoomSettingViewController.h"
#import "UserModel.h"
#import "WYFileManager.h"
#import "NSDictionary+Jsonstring.h"
#import "MessageModel.h"
#import <MJExtension.h>
#import "UIViewController+BackButtonHandler.h"
#import "DataService.h"
#import <MBProgressHUD.h>

@interface SettingsViewController ()<ZegoIMDelegate>

@property(nonatomic,strong)UITextField *editTextField;
@property(nonatomic,strong)UITextView *textview;
@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kLightBgColor;
    if (self.type == 1) {
        self.navigationItem.title = @"Introduction Settings";
    }else if (self.type == 2) {
        self.navigationItem.title = @"Label Settings";
    }else {
        self.navigationItem.title = @"Name Settings";
    }
    
    [[AccountManager sharedAccountManager].zegoApi setIMDelegate:self];
    
    [self setupUI];
}

- (void)setupUI {
    if (self.type != 1) {
        //名字和标签
        [self.view addSubview:self.editTextField];
    }else {
        //房间介绍
        [self.view addSubview:self.textview];
    }
}

- (UITextView *)textview {
    if (!_textview) {
        _textview = [[UITextView alloc] initWithFrame:CGRectMake(kSpace, kNavbarHeight+30, kScreenWidth-2*kSpace, 150)];
        _textview.text = self.text;
        _textview.placeholder = @"Room introduction";
        _textview.limitLength = @100;
        _textview.backgroundColor = [UIColor whiteColor];
        _textview.font = [UIFont systemFontOfSize:16];
        _textview.layer.borderWidth = 1;
        _textview.layer.borderColor = kLineColor.CGColor;
        _textview.layer.cornerRadius = kCellSpace;
        _textview.layer.masksToBounds = YES;
    }
    return _textview;
}
//懒加载
- (UITextField *)editTextField {
    if (!_editTextField) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
        leftView.backgroundColor = [UIColor whiteColor];
        
        _editTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, kNavbarHeight+30, kScreenWidth, 50)];
        _editTextField.textColor = k102Color;
        _editTextField.placeholder = self.text;
        _editTextField.font = [UIFont systemFontOfSize:16];
        _editTextField.backgroundColor = [UIColor whiteColor];
        _editTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _editTextField.layer.borderColor = kLineColor.CGColor;
        _editTextField.layer.borderWidth = 1;
        _editTextField.leftView = leftView;
        _editTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _editTextField;
}

- (BOOL)navigationShouldPopOnBackButton {

    [self saveBtnAction];
    return NO;
}

- (void)saveBtnAction {
    if ([_editTextField.text isEqualToString:@""] || [_textview.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSMutableDictionary *diction = [NSMutableDictionary dictionaryWithObject:[AccountManager sharedAccountManager].token forKey:@"token"];
    RoomSettingViewController *settingVC = nil;
    NSDictionary *dic = [NSDictionary dictionary];
    int category = 0;
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[RoomSettingViewController class]]) {
            settingVC = (RoomSettingViewController *)VC;
            NSMutableDictionary *roomDic = [WYFileManager getCustomObjectWithKey:@"roomInfo"];
            if (self.type == 1) {
                [roomDic setValue:_textview.text forKey:@"roomDesc"];
                dic = @{@"name":_textview.text,@"num":@""};
                category = 13;
                [diction setValue:_textview.text forKey:@"room_desc"];
            }else if (self.type == 2) {
                [roomDic setValue:_editTextField.text forKey:@"topic"];
                dic = @{@"name":_editTextField.text,@"num":@""};
                category = 12;
                [diction setValue:_editTextField.text forKey:@"topic_name"];
            }else {
                [roomDic setValue:_editTextField.text forKey:@"roomName"];
                dic = @{@"name":_editTextField.text,@"num":@""};
                category = 11;
                [diction setValue:_editTextField.text forKey:@"room_name"];
            }
            [WYFileManager setCustomObject:roomDic forKey:@"roomInfo"];
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    [DataService postWithURL:@"rest3/v1/Livechatroom/modifySetting" type:1 params:diction fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        if ([data[@"status"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            
            NSString *jsonStr = [dic dictionaryToJsonString];
            [[AccountManager sharedAccountManager].zegoApi sendRoomMessage:jsonStr type:ZEGO_TEXT category:category priority:ZEGO_DEFAULT completion:^(int errorCode, NSString *roomId, unsigned long long messageId) {
                if (errorCode == 0) {
                    
                }
            }];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
