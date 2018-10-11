//
//  DataService.h
//  GameTogether_iOS
//
//  Created by Mac on 16/4/27.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import "UserModel.h"

typedef void (^SuccessBlock)(id data);
typedef void (^FailureBlock)(NSError *error);

@interface DataService : NSObject
+ (void)getWithURL:(NSString *)urlStr
            params:(NSDictionary *)params
           success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)getCoinWithURL:(NSString *)urlStr
                params:(NSDictionary *)params
               success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)postWithURL:(NSString *)urlStr
               type:(int)type
             params:(id)params
           fileData:(NSData *)fileData
            success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)postCoinWithURL:(NSString *)urlStr type:(int)type params:(id)params fileData:(NSData *)fileData success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)putWithURL:(NSString *)urlStr
              type:(int)type
            params:(id)params
           success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (void)deleteWithURL:(NSString *)urlStr
            params:(NSDictionary *)params
           success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

+ (NSString*)deviceString;

+ (void)alertWhenServerReturnError:(id)responseObject;

+ (NSAttributedString *)createAttributedStringWithImageName:(NSString *)imageName bounds:(CGRect)rect str:(NSString *)str;

+ (MJRefreshNormalHeader *)refreshHeaderWithTarget:(id)target action:(SEL)selector;

+ (NSMutableArray *)arrayWithGift;

+ (void)toastWhenRequestFailedWithError:(NSError *)error;

+ (void)toastWithMessage:(NSString *)msg;

+ (void)messageWithCmmonMsgMarr:(NSMutableArray *)cmmonMsgMarr listArr:(NSArray *)listArr;

+ (NSString *)substringName:(NSString *)name;

+ (void)roundWithCell:(UITableViewCell *)cell withTableview:(UITableView *)tableView withIdentifier:(int)identifier addline:(BOOL)addLine;

+ (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;

+ (void)storePersonalInfoWithModel:(UserModel *)model;
+ (void)changeReturnButton:(UIViewController *)controller;
+ (void)toastWithMsg:(NSString *)msg;
+ (void)HTTPTimeData;
+ (NSString *)arrayToString:(NSArray *)array;
+ (NSString *)passwordMD5:(NSString *)str;

@end
