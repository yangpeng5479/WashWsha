//
//  YpTabbar.m
//  Vcoze
//
//  Created by 杨鹏 on 2018/8/7.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "YpTabbar.h"
#import "UIViewExt.h"
#import "CommonPrex.h"

@interface YpTabbar()

@property (nonatomic,weak) UIButton *addButton;

@end

@implementation YpTabbar

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        //创建中间“+”按钮
        UIButton *addBtn = [[UIButton alloc] init];
        //设置默认背景图片
        [addBtn setBackgroundImage:[UIImage imageNamed:@"icon-add"] forState:UIControlStateNormal];
        //设置按下时背景图片
        [addBtn setBackgroundImage:[UIImage imageNamed:@"icon-add"] forState:UIControlStateHighlighted];
        //添加响应事件
        [addBtn addTarget:self action:@selector(addBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        //将按钮添加到TabBar
        [self addSubview:addBtn];
        
        self.addButton = addBtn;
    }
    return self;
}

- (void)addBtnDidClick {
    
    if([self.ypTabBarDelegate respondsToSelector:@selector(addButtonClick:)]) {
        [self.ypTabBarDelegate addButtonClick:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //去掉TabBar上部的横线
//    self.backgroundImage = [[UIImage alloc]init];
//    self.shadowImage = [[UIImage alloc]init];
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1)   //横线的高度为0.5
        {
            UIImageView *line = (UIImageView *)view;
            line.backgroundColor = kNavColor;
        }
    }
    
    //设置“+”按钮的位置
    self.addButton.centerX = self.centerX;
    self.addButton.centerY = self.height * 0.5 - 1.5 * kSpace;
    //设置“+”按钮的大小为图片的大小
    self.addButton.size = CGSizeMake(60, 60);
    
    int btnIndex = 0;
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {//遍历TabBar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度等于TabBar的三分之一
            btn.width = self.width / 3;
            
            btn.x = btn.width * btnIndex;
            
            btnIndex++;
            //如果索引是1(即“+”按钮)，直接让索引加一
            if (btnIndex == 1) {
                btnIndex++;
            }
        }
    }
    //将“+”按钮放到视图层次最前面
    [self bringSubviewToFront:self.addButton];
}

 //重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击“+”按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在“+”按钮或“添加”标签上
    //是的话让“+”按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO)
    {
        //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
        CGPoint newA = [self convertPoint:point toView:self.addButton];
        
        //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
        if ( [self.addButton pointInside:newA withEvent:event])
        {
            return self.addButton;
        }else
        {//如果点不在“+”按钮身上，直接让系统处理就可以了
            
            return [super hitTest:point withEvent:event];
        }
    }
    else
    {
        //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}




















@end
