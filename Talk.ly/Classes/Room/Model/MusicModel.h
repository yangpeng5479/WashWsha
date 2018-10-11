//
//  MusicModel.h
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/27.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicModel : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *artist;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)BOOL isSave;
@property(nonatomic,strong)MPMediaItemArtwork *artwork;

@end
