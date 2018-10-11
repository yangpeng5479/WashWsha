//
//  NSDictionary+Jsonstring.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/22.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "NSDictionary+Jsonstring.h"

@implementation NSDictionary (Jsonstring)

-(NSString *)dictionaryToJsonString
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        return nil;
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
