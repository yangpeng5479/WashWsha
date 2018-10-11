//
//  ModifyUserinfoViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/30.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "ModifyUserinfoViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import "UIViewController+BackButtonHandler.h"
#import "UITextView+YLTextView.h"
#import "WYFileManager.h"

@interface ModifyUserinfoViewController ()

@property(nonatomic,strong)UITextField *editTextField;
@property(nonatomic,strong)UITextView *textview;

@end

@implementation ModifyUserinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kLightBgColor;
    if (self.type == 1) {
        self.navigationItem.title = @"Name setting";
        [self.view addSubview:self.editTextField];
    }else {
        self.navigationItem.title = @"Signature setting";
        [self.view addSubview:self.textview];
    }
}


- (UITextView *)textview {
    if (!_textview) {
        _textview = [[UITextView alloc] initWithFrame:CGRectMake(kSpace, kNavbarHeight+30, kScreenWidth-2*kSpace, 150)];
        _textview.text = self.text;
        _textview.placeholder = @"Signature";
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
    [self.view endEditing:YES];
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.type == 1) {
        if ([_editTextField.text isEqualToString:@""]) {
            _editTextField.text = self.text;
        }
        dic = @{@"token":[AccountManager sharedAccountManager].token,@"name":_editTextField.text};
    }else {
        if ([_textview.text isEqualToString:@""]) {
            _textview.text = @"";
        }
        dic = @{@"token":[AccountManager sharedAccountManager].token,@"signature":_textview.text};
    }
    [DataService postWithURL:@"rest3/v1/user/modify_my_info" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            
            [DataService toastWithMessage:@"Modify success"];
            UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
            if (self.type == 1) {
                model.name = _editTextField.text;
            }else {
                model.signature = _textview.text;
            }
            sleep(1);
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([data[@"status"] integerValue] == 20008) {
            [DataService toastWithMessage:@"Please change another"];
        }else {
            [DataService toastWithMessage:@"Modify error"];
        }
    } failure:^(NSError *error) {
        [DataService toastWithMessage:@"Modify error"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
