//
//  NSDictionary+Jsonstring.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/3/22.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Jsonstring)

-(NSString *)dictionaryToJsonString;
+(NSDictionary *)dictionaryWithJsonString:(NSString *)str;
@end
