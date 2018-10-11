//
//  MOBShareSDKHelper.m
//  ShareSDKDemo
//
//  Created by youzu on 2017/6/1.
//  Copyright © 2017年 mob. All rights reserved.
//
#import "MOBShareSDKHelper.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK+Base.h>


@implementation MOBShareSDKHelper

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hasGetAppKey:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
}

+ (void)hasGetAppKey:(NSNotification *)notification
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MOBShareSDKHelper shareInstance].platforems = [MOBShareSDKHelper _getPlatforems];
        [ShareSDK registerActivePlatforms:[MOBShareSDKHelper shareInstance].platforems
                                 onImport:^(SSDKPlatformType platformType) {
                                     [MOBShareSDKHelper _setConnectorWithPlatformType:platformType];
                                 }
                          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                              [MOBShareSDKHelper _setConfigurationWithPlatformType:platformType appInfo:appInfo];
                          }];
        
//#define InitTest
#ifdef InitTest
                [self testShare];
#endif
//    });
}

+ (void)testShare
{
    NSLog(@"---------%s---------",__func__);
    BOOL support = [ShareSDK isSupportAuth:SSDKPlatformTypeWechat];
    
    NSLog(@"--------------> %zd",support);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"Text" images:[UIImage imageNamed:@"D45.jpg"] url:nil title:@"test" type:SSDKContentTypeAuto];
    
    [ShareSDK share:SSDKPlatformTypeWechat parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        NSLog(@"\n--------------->HelperWarning<---------------:\n\nState:%zd,Error:%@\n\n----------------------------------",state,error);
    }];
}

//注册平台
+ (NSArray *)_getPlatforems
{
    NSMutableArray *platforems = [NSMutableArray array];
    //Facebook
#ifdef IMPORT_Facebook
    [platforems addObject:@(SSDKPlatformTypeFacebook)];
#endif
    //Instagram
#ifdef IMPORT_Instagram
    [platforems addObject:@(SSDKPlatformTypeInstagram)];
#endif
    //Twitter
#ifdef IMPORT_Twitter
    [platforems addObject:@(SSDKPlatformTypeTwitter)];
#endif
    //WhatsApp
#ifdef IMPORT_WhatsApp
    [platforems addObject:@(SSDKPlatformTypeWhatsApp)];
#endif
    //GooglePlus
#ifdef IMPORT_GooglePlus
    [platforems addObject:@(SSDKPlatformTypeGooglePlus)];
#endif
    return platforems;
    
}

//注册平台依赖 Connector
+ (void)_setConnectorWithPlatformType:(SSDKPlatformType)platformType
{
}

//注册平台信息
+ (void)_setConfigurationWithPlatformType:(SSDKPlatformType)platformType appInfo:(NSMutableDictionary *)appInfo
{
    switch (platformType) {
            
            //Facebook
        case SSDKPlatformTypeFacebook:
        case SSDKPlatformTypeFacebookMessenger:
#ifdef IMPORT_Facebook
            #pragma mark - Facebook 重设权限
//                  [appInfo SSDKSetAuthSettings:@[
//                                                 @"public_profile",//默认(无需审核)
//                                                 @"user_friends",//好友列表(无需审核)
//                                                 @"email",//邮箱(无需审核)
//                                                 @"user_about_me",//用户个人说明(需审核)
//                                                 @"publish_actions",//应用内分享 必要权限(需审核)
//                                                 @"user_videos"//应用内视频分享 必要权限(需审核)
//                                                 ]];
            [appInfo SSDKSetupFacebookByApiKey:MOBSSDKFacebookAppID
                                     appSecret:MOBSSDKFacebookAppSecret
                                   displayName:MOBSSDKFacebookDisplayName
                                      authType:MOBSSDKFacebookAuthType];
#endif
            break;
            //Instagram
        case SSDKPlatformTypeInstagram:
#ifdef IMPORT_Instagram
            [appInfo SSDKSetupInstagramByClientID:MOBSSDKInstagramClientID
                                     clientSecret:MOBSSDKInstagramClientSecret
                                      redirectUri:MOBSSDKInstagramRedirectUri];
#endif
            break;
            //Twitter
        case SSDKPlatformTypeTwitter:
#ifdef IMPORT_Twitter
        [appInfo SSDKSetupTwitterByConsumerKey:MOBSSDKTwitterConsumerKey
                                consumerSecret:MOBSSDKTwitterConsumerSecret
                                   redirectUri:MOBSSDKTwitterRedirectUri];
#endif
            break;
            
            //GooglePlus
        case SSDKPlatformTypeGooglePlus:
#ifdef IMPORT_GooglePlus
            [appInfo SSDKSetupGooglePlusByClientID:MOBSSDKGooglePlusClientID
                                      clientSecret:MOBSSDKGooglePlusClientSecret
                                       redirectUri:MOBSSDKGooglePlusRedirectUri];
#endif
            break;
        default:
            break;
    }
}

+ (MOBShareSDKHelper *)shareInstance
{
    static MOBShareSDKHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[MOBShareSDKHelper alloc] init];
    });
    return helper;
}

#if (defined IMPORT_SUB_WechatSession) || (defined IMPORT_SUB_WechatTimeline) || (defined IMPORT_SUB_WechatFav)
//微信的回调
-(void) onReq:(BaseReq*)req
{
    NSLog(@"wechat req %@",req);
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"wechat resp %@",resp);
}
#endif
@end
