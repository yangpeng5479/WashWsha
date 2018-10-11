//
//  FeedbackIdeaController.m
//  GameTogether_iOS
//
//  Created by yangpeng on 16/5/12.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "FeedbackIdeaController.h"
#import "AccountManager.h"
#import "CommonPrex.h"
#import "MineProfilePhotosView.h"
#import "DataService.h"
#import "UITextView+YLTextView.h"

@interface FeedbackIdeaController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UILabel *_placeHolder;
    UITextView *_feedbackTextView;
    UIControl *_control;
}
@property(nonatomic,strong)UIImageView *iconImageView;
@end

@implementation FeedbackIdeaController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"Comments and feedback";
    self.view.backgroundColor = kLightBgColor;
    [self _createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagePickerControllerDidCancel:) name:@"dismissImagePicker" object:nil];
}


#pragma mark - 创建视图控件
- (void)_createViews {

    //反馈意见textview
    
    _feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, kNavbarHeight + kSpace, kScreenWidth-30, 200)];
    _feedbackTextView.delegate = self;
    _feedbackTextView.font = [UIFont systemFontOfSize:16];
    _feedbackTextView.placeholder = @"Here you can feedback comments and suggestions!";
    _feedbackTextView.limitLength = @200;
    [self.view addSubview:_feedbackTextView];
    
    //添加图片视图
    //添加头像
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, _feedbackTextView.bottom+20, 100, 100)];
    _iconImageView.image = [UIImage imageNamed:@"Addphotos"];
    _iconImageView.userInteractionEnabled = YES;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_iconImageView];
    UITapGestureRecognizer *addphoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPhotoAction)];
    [_iconImageView addGestureRecognizer:addphoto];
    
    //提交按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(kSpace, _iconImageView.bottom+kSpace+40, kScreenWidth-2*kSpace, 40);
    submitBtn.layer.cornerRadius = 20;
    submitBtn.backgroundColor = kNavColor;
    submitBtn.alpha = 0.6;
    submitBtn.enabled = NO;
    submitBtn.tag = 1560;
    [submitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    _placeHolder.text = @"";
    
    if (!_control) {
        
        _control = [[UIControl alloc] initWithFrame:CGRectMake(0, _feedbackTextView.bottom, kScreenWidth, kScreenHeight-_feedbackTextView.bottom)];
        [_control addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_control];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    UIButton *btn = (UIButton *)[self.view viewWithTag:1560];
    if (![textView.text isEqualToString:@""]) {
        
        btn.enabled = YES;
        btn.alpha = 1;
    }else {
        
        btn.enabled = NO;
        btn.alpha = .6;
    }
}

#pragma mark - 响应方法
- (void)tapAction {
    
    [_feedbackTextView resignFirstResponder];
    
    if (_control) {
        
        [_control removeFromSuperview];
        _control = nil;
    }
}
//添加图片
- (void)addPhotoAction {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"addPhoto" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Album", nil];
    actionSheet.tag = 5600;
    [actionSheet showInView:self.view];
}

//提交反馈
- (void)submitAction {
    
    [self performSelector:@selector(submit) withObject:nil afterDelay:0.8];
}
- (void)submit {
    [DataService toastWithMessage:@"Submit successfully, we will respect your opinion!"];
    _feedbackTextView.text = @"";
    _iconImageView.image = [UIImage imageNamed:@"Addphotos"];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 5600) {
        
        if (buttonIndex == 0) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self saveImage:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片
- (void)saveImage:(UIImage *)image {
    
    _iconImageView.image =image;
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    
}


@end
