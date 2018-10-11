//
//  AccountManager.h
//  GameTogether_iOS
//
//  Created by Mac on 16/5/8.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZegoLiveRoom/ZegoLiveRoom.h>


@interface AccountManager : NSObject
@property(nonatomic,strong)ZegoLiveRoomApi *zegoApi;

@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,strong)NSMutableArray *giftListMarr;
@property(nonatomic,strong)NSMutableArray *giftModelMarr;
@property(nonatomic,strong)NSArray *imageArr;
@property(nonatomic,strong)NSArray *grayImageArr;
@property(nonatomic,strong)NSDictionary *locationDic;
@property(nonatomic,strong)NSMutableArray *musicArr;
@property(nonatomic,assign)BOOL isPlay;

+ (AccountManager *)sharedAccountManager;
- (void)loadGiftData;
@end
