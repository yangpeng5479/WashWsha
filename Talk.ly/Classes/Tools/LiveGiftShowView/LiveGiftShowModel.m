//
//  LiveGiftShowModel.m
//  LiveSendGift
//
//  Created by Jonhory on 2016/11/11.
//  Copyright © 2016年 com.wujh. All rights reserved.
//

#import "LiveGiftShowModel.h"
#import <MJExtension.h>

@implementation LiveGiftShowModel

+ (instancetype)giftModel:(NSDictionary *)giftDic userModel:(NSDictionary *)userDic{
    LiveGiftShowModel * model = [[LiveGiftShowModel alloc]init];
    LiveGiftListModel *giftModel = [LiveGiftListModel mj_objectWithKeyValues:giftDic];
    LiveUserModel *userModel = [LiveUserModel mj_objectWithKeyValues:userDic];
    model.giftModel = giftModel;
    model.user = userModel;
    model.interval = 0.35;
    model.toNumber = 1;
    return model;
}


@end
