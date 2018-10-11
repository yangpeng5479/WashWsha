//
//  MusicViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/1.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "MusicViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "CommonPrex.h"
#import "SystemMusicTableViewCell.h"
#import "DataService.h"
#import <MBProgressHUD.h>



@interface MusicViewController ()<UITableViewDelegate,UITableViewDataSource,MPMediaPickerControllerDelegate>

@property(nonatomic,strong)NSMutableArray *musicMarr;
@property(nonatomic,strong)AVAssetExportSession *mExporter;
@property(nonatomic,strong)NSMutableArray *musicListMarr;

@end

@implementation MusicViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Import music";
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    _musicMarr = [NSMutableArray array];
    _musicListMarr = [NSMutableArray array];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAnyAudio];
    
    mpc.delegate = self;//委托
    
    mpc.prompt =@"请选择音频文件";//提示文字
    
    mpc.allowsPickingMultipleItems=YES;//是否允许一次选择多个
    
    [self presentViewController:mpc animated:YES completion:nil];
    
    //获取列表
//    MPMediaQuery *allmp3 = [[MPMediaQuery alloc] init];
//    MPMediaPropertyPredicate *albumNamePredicate =
//    [MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithInt:MPMediaTypeMusic ] forProperty: MPMediaItemPropertyMediaType];
//    [allmp3 addFilterPredicate:albumNamePredicate];
//    NSLog(@"Logging items from a generic query...");
//    NSArray *allMusicItems = [NSArray array];
//    allMusicItems = [allmp3 items];
//
//    for (MPMediaItem *item in allMusicItems) {
//        if (item.assetURL) {
//            [_musicMarr addObject:item];
//        }
//    }
//    if (_musicMarr.count > 0) {
//
//        UITableView *listTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
//        listTableview.delegate = self;
//        listTableview.dataSource = self;
//        listTableview.tableFooterView = [[UIView alloc] init];
//        listTableview.rowHeight = 70;
//        [self.view addSubview:listTableview];
//        [listTableview reloadData];
//    }else {
//
//    }
}

#pragma mark - 保存音频

#pragma mark 音频代理方法
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    /*insert your code*/
    
    for (MPMediaItem* item in [mediaItemCollection items]) {
        
        //item里有你想要的音频信息
        [self convertToMp3:item];//缓存到沙河路径
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicMarr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list"];
    if (!cell) {
        cell = [[SystemMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"list"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MPMediaItem *item = _musicMarr[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",item.title,item.artist];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMediaItem *item = _musicMarr[indexPath.row];
    
    if (_musicListMarr.count > 0) {
        NSDictionary *dic = _musicListMarr[indexPath.row];
        if ([dic[@"isSave"] boolValue] == YES) {
            [DataService toastWithMessage:@"Music has been saved"];
            return;
        }
    }
    [self convertToMp3:item];
}

- (void) convertToMp3: (MPMediaItem *)song

{
    NSURL *url = [song valueForProperty:MPMediaItemPropertyAssetURL];
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSLog (@"compatible presets for songAsset: %@",[AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset]);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      
                                      initWithAsset: songAsset
                                      
                                      presetName: AVAssetExportPresetAppleM4A];
    
    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
//    NSString *exportDocument = [documentsDirectoryPath stringByAppendingPathComponent:@"music"];
    NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[[song.assetURL.absoluteString componentsSeparatedByString:@"="] lastObject]]];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFile])
        
    {
        [fileManager removeItemAtPath:exportFile error:&error1];
    }
    NSString *musicDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *musicPath = [musicDocument stringByAppendingPathComponent:@"music.plist"];
    if ([fileManager fileExistsAtPath:musicPath]) {
        [fileManager removeItemAtPath:exportFile error:&error1];
    }
    
    NSURL* exportURL = [NSURL fileURLWithPath:exportFile] ;
    
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^
     
     {
         int exportStatus = exporter.status;
         
         switch (exportStatus) {
             case AVAssetExportSessionStatusFailed: {
                 // log error to text view
                 
                 NSError *exportError = exporter.error;
                 NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                 break;
                 
             }
             case AVAssetExportSessionStatusCompleted: {
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 NSLog(@"%@\n%@",exporter.outputURL.absoluteString,exportFile);
                 NSDictionary *dic = @{@"title":song.title,@"artiest":song.artist,@"url":exportFile,@"isSave":@YES};
                 [_musicListMarr addObject:dic];
                 [_musicListMarr writeToFile:musicPath atomically:YES];
                 NSLog(@"%@,musicPath:%@",dic,musicPath);
                 break;
                 
             }
             case AVAssetExportSessionStatusUnknown: {
                 
                 NSLog (@"AVAssetExportSessionStatusUnknown");
                 
                 break;
                 
             }
             case AVAssetExportSessionStatusExporting: {
                 
                 NSLog (@"AVAssetExportSessionStatusExporting");
                 
                 break;
                 
             }
             case AVAssetExportSessionStatusCancelled: {
                 
                 NSLog (@"AVAssetExportSessionStatusCancelled");
                 
                 break;
                 
             }
             case AVAssetExportSessionStatusWaiting: {
                 
                 NSLog (@"AVAssetExportSessionStatusWaiting");
                 
                 break;
                 
             }
             default:
                 
             { NSLog (@"didn't get export status");
                 
                 break;
                 
             }
         }
     }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
