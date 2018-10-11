//
//  MusicPlayerViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/26.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "MusicPalyerView.h"
#import "CommonPrex.h"
#import "YPHeaderFooterView.h"
#import <Masonry.h>
#import "MusicViewController.h"
#import "DataService.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicModel.h"
#import <MJExtension/MJExtension.h>
#import "SystemMusicTableViewCell.h"
#import <ZegoLiveRoom/zego-api-mediaplayer-oc.h>
#import <MBProgressHUD.h>

@interface MusicPlayerViewController ()<UITableViewDelegate,UITableViewDataSource,MPMediaPickerControllerDelegate,ZegoMediaPlayerEventDelegate>

@property(nonatomic,strong)MusicPalyerView *playerView;
@property(nonatomic,strong)UITableView *musicTableView;
@property(nonatomic,strong)NSMutableArray *musicListMarr;
@property(nonatomic,strong)NSArray *musicArr;
@property(nonatomic,strong)ZegoMediaPlayer *musicPlayer;
@property(nonatomic,assign)BOOL isPlay;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UIButton *addMusic;
@property(nonatomic,strong)UIButton *clearAllBtn;
@property(nonatomic,strong)UIView *coverView;

@property(nonatomic,strong)UIImageView *musicImageView;
@property(nonatomic,strong)UILabel *musicTitleLabel;
@property(nonatomic,strong)UILabel *musicArtistLabel;

@end

@implementation MusicPlayerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 初始化SubView
        [self setupUI];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if ([AccountManager sharedAccountManager].isPlay) {
        
        [self rotationStart];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [DataService changeReturnButton:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Music";
    
    _musicListMarr = [NSMutableArray array];
    _musicPlayer = [[ZegoMediaPlayer alloc] initWithPlayerType:MediaPlayerTypeAux];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *musicDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *musicPath = [musicDocument stringByAppendingPathComponent:@"music.plist"];
    if (![fileManager fileExistsAtPath:musicPath]) {
        //没有文件
        [self.view insertSubview:self.coverView belowSubview:_addMusic];

    }else {
        _musicListMarr = [NSMutableArray arrayWithContentsOfFile:musicPath];
        if (_musicListMarr.count == 0) {
            [self.view insertSubview:self.coverView belowSubview:_addMusic];
        }
        _musicArr = [MusicModel mj_objectArrayWithKeyValuesArray:_musicListMarr];
        [_musicTableView reloadData];
    }
    [_musicPlayer setDelegate:self];
}

- (void)setupUI {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 240)];
    if (IS_IPHONE_X) {
        topView.frame = CGRectMake(0, 88, kScreenWidth, 240);
    }
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    [topView addSubview:self.playerView];
    
    UIImageView *musicBackImageView = [[UIImageView alloc] init];
    musicBackImageView.image = [UIImage imageNamed:@"player"];
    [topView addSubview:musicBackImageView];
    [musicBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(topView.mas_left).offset(15);
        make.top.mas_equalTo(topView.mas_top).offset(20);
        make.height.width.equalTo(@70);
    }];
    UIImageView *right = [[UIImageView alloc] init];
    right.image = [UIImage imageNamed:@"player1"];
    [topView addSubview:right];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(musicBackImageView.mas_right).offset(-kSpace-2);
        make.top.mas_equalTo(musicBackImageView.mas_top);
        make.width.offset(30);
        make.height.offset(50);
    }];
    
    _musicImageView = [[UIImageView alloc] init];
    _musicImageView.image = [UIImage imageNamed:@"Defaultcover"];
    _musicImageView.layer.cornerRadius = 25;
    _musicImageView.layer.masksToBounds = YES;
    [musicBackImageView addSubview:_musicImageView];
    [_musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(musicBackImageView.mas_centerX);
        make.centerY.mas_equalTo(musicBackImageView.mas_centerY);
        make.width.height.equalTo(@50);
    }];
    
    _musicTitleLabel = [[UILabel alloc] init];
    _musicTitleLabel.textColor = k51Color;
    _musicTitleLabel.font = [UIFont systemFontOfSize:20];
    _musicTitleLabel.text = @"Music";
    [_musicTitleLabel sizeToFit];
    [topView addSubview:_musicTitleLabel];
    [_musicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(right.mas_right).offset(15);
        make.top.mas_equalTo(musicBackImageView.mas_top).offset(kSpace);
    }];
    
    _musicArtistLabel = [[UILabel alloc] init];
    _musicArtistLabel.font = [UIFont systemFontOfSize:14];
    _musicArtistLabel.textColor = k153Color;
    _musicArtistLabel.text = @"Artist";
    [_musicArtistLabel sizeToFit];
    [topView addSubview:_musicArtistLabel];
    [_musicArtistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_musicTitleLabel.mas_left);
        make.bottom.mas_equalTo(musicBackImageView.mas_bottom).offset(-kSpace);
    }];
    
    _musicTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, kScreenWidth, kScreenHeight-240) style:UITableViewStylePlain];
    _musicTableView.dataSource = self;
    _musicTableView.delegate = self;
    _musicTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_musicTableView registerClass:[YPHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"musicHeader"];
    [self.view addSubview:_musicTableView];
    [_musicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    _addMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addMusic setImage:[UIImage imageNamed:@"Addbutton"] forState:UIControlStateNormal];
    [_addMusic addTarget:self action:@selector(addMusicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addMusic];
    [_addMusic mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
        make.width.offset(160);
        make.height.offset(50);
    }];
}

- (MusicPalyerView *)playerView {
    if (!_playerView) {
        
        _playerView = [[MusicPalyerView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 120)];
        [_playerView.playOrPauseButton addTarget:self action:@selector(playOrPauseButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.nextSongButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_playerView.preSongButtton addTarget:self action:@selector(preButtonAction) forControlEvents:UIControlEventTouchUpInside];
        // 播放进度条添加响应事件
        [_playerView.songSlider addTarget:self //事件委托对象
                                   action:@selector(playbackSliderValueChanged) //处理事件的方法
                         forControlEvents:UIControlEventValueChanged//具体事件
         ];
        [_playerView.songSlider addTarget:self //事件委托对象
                                   action:@selector(playbackSliderValueChangedFinish) //处理事件的方法
                         forControlEvents:UIControlEventTouchUpInside//具体事件
         ];
    }
    return _playerView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 304, kScreenWidth, kScreenHeight-304)];
        _coverView.backgroundColor = [UIColor whiteColor];
        
        UILabel *noLabel = [[UILabel alloc] init];
        noLabel.font = [UIFont systemFontOfSize:24];
        noLabel.textColor = k153Color;
        noLabel.text = @"NO MUSIC";
        [noLabel sizeToFit];
        [_coverView addSubview:noLabel];
        
        UILabel *supportLabel = [[UILabel alloc] init];
        supportLabel.textColor = k153Color;
        supportLabel.font = [UIFont systemFontOfSize:15];
        supportLabel.textAlignment = NSTextAlignmentCenter;
        supportLabel.numberOfLines = 0;
        supportLabel.text = @"iOS only supports importing songs from iTunes";
        [supportLabel sizeToFit];
        [_coverView addSubview:supportLabel];
        
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.mas_equalTo(_coverView.mas_centerX);
            make.centerY.mas_equalTo(_coverView.mas_centerY).offset(-50);
        }];
        [supportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(_coverView.mas_left).offset(15);
            make.right.mas_equalTo(_coverView.mas_right).offset(15);
            make.top.mas_equalTo(noLabel.mas_bottom).offset(25);
        }];
    }
    return _coverView;
}


#pragma mark - 点击事件
-(void) playOrPauseButtonAction {
    
    if ([AccountManager sharedAccountManager].isPlay) {
        if (_playerView.playOrPauseButton.selected == NO) {
            [_playerView.playOrPauseButton setImage:[UIImage imageNamed:@"icon-Playing"] forState:UIControlStateNormal];
            [_musicPlayer pause];
            [self resumeAnimation];
            
        }else {
            [_playerView.playOrPauseButton setImage:[UIImage imageNamed:@"icon-timeout"] forState:UIControlStateNormal];
            [_musicPlayer resume];
            [self pauseAnimation];
        }
        _playerView.playOrPauseButton.selected = !_playerView.playOrPauseButton.selected;
    }
}

-(void) nextButtonAction {
    if (_index == _musicArr.count-1) {
        [DataService toastWithMessage:@"The last one"];
    }else {
        _index += 1;
        MusicModel *model = _musicArr[_index];
        [_musicPlayer stop];
        [_musicPlayer start:model.url Repeat:YES];
    }
}

-(void) preButtonAction {
    if (_index == 0) {
        [DataService toastWithMessage:@"The first one"];
    }else {
        _index -= 1;
        MusicModel *model = _musicArr[_index];
        [_musicPlayer stop];
        [_musicPlayer start:model.url Repeat:YES];
    }
}

//添加音乐
- (void)addMusicAction {
    MPMediaPickerController *mpc = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAnyAudio];
    
    mpc.delegate = self;//委托
    
    mpc.prompt = @"Choice Music";//提示文字
    
    mpc.allowsPickingMultipleItems = YES;//是否允许一次选择多个
    
    [self presentViewController:mpc animated:YES completion:nil];
    
    _editBtn.selected = YES;
    [self editBtnAction:_editBtn];
}

//编辑tableview
- (void)editBtnAction:(UIButton *)sender {
    
    if (sender.selected == NO) {
        sender.selected = YES;
        [_musicTableView setEditing:YES animated:YES];
        [sender setTitle:@"DONE" forState:UIControlStateNormal];
        _addMusic.hidden = YES;
        
        if (!_clearAllBtn) {
            
            _clearAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-44, kScreenWidth, 44)];
            if (IS_IPHONE_X) {
                _clearAllBtn.frame = CGRectMake(0, kScreenHeight-44-34, kScreenWidth, 44);
            }
            _clearAllBtn.backgroundColor = kNavColor;
            [_clearAllBtn setTitle:@"Clear All Content" forState:UIControlStateNormal];
            _clearAllBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            [_clearAllBtn addTarget:self action:@selector(clearBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_clearAllBtn];
        }
    }else {
        sender.selected = NO;
        [_musicTableView setEditing:NO animated:YES];
        [sender setTitle:@"EDIT" forState:UIControlStateNormal];
        _addMusic.hidden = NO;
        if (_clearAllBtn) {
            [_clearAllBtn removeFromSuperview];
            _clearAllBtn = nil;
        }
    }
    
}

//清空所有
- (void)clearBtnAction {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You are kicked down" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Clear" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *musicDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *musicPath = [musicDocument stringByAppendingPathComponent:@"music.plist"];
        NSError *error;
        [fileManager removeItemAtPath:musicPath error:&error];
        [_musicListMarr removeAllObjects];
        _musicArr = [NSArray array];
        [_musicTableView reloadData];
        _addMusic.hidden = NO;
        if (_clearAllBtn) {
            [_clearAllBtn removeFromSuperview];
            _clearAllBtn = nil;
        }
        
        [self.view insertSubview:self.coverView belowSubview:_addMusic];
    }];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (NSString *)ConvertStrToTime:(long)timeStr {
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:timeStr/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"mm:ss"];//根据自己需要yyyy/MM/dd HH:mm:ss 截取自己需要的
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
}

//slider赋值
- (void)sliderAction {
    _playerView.songSlider.value = (float)_musicPlayer.getCurrentDuration/(float)_musicPlayer.getDuration;
    NSString *currentTime = [self ConvertStrToTime:_musicPlayer.getCurrentDuration];
    _playerView.currentTimeLabel.text = currentTime;
}

//更新时间
-(void) updateTime {
    
    long time = _playerView.songSlider.value * _musicPlayer.getDuration;
    NSString *currentTime = [self ConvertStrToTime:time];
    _playerView.currentTimeLabel.text = currentTime;
    [_musicPlayer seekTo:time];
}

#pragma mark - 保存音乐到本地沙盒
- (void) convertToMp3: (MPMediaItem *)song{
    
    for (MusicModel *model in _musicArr) {
        if ([model.title isEqualToString:song.title]) {
            [DataService toastWithMsg:@"Music already exists"];
            return;
        }
    }
    
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.label.text = @"Loading...";
    }
    
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
    
    NSString *exportFile = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",[[song.assetURL.absoluteString componentsSeparatedByString:@"="] lastObject]]];
    
    NSError *error1;
    
    if([fileManager fileExistsAtPath:exportFile]){
        
        [fileManager removeItemAtPath:exportFile error:&error1];
    }
    NSString *musicDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *musicPath = [musicDocument stringByAppendingPathComponent:@"music.plist"];
    if ([fileManager fileExistsAtPath:musicPath]) {
        [fileManager removeItemAtPath:musicPath error:&error1];
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
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [DataService toastWithMsg:@"Error"];
                     [_hud hideAnimated:YES];
                 });
                 break;
                 
             }
             case AVAssetExportSessionStatusCompleted: {
                 NSLog (@"AVAssetExportSessionStatusCompleted");
                 
                 NSString *artist = @"";
                 if (song.title) {
                     artist = song.title;
                 }
                 NSDictionary *dic = @{@"title":song.title,@"artist":artist,@"url":exportFile,@"isSave":@YES};
                 if (song.artwork != nil) {
                     NSDictionary *dic = @{@"title":song.title,@"artist":artist,@"url":exportFile,@"isSave":@YES,@"artwork":song.artwork};
                 }
                 
                 [_musicListMarr addObject:dic];
                 [_musicListMarr writeToFile:musicPath atomically:YES];
                 
                 dispatch_sync(dispatch_get_main_queue(), ^{
                    
                     NSArray *arr = [NSArray arrayWithContentsOfFile:musicPath];
                     if (arr.count > 0) {
                         [self.coverView removeFromSuperview];
                         self.coverView = nil;
                     }
                     _musicArr = [MusicModel mj_objectArrayWithKeyValuesArray:arr];
                     [_musicTableView reloadData];
                     [_hud hideAnimated:YES];
                 });
                 
                 NSLog(@"%@,musicPath:%@",dic,musicPath);
                 break;
                 
             }
             case AVAssetExportSessionStatusUnknown: {
                 
                 NSLog (@"AVAssetExportSessionStatusUnknown");
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [DataService toastWithMsg:@"Error"];
                     [_hud hideAnimated:YES];
                 });
                 break;
                 
             }
             case AVAssetExportSessionStatusExporting: {
                 
                 NSLog (@"AVAssetExportSessionStatusExporting");
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [DataService toastWithMsg:@"Error"];
                     [_hud hideAnimated:YES];
                 });
                 break;
                 
             }
             case AVAssetExportSessionStatusCancelled: {
                 
                 NSLog (@"AVAssetExportSessionStatusCancelled");
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [DataService toastWithMsg:@"Error"];
                     [_hud hideAnimated:YES];
                 });
                 break;
                 
             }
             case AVAssetExportSessionStatusWaiting: {
                 
                 NSLog (@"AVAssetExportSessionStatusWaiting");
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [DataService toastWithMsg:@"Error"];
                     [_hud hideAnimated:YES];
                 });
                 break;
                 
             }
             default:
                 
             { NSLog (@"didn't get export status");
                 dispatch_sync(dispatch_get_main_queue(), ^{
                     [DataService toastWithMsg:@"Error"];
                     [_hud hideAnimated:YES];
                 });
                 break;
                 
             }
         }
     }];
}
#pragma mark 音频代理方法
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    /*insert your code*/
    
    for (MPMediaItem* item in [mediaItemCollection items]) {
        
        //item里有你想要的音频信息
        [self convertToMp3:item];//缓存到沙河路径
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    NSLog(@"Media Picker was cancelled");
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPlayStart {
    [AccountManager sharedAccountManager].isPlay = YES;
    NSLog(@"开始播放");
}
- (void)onPlayError:(int)code {
    [AccountManager sharedAccountManager].isPlay = NO;
    NSLog(@"onPlayError:%d",code);
}
- (void)onAudioBegin {
    NSLog(@"onAudioBegin");
    [_playerView.playOrPauseButton setImage:[UIImage imageNamed:@"icon-Playing"] forState:UIControlStateNormal];
    _playerView.playOrPauseButton.selected = YES;
    _playerView.durationTimeLabel.text = [self ConvertStrToTime:_musicPlayer.getDuration];
    MusicModel *model = _musicArr[_index];
    _musicTitleLabel.text = model.title;
    _musicArtistLabel.text = model.artist;
    
    [self rotationStart];
    if (_musicTimer) {
        
        [_musicTimer invalidate];
        _musicTimer = nil;
    }
   _musicTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sliderAction) userInfo:nil repeats:YES];
}
- (void)onPlayEnd {
    
    [AccountManager sharedAccountManager].isPlay = NO;
    if (_musicTimer) {
        
        [_musicTimer invalidate];
    }
    NSLog(@"onPlayEnd");
}

#pragma - mark 进度条改变值触发
-(void) playbackSliderValueChanged {
    
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if ([AccountManager sharedAccountManager].isPlay == NO) {
        
        [_playerView.playOrPauseButton setImage:[UIImage imageNamed:@"icon-Playing"] forState:UIControlStateNormal];
        [_musicPlayer pause];
        [_musicPlayer setVolume:0];
    }
}

-(void) playbackSliderValueChangedFinish {
    
    // 更新播放时间
    [self updateTime];
    
    //如果当前时暂停状态，则自动播放
    if ([AccountManager sharedAccountManager].isPlay == NO) {
        
        [_playerView.playOrPauseButton setImage:[UIImage imageNamed:@"icon-Playing"] forState:UIControlStateNormal];
        [_musicPlayer resume];
        [_musicPlayer setVolume:30];
    }
}

#pragma mark - 旋转动画
- (void)rotationStart {
    [_musicImageView.layer removeAllAnimations];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                   //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
                                   animation.fromValue = [NSNumber numberWithFloat:0.f];
                                   animation.toValue = [NSNumber numberWithFloat: M_PI *2];
                                   animation.duration = 3;
                                   animation.autoreverses = NO;
                                   animation.fillMode = kCAFillModeForwards;
                                   animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
                                   [_musicImageView.layer addAnimation:animation forKey:nil];
}

//暂停动画

- (void)pauseAnimation {
    
    //1.取出当前时间，转成动画暂停的时间
    
    CFTimeInterval pauseTime = [_musicImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    _musicImageView.layer.speed = 0.0;
    
    _musicImageView.layer.timeOffset = pauseTime;
}

//恢复动画
- (void)resumeAnimation {
    //1.将动画的时间偏移量作为暂停的时间点
    CFTimeInterval pauseTime = _musicImageView.layer.timeOffset;
    _musicImageView.layer.speed = 1.0;
    _musicImageView.layer.timeOffset = 0.0;
    CFTimeInterval timeSincePause = [_musicImageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    _musicImageView.layer.beginTime = timeSincePause;
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YPHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"musicHeader"];
    header.text = @"Music List";
    
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
        [_editBtn setTitleColor:kNavColor forState:UIControlStateNormal];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:_editBtn];
        [_editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(header.mas_right).offset(-15);
            make.centerY.mas_equalTo(header.mas_centerY);
            make.height.offset(35);
            make.width.offset(50);
        }];
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

//为了上面的方法有效果 ios11 必须实现下面方法
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SystemMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music"];
    if (!cell) {
        cell = [[SystemMusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"music"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MusicModel *model = _musicArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicModel *model = _musicArr[indexPath.row];
    [_musicPlayer stop];
    [_musicPlayer start:model.url Repeat:YES];
    _index = indexPath.row;
    
    if (model.artwork != nil) {
        UIImage *image = [model.artwork imageWithSize:CGSizeMake(60, 60)];
        _musicImageView.image = image;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *musicDocument = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *musicPath = [musicDocument stringByAppendingPathComponent:@"music.plist"];
    [_musicListMarr removeObjectAtIndex:indexPath.row];
    [_musicListMarr writeToFile:musicPath atomically:YES];
    _musicArr = [MusicModel mj_objectArrayWithKeyValuesArray:_musicListMarr];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    if (_musicListMarr.count == 0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:musicPath error:&error];
        _musicArr = [NSArray array];
        _addMusic.hidden = NO;
        if (_clearAllBtn) {
            [_clearAllBtn removeFromSuperview];
            _clearAllBtn = nil;
        }
        [self.view insertSubview:self.coverView belowSubview:_addMusic];
    }
}

- (void)dealloc {
    NSLog(@"musicPlayer被销毁");
    if (_musicTimer) {
        [_musicTimer invalidate];
        _musicTimer = nil;
    }
    [_musicPlayer stop];
    [_musicPlayer uninit];
    _musicPlayer = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
