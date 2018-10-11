//
//  MusicViewController.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/1.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjectDelegate <JSExport>
-(void)callme:(NSString *)string;
-(void)share:(NSString *)shareUrl;
@end

@interface MusicViewController : UIViewController

@end
