//
//  DataService.m
//  GameTogether_iOS
//
//  Created by Mac on 16/4/27.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "DataService.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "CommonPrex.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "UserModel.h"
#import "WYFileManager.h"
#import "AccountManager.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DataService
+ (void)getWithURL:(NSString *)urlStr
            params:(NSDictionary *)params
           success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    NSString *fullUrlStr = [BaseURL stringByAppendingString:urlStr];
    
    if (params != nil) {
        
        NSMutableString *paramStr = [NSMutableString string];
        
        if ([params.allKeys containsObject:@"empty1"]) {
            
            for (id value in params.allValues) {
                
                NSString *valueStr = [NSString stringWithFormat:@"%@",value];
                
                [paramStr appendFormat:@"%@/",valueStr];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];

        }else if ([params.allKeys containsObject:@"array"]) {
            
            NSArray *arr = [params valueForKey:@"array"];
            for (NSNumber *num in arr) {
                
                [paramStr appendFormat:@"%@/",num];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
        }else {
            
            for (NSString *key in params) {
                id value = [params objectForKey:key];
                
                NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                
                [paramStr appendFormat:@"%@&", keyValue];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"?%@", paramStr];
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [self setSession:manager];
    
    [manager GET:fullUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self alertWhenServerReturnError:responseObject];
        
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"http request error:%@",error);
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)getCoinWithURL:(NSString *)urlStr
            params:(NSDictionary *)params
           success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    NSString *string = [NSString stringWithFormat:@"http://%@:7777/",kIPAddress];
    NSString *fullUrlStr = [string stringByAppendingString:urlStr];
    
    if (params != nil) {
        
        NSMutableString *paramStr = [NSMutableString string];
        
        if ([params.allKeys containsObject:@"empty1"]) {
            
            for (id value in params.allValues) {
                
                NSString *valueStr = [NSString stringWithFormat:@"%@",value];
                
                [paramStr appendFormat:@"%@/",valueStr];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
        }else if ([params.allKeys containsObject:@"array"]) {
            
            NSArray *arr = [params valueForKey:@"array"];
            for (NSNumber *num in arr) {
                
                [paramStr appendFormat:@"%@/",num];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
        }else {
            
            for (NSString *key in params) {
                id value = [params objectForKey:key];
                
                NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                
                [paramStr appendFormat:@"%@&", keyValue];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"?%@", paramStr];
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self setSession:manager];
    
    [manager GET:fullUrlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self alertWhenServerReturnError:responseObject];
        
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"http request error:%@",error);
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

+ (void)postWithURL:(NSString *)urlStr type:(int)type params:(id)params fileData:(NSData *)fileData success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    NSString *fullUrlStr = [BaseURL stringByAppendingString:urlStr];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //上传图片
    if (type == 2) {
        
        [manager POST:fullUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            [formData appendPartWithFileData:fileData name:@"image" fileName:@"a.jpg" mimeType:@"image/jpg"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
        //非查询post请求
    }else if (type == 1) {
        
        [manager POST:fullUrlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            [self getHttpErrorData:fullUrlStr];
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
        //查询post请求
    }else if (type == 0) {
        
        if (params != nil) {
            
            NSMutableString *paramStr = [NSMutableString string];
            
            if ([params isKindOfClass:[NSArray class]]) {
                
                for (id value in params) {
                    
                    NSString *valueStr = [NSString stringWithFormat:@"%@",value];
                    
                    [paramStr appendFormat:@"%@/",valueStr];
                }
                
                [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
                
                fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
            }else {
                
                for (NSString *key in params) {
                    id value = [params objectForKey:key];
                    
                    NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                    
                    [paramStr appendFormat:@"%@&", keyValue];
                }
                
                [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
                
                fullUrlStr = [fullUrlStr stringByAppendingFormat:@"?%@", paramStr];
            }
        }
        
        [self setSession:manager];
        
        [manager POST:fullUrlStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

+ (void)postCoinWithURL:(NSString *)urlStr type:(int)type params:(id)params fileData:(NSData *)fileData success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    NSString *string = [NSString stringWithFormat:@"http://%@:7777/",kIPAddress];
    NSString *fullUrlStr = [string stringByAppendingString:urlStr];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //非查询post请求
    if (type == 1) {
        
        [self setSession:manager];
        
        [manager POST:fullUrlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
        //查询post请求
    }else if (type == 0) {
        
        if (params != nil) {
            
            NSMutableString *paramStr = [NSMutableString string];
            
            if ([params isKindOfClass:[NSArray class]]) {
                
                for (id value in params) {
                    
                    NSString *valueStr = [NSString stringWithFormat:@"%@",value];
                    
                    [paramStr appendFormat:@"%@/",valueStr];
                }
                
                [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
                
                fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
            }else {
                
                for (NSString *key in params) {
                    id value = [params objectForKey:key];
                    
                    NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                    
                    [paramStr appendFormat:@"%@&", keyValue];
                }
                
                [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
                
                fullUrlStr = [fullUrlStr stringByAppendingFormat:@"?%@", paramStr];
            }
        }
        
        [self setSession:manager];
        
        [manager POST:fullUrlStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

+ (void)putWithURL:(NSString *)urlStr type:(int)type params:(id)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    NSString *fullUrlStr = [BaseURL stringByAppendingString:urlStr];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self setSession:manager];
    
    if (type == 0) {
        
        NSMutableString *paramStr = [NSMutableString string];
        if (params != nil) {
            
            if ([params isKindOfClass:[NSArray class]]) {
                
                for (id value in params) {
                    
                    NSString *valueStr = [NSString stringWithFormat:@"%@",value];
                    
                    [paramStr appendFormat:@"%@/",valueStr];
                }
                
                [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
                
                fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
            }else {
                
                for (NSString *key in params) {
                    id value = [params objectForKey:key];
                    
                    NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                    
                    [paramStr appendFormat:@"%@&", keyValue];
                }
                
                [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
                
                fullUrlStr = [fullUrlStr stringByAppendingFormat:@"?%@", paramStr];
            }
        }
        
        [manager PUT:fullUrlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }else if (type == 1){
        
        [manager PUT:fullUrlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self alertWhenServerReturnError:responseObject];
            
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"http request error:%@",error);
            
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    }
}

+ (void)deleteWithURL:(NSString *)urlStr params:(NSDictionary *)params success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock {
    
    NSString *fullUrlStr = [BaseURL stringByAppendingString:urlStr];
    
    if (params != nil) {
        
        NSMutableString *paramStr = [NSMutableString string];
        
        if ([params.allKeys containsObject:@"empty1"]) {
            
            for (id value in params.allValues) {
                
                NSString *valueStr = [NSString stringWithFormat:@"%@",value];
                
                [paramStr appendFormat:@"%@/",valueStr];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
        }else if ([params.allKeys containsObject:@"array"]) {
            
            NSArray *arr = [params valueForKey:@"array"];
            for (NSNumber *num in arr) {
                
                [paramStr appendFormat:@"%@/",num];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length-1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"/%@",paramStr];
        }else {
            
            for (NSString *key in params) {
                id value = [params objectForKey:key];
                
                NSString *keyValue = [NSString stringWithFormat:@"%@=%@", key, value];
                
                [paramStr appendFormat:@"%@&", keyValue];
            }
            
            [paramStr deleteCharactersInRange:NSMakeRange(paramStr.length - 1, 1)];
            
            fullUrlStr = [fullUrlStr stringByAppendingFormat:@"?%@", paramStr];
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [self setSession:manager];
    
    [manager DELETE:fullUrlStr parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self alertWhenServerReturnError:responseObject];
        
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"http request error:%@",error);
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}
+ (void)getHttpErrorData:(NSString *)url {
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSString *usertoken = [DEFAULTS objectForKey:@"token"];
    NSDictionary *dic = [NSDictionary dictionary];
    UserModel *usermodel = [WYFileManager getCustomObjectWithKey:@"userModel"];
    if (usertoken) {
        dic = @{@"type":@"http.error",@"device_id":uuid,@"http_error_url":url,@"user_id":usermodel.user_id,@"longitude":usermodel.longitude,@"latitude":usermodel.latitude};
    }else {
        dic = @{@"type":@"http.error",@"device_id":uuid,@"http_error_url":url};
    }
    
    [DataService postWithURL:@"rest3/v1/Logger/submit" type:1 params:dic fileData:nil success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)toastWhenRequestFailedWithError:(NSError *)error {
    
    if (error.code < 0 && error.code >= -1021) {
     
        if (error.code != -1009 && error.code != -1003 && error.code != -1011) {
            [self toastWithMessage:[NSString stringWithFormat:@"网络不给力!\nError:%@",error.localizedDescription]];
        }else {
            [self toastWithMessage:[NSString stringWithFormat:@"请检查网络!\nError:%@",error.localizedDescription]];
        }
    }
}

+ (void)alertWhenServerReturnError:(id)responseObject {
    
    int code = [responseObject[@"code"] intValue];
}

+ (AFSecurityPolicy *)customSecurityPolicy {
    
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"httpsca" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    /*
     AFSSLPinningModeNone: 代表客户端无条件地信任服务器端返回的证书。
     AFSSLPinningModePublicKey: 代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行。
     AFSSLPinningModeCertificate: 代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
     */
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

//设备型号
+ (NSString*)deviceString {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

+ (void)setSession:(AFHTTPSessionManager *)manager {

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:[self userAgentValue] forHTTPHeaderField:@"user-Agent"];
}

//userAgent
+ (NSString *)userAgentValue {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *string = [NSString stringWithFormat:@"{\"code\":\"%@\",\"platform\":\"iOS\",\"version\":\"%@\",\"appversion\":\"%@\"}",[[UIDevice currentDevice].identifierForVendor UUIDString],[UIDevice currentDevice].systemVersion,app_Version];
    
    return string;
}

//创建带小图标的富文本
+ (NSAttributedString *)createAttributedStringWithImageName:(NSString *)imageName bounds:(CGRect)rect str:(NSString *)str {
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:imageName];
    attach.bounds = rect;
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:imageStr];
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",str]];
    if ([str isEqualToString:@"-1"]) {
        
        attributeStr = [[NSAttributedString alloc] initWithString:@"  "];
    }
    
    [attributedString appendAttributedString:attributeStr];
    
    return attributedString;
}

//自定义MJRefreshGifHeader
+ (MJRefreshNormalHeader *)refreshHeaderWithTarget:(id)target action:(SEL)selector {

//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:selector];
//
//    NSMutableArray *normalImages = [NSMutableArray array];
//    NSMutableArray *refreshImages = [NSMutableArray array];
//
//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refrsh01"]];
//    [normalImages addObject:image];
//
//    for (int i = 1; i <= 5; i++) {
//
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refrsh%02d",i]];
//        [refreshImages addObject:image];
//    }
//
//    [header setImages:normalImages forState:MJRefreshStateIdle];
//    [header setImages:refreshImages forState:MJRefreshStateRefreshing];
//    [header setImages:refreshImages forState:MJRefreshStatePulling];
//
//    header.lastUpdatedTimeLabel.hidden= YES;
//    header.stateLabel.hidden = YES;
//
//    return header;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:selector];
    header.automaticallyChangeAlpha = YES;
    
    return header;
}

//礼物初始数据
+ (NSMutableArray *)arrayWithGift {

    NSMutableArray *giftListMarr = [NSMutableArray array];
    
    //名字
    NSArray *nameArr = @[@"赞", @"气球", @"玫瑰", @"玩具熊", @"666", @"钻戒", @"吻", @"跑车", @"棒棒糖", @"咖啡", @"烟花", @"皇冠", @"香水", @"项链", @"糖果礼盒", @"白色跑车", @"粑粑", @"扎啤", @"抱抱", @"口红", @"水晶鞋", @"包包", @"游艇", @"飞机"];
    
    //素材
    NSArray *bigPicArr = @[
                           @[@"car3.png",@"car2.png",@"car1.png"],
                           @[@"car4.png",@"car1.png",@"car4.png",@"car1.png"],
                           @[@"car3.png",@"car2.png",@"car1.png"]
                           ];
    NSArray *soundArr = @[@"catrun",@"catdidi",@"catstop"];
    NSArray *resourcesArr = @[@{@"icon":@"oyell_zan06"},
                              @{@"icon":@"oyell_qiqiu"},
                              @{@"icon":@"oyell_rose"},
                              @{@"icon":@"oyell_xiong"},
                              @{@"icon":@"oyell_666"},
                              @{@"icon":@"oyell_ring"},
                              @{@"icon":@"oyell_kiss"},
                              @{@"icon":@"oyell_car5",@"bigPic":bigPicArr,@"sound":soundArr},
                              @{@"icon":@"oyell_bangbangt"},
                              @{@"icon":@"oyell_coffee"},
                              @{@"icon":@"oyell_yanhua"},
                              @{@"icon":@"oyell_hhuangguan"},
                              @{@"icon":@"ouell_xiangshui06"},
                              @{@"icon":@"oyell_xianglian"},
                              @{@"icon":@"oyell_liwu"},
                              @{@"icon":@"oyell_car10"},
                              @{@"icon":@"oyell_bianbian"},
                              @{@"icon":@"oyell_pijiu"},
                              @{@"icon":@"oyell_baobao"},
                              @{@"icon":@"oyell_kouhong06"},
                              @{@"icon":@"oyell_shoe"},
                              @{@"icon":@"oyell_bag"},
                              @{@"icon":@"oyell_youting06"},
                              @{@"icon":@"oyell_feiji06"}
                              ];
    //价格
    NSArray *priceArr = @[
                          @1,@3,@5,@10,@50,@99,@199,@500,
                          @1,@3,@5,@10,@50,@99,@199,@2000,
                          @3,@5,@10,@30,@50,@200,@6666,@9999
                          ];
    //积分
    NSArray *integralArr= @[
                            @10,@30,@50,@100,@500,@990,@1990,@5000,
                            @10,@30,@50,@100,@500,@990,@1990,@200000,
                            @30,@50,@100,@300,@500,@2000,@6660,@99990
                            ];
    
    //最高重复上限
    NSArray *repeatHighLinesArr = @[@30,@30,@30,@30,@30,@30,@1,@1,@30,@30,@30,@30,@30,@30,@30,@1,@30,@30,@30,@30,@30,@30,@1,@1];
    
    NSArray *animationTypeArr = @[@0,@0,@0,@0,@0,@0,@1,@2,@0,@0,@0,@0,@0,@0,@0,@2,@0,@0,@0,@0,@0,@0,@2,@2];
    
    //版本号
    NSString *edition = @"0.0.0";
    NSMutableArray *editionArr = [NSMutableArray array];
    for (int i = 0; i < 24; i++) {
        
        [editionArr addObject:edition];
    }
    
    NSMutableArray *paramsMarr = [NSMutableArray array];
    NSMutableArray *giftMarr = [NSMutableArray array];
    
    for (int i = 0; i < 24; i++) {
        
        NSDictionary *dic = @{@"giftid":@(i),@"edition":editionArr[i]};
        [paramsMarr addObject:dic];

        NSDictionary *giftDic = @{@"id":@(i),@"name":nameArr[i],@"resources":resourcesArr[i],@"price":priceArr[i],@"integral":integralArr[i],@"repeatHighLines":repeatHighLinesArr[i],@"animationType":animationTypeArr[i],@"edition":editionArr[i]};
        [giftMarr addObject:giftDic];
    }
    [giftListMarr addObject:paramsMarr];
    [giftListMarr addObject:giftMarr];
    
    return giftListMarr;
}

//3秒提示框
+ (void)toastWithMessage:(NSString *)msg {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

//截断名字长度
+ (NSString *)substringName:(NSString *)name {
    
    if (name.length > 8) {
        
        name = [name substringToIndex:7];
        name = [name stringByAppendingString:@"..."];
    }
    
    return name;
}

//画cell的圆角
+ (void)roundWithCell:(UITableViewCell *)cell withTableview:(UITableView *)tableView withIdentifier:(int)identifier addline:(BOOL)addLine{

    // 圆角弧度半径
    CGFloat cornerRadius = 5.f;
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    CGRect bounds = CGRectInset(cell.bounds, kSpace, 0);
    
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    
    //全部圆角1
    if (identifier == 1) {
        
        CGPathMoveToPoint(pathRef, nil, CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    }else if (identifier == 2) {
        // 初始起点为cell的左下角坐标,画上面的圆角
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (identifier == 3) {
        // 初始起点为cell的左上角坐标,画下面的圆角
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // 添加分隔线图层
    if (addLine == YES) {
        CALayer *lineLayer = [[CALayer alloc] init];
        CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
        lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
        // 分隔线颜色取自于原来tableview的分隔线颜色
        lineLayer.backgroundColor = tableView.separatorColor.CGColor;
        [layer addSublayer:lineLayer];
    }
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    //cell的背景view
    //cell.selectedBackgroundView = roundView;
    cell.backgroundView = roundView;
    
    //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = tableView.separatorColor.CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
}

+ (void)storePersonalInfoWithModel:(UserModel *)model {
    
    [WYFileManager setCustomObject:model forKey:@"userModel"];
    [DEFAULTS setObject:model.token forKey:@"token"];
    [DEFAULTS setObject:model.user_id forKey:@"userid"];
    [DEFAULTS setObject:model.name forKey:@"name"];
    [DEFAULTS synchronize];
    
    [AccountManager sharedAccountManager].token = [DEFAULTS objectForKey:@"token"];
    [AccountManager sharedAccountManager].userID = [DEFAULTS objectForKey:@"userid"];
}

+ (void)changeReturnButton:(UIViewController *)controller {
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithTitle:@""style:UIBarButtonItemStylePlain target:nil action:nil];
    bar.tintColor = [UIColor lightGrayColor];
    controller.navigationItem.backBarButtonItem = bar;
}

//提示框
+ (void)toastWithMsg:(NSString *)msg {
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Tips"
                                                        message:msg
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"close",nil) otherButtonTitles:nil];
    [alerView show];
}

// http 请求 时间戳
+ (void)HTTPTimeData {
    UserModel *usermodel = [WYFileManager getCustomObjectWithKey:@"userModel"];
    long long time = [self getDateTimeTOMilliSeconds:[NSDate date]];
    [DataService postWithURL:@"rest3/v1/Logger/test" type:1 params:nil fileData:nil success:^(id data) {
        long long tempTime = [self getDateTimeTOMilliSeconds:[NSDate date]];
        NSString *timeStr = [NSString stringWithFormat:@"%llu",tempTime-time];
        NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        NSDictionary *dic = @{@"type":@"http.time",@"device_id":uuid,@"time":timeStr,@"user_id":usermodel.user_id,@"longitude":usermodel.longitude,@"latitude":usermodel.latitude};
        [DataService postWithURL:@"rest3/v1/Logger/submit" type:1 params:dic fileData:nil success:^(id data) {
            
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime {
    
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    
    NSLog(@"转换的时间戳=%f",interval);
    
    long long totalMilliseconds = interval*1000 ;
    
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    
    return totalMilliseconds;
    
}
+ (NSString *)arrayToString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)passwordMD5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}


@end
