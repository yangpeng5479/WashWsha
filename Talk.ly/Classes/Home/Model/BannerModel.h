//
//  BannerModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/2.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property(nonatomic,copy)NSString *content_id;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *type;

@end
