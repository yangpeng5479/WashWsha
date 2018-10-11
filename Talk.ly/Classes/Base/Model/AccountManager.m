//
//  AccountManager.m
//  GameTogether_iOS
//
//  Created by Mac on 16/5/8.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "AccountManager.h"
#import "CommonPrex.h"
#import "GiftModel.h"
#import <MJExtension.h>
#import "DataService.h"

static AccountManager *instance = nil;

@implementation AccountManager

+ (AccountManager *)sharedAccountManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _musicArr = [NSMutableArray array];
        _imageArr = @[@"Favor",@"Roseflower",@"icecream",@"Donut",@"heart",@"MeteorShower",@"SportsCar",@"AirPlane",@"Icelolly",@"Pizza",@"FluorescentBar",@"LoveBalloon",@"Angela",@"LOVE",@"CruiseShip",@"Castle",@"Drink",@"chocolate",@"speaker",@"Redlips",@"Cars",@"Crown",@"Bouquet",@"Rocket"];
        _grayImageArr = @[@"Favor_gray",@"Roseflower_gray",@"icecream_gray",@"Donut_gray",@"heart_gray",@"MeteorShower_gray",@"SportsCar_gray",@"AirPlane_gray",@"Icelolly_gray",@"Pizza_gray",@"FluorescentBar_gray",@"LoveBalloon_gray",@"Angela_gray",@"LOVE_gray",@"CruiseShip_gray",@"Castle_gray",@"Drink_gray",@"chocolate_gray",@"speaker_gray",@"Redlips_gray",@"Cars_gray",@"Crown_gray",@"Bouquet_gray",@"Rocket_gray"];
        _giftListMarr = [NSMutableArray array];
        _giftModelMarr = [NSMutableArray array];
        _locationDic = [NSDictionary dictionary];
        _userID = [DEFAULTS objectForKey:@"userid"];
        _token = [DEFAULTS objectForKey:@"token"];
    }
    
    return self;
}

- (void)loadGiftData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"giftList.plist"];
    NSLog(@"%@",filePath);
    _giftListMarr = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (!_giftListMarr) {
        NSDictionary *dic = @{@"token":_token};
        [DataService postWithURL:@"rest3/v1/Gift/get_gift_list" type:1 params:dic fileData:nil success:^(id data) {
            NSLog(@"%@",data);
            NSMutableArray *arr = data[@"data"][@"gift_list"];
            NSMutableArray *tempGiftListMarr = [NSMutableArray arrayWithArray:arr];
            [tempGiftListMarr removeObjectAtIndex:0]; //移除红包
            [tempGiftListMarr writeToFile:filePath atomically:YES];
            _giftListMarr = tempGiftListMarr;
            _giftModelMarr = [GiftModel mj_objectArrayWithKeyValuesArray:_giftListMarr];
            
            for (int i = 0; i < _giftModelMarr.count; ++i) {
                GiftModel *model = _giftModelMarr[i];
                model.gift_image_key = _imageArr[i];
                NSLog(@"account ----------%@",model.gift_image_key);
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

@end
