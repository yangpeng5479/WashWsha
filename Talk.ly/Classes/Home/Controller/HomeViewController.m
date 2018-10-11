//
//  HomeViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/2/6.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "HomeViewController.h"
#import "CommonPrex.h"
#import <Masonry.h>
#import <MJExtension.h>
#import "YPHeaderFooterView.h"
#import "DataService.h"
#import "RoomModel.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "RoomViewController.h"
#import "ChatRoomModel.h"
#import <MBProgressHUD.h>
#import "MusicViewController.h"
#import "ActivityRoomViewController.h"
#import "STDPingServices.h"
#import "WYFileManager.h"
#import "JSViewController.h"
#import "SearchViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "RoomCollectionView.h"
#import "MessageViewController.h"
#import "LivePlayerViewController.h"
#import "ActivityModel.h"
#import "GiftModel.h"
#import <SDCycleScrollView.h>
#import "CustomBannerCollectionViewCell.h"
#import "BannerModel.h"
#import "BannerWebViewController.h"


@interface HomeViewController ()<UICollectionViewDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)RoomCollectionView *roomCV;
@property(nonatomic,strong)NSMutableArray *allRoomListArr;
@property(nonatomic,strong)ChatRoomModel *chatModel;
@property(nonatomic,strong)NSMutableArray *totalArr;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSMutableArray *tempGiftListMarr;
@property(nonatomic,strong)STDPingServices *pingServices;
@property(nonatomic,copy)NSString *pingStr;
@property(nonatomic,strong)UIView *topBgvie;
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *imageURLStrings;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)NSArray *bannerArr;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //设置打开抽屉模式
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [DataService changeReturnButton:self];
    
    self.page = 1;
    
    //检测网络
    [self pingTimeData];
    MJWeakSelf;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf stopPing];
    });
    
    _topBgvie = [[UIView alloc] initWithFrame:CGRectMake(2*kSpace, 4*kSpace, kScreenWidth-4*kSpace, 40)];
    _topBgvie.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topBgvie];
    
    UserModel *model = [WYFileManager getCustomObjectWithKey:@"userModel"];
    UIButton *userIconImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    userIconImageButton.layer.cornerRadius = 20;
    userIconImageButton.layer.masksToBounds = YES;
    [userIconImageButton sd_setImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon-user"]];
    [_topBgvie addSubview:userIconImageButton];
    [userIconImageButton addTarget:self action:@selector(userIconImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-7*kSpace, 0, 40, 40)];;
    [searchBtn setImage:[UIImage imageNamed:@"icon-searh"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBgvie addSubview:searchBtn];
    
    UIButton *messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(searchBtn.left-5*kSpace, 0, 40, 40)];
    [messageBtn setImage:[UIImage imageNamed:@"icon-message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_topBgvie addSubview:messageBtn];
    
    
    [self.view addSubview:self.roomCV];
    
    _imageURLStrings = [NSMutableArray array];
    _bannerArr = [NSArray array];
    
    [self loadGiftData];
    [self getBannerData];
    [self loadAllRoomListDta];
}

#pragma mark - 懒加载
- (RoomCollectionView *)roomCV {
    if (!_roomCV) {
        MJWeakSelf;
        _roomCV = [[RoomCollectionView alloc] initWithFrame:CGRectMake(0, 90, kScreenWidth, kScreenHeight-90)];
        _roomCV.delegate = self;
        [_roomCV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeheader"];
        _roomCV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf loadAllRoomListDta];
        }];
        [_roomCV addSubview:self.bannerView];
    }
    return _roomCV;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"icon-people"]];
        _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _bannerView.autoScrollTimeInterval = 3;
    }
    return _bannerView;
}

#pragma mark - 获取官方礼物
- (void)loadGiftData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"giftList.plist"];
    
    _tempGiftListMarr = [NSMutableArray arrayWithContentsOfFile:filePath];
    if ([DEFAULTS objectForKey:@"token"]) {
        NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
        [DataService postWithURL:@"rest3/v1/Gift/get_gift_list" type:1 params:dic fileData:nil success:^(id data) {
            NSLog(@"%@",data);
            
            NSMutableArray *arr = data[@"data"][@"gift_list"];
            _tempGiftListMarr = [NSMutableArray arrayWithArray:arr];
            [_tempGiftListMarr writeToFile:filePath atomically:YES];
            [AccountManager sharedAccountManager].giftListMarr = _tempGiftListMarr;
            [AccountManager sharedAccountManager].giftModelMarr = [GiftModel mj_objectArrayWithKeyValuesArray:_tempGiftListMarr];
            for (int i = 0; i < [AccountManager sharedAccountManager].giftModelMarr.count; ++i) {
                GiftModel *model = [AccountManager sharedAccountManager].giftModelMarr[i];
                model.gift_image_key = [AccountManager sharedAccountManager].imageArr[i];
                //                NSLog(@"appdelegate ==== =====%@",model.gift_image_key);
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark - 获取轮播图数据
- (void)getBannerData {
    [DataService postWithURL:@"rest3/v1/Banner/getBannerlist" type:1 params:nil fileData:nil success:^(id data) {
        NSLog(@"getBannerData:%@",data);
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"];
            _bannerArr = [BannerModel mj_objectArrayWithKeyValuesArray:arr];
            for (BannerModel *model in _bannerArr) {
                [_imageURLStrings addObject:model.image_url];
            }
            _bannerView.imageURLStringsGroup = _imageURLStrings;
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 获取数据-活动
- (void)loadCurrentActivity {
    
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Answer/getCurrActivity" type:1 params:dic fileData:nil success:^(id data) {

        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"][@"curr_activity"];
            ActivityModel *model = [ActivityModel mj_objectWithKeyValues:diction];
            
                _roomCV.model = model;
                
                [_roomCV reloadData];
        }
    } failure:^(NSError *error) {
        
        [DataService toastWithMessage:@"Network Error"];
    }];
}

#pragma mark - 语音
//获取全部房间
- (void)loadAllRoomListDta {
    
    if (self.page == 1 || !_roomCV.mj_header.refreshing) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.label.text = @"Loading...";
    }
    [self loadCurrentActivity];
    NSDictionary *dic = @{@"page":@(self.page),@"limit":@100,@"token":[DEFAULTS objectForKey:@"token"]};
    [DataService postWithURL:@"rest3/v1/Chatroom/homePageRooms" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"ALLROOM:%@",data);
        if ([data[@"status"] isEqual:@1]) {
            NSArray *arr = data[@"data"][@"rooms"];
            
            NSMutableArray *dataArr = [RoomModel mj_objectArrayWithKeyValuesArray:arr];
        
            if (self.page == 1) {
                [_roomCV.mj_header endRefreshing];
                [_roomCV.mj_footer endRefreshing];
                _allRoomListArr = dataArr;
            }else {
                if (dataArr.count) {
                    [_roomCV.mj_footer endRefreshing];
                }else {
                    [_roomCV.mj_footer endRefreshingWithNoMoreData];
                }
                [self.allRoomListArr addObjectsFromArray:dataArr];
            }
            
            _roomCV.dataArr = _allRoomListArr;
            [_roomCV reloadData];
            
            if (_allRoomListArr.count && !_roomCV.mj_footer) {
                MJWeakSelf;
                _roomCV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                    weakSelf.page++;
                    [weakSelf loadAllRoomListDta];
                }];
            }
            [_hud hideAnimated:YES];
        }
    } failure:^(NSError *error) {
        [_hud hideAnimated:YES];
        [_roomCV.mj_header endRefreshing];
        [DataService toastWithMessage:@"Error"];
        [_roomCV.mj_header endRefreshing];
        [_roomCV.mj_footer endRefreshing];
    }];
}

//权限
- (void)enterLimitData:(NSString *)chatroom_id WithType:(int)type {
    NSDictionary *dic = @{@"chatroom_id":chatroom_id,@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/chatroom/enterLimit" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *dataDic = data[@"data"];
            NSDictionary *limitDic = dataDic[@"enterLimit"];
            NSString *enter_limit = limitDic[@"enter_limit"];
            
            if ([enter_limit isEqualToString:@"all"]) {
                
                [self loadEnterRoomData:chatroom_id WithType:type];
            }else if ([enter_limit isEqualToString:@"friend"]) {
                if ([dataDic[@"is_friend"] isEqual:@0]) {
                    
                    [DataService toastWithMsg:@"Only friend enter room"];
                }else {
                    
                    [self loadEnterRoomData:chatroom_id WithType:type];
                }
            }else if ([enter_limit isEqualToString:@"password"]) {
                NSString *pass = limitDic[@"enter_pass_md5"];
                
                UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"Enter password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Please enter password";
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *passTF = passAlert.textFields.firstObject;
                    NSString *md5Str = [DataService passwordMD5:passTF.text];
                    if ([md5Str isEqualToString:pass]) {
                        [self loadEnterRoomData:chatroom_id WithType:type];
                    }else {
                        [DataService toastWithMsg:@"Password Error"];
                    }
                }];
                [passAlert addAction:cancel];
                [passAlert addAction:ok];
                [self presentViewController:passAlert animated:YES completion:nil];
            }
        }else if ([data[@"status"] integerValue] == 80001) {
            [DataService toastWithMsg:@"You blacklisted"];
        }else if ([data[@"status"] integerValue] == 20004) {
            [DataService toastWithMessage:@"Please login try again"];
        }else if ([data[@"status"] integerValue] == 40001) {
            [DataService toastWithMessage:@"The chat room is closed"];
        }
    } failure:^(NSError *error) {
        
    }];
}

//普通用户进入聊天室
- (void)loadEnterRoomData:(NSString *)chatroom_id WithType:(int)type{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    NSDictionary *dic = @{@"token":[DEFAULTS objectForKey:@"token"],@"chatroom_id":chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/enterChatroom" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"loadEnterRoomData:%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] isEqual:@40001]) {
            //房间已关闭
            [DataService toastWithMessage:@"Room Closed"];
        }else if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            ChatRoomModel *chatModel = [ChatRoomModel mj_objectWithKeyValues:diction];
                
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = @"Loading...";
            if (type == 1) {
                
                [AccountManager sharedAccountManager].zegoApi = nil;
                [ZegoLiveRoomApi setBusinessType:0];
                [ZegoLiveRoomApi setVerbose:YES];
                [ZegoLiveRoomApi setUserID:[DEFAULTS objectForKey:@"userid"] userName:[DEFAULTS objectForKey:@"name"]];
                Byte signkey[] = {0xb9,0xfa,0xc0,0xce,0x98,0x5c,0x36,0x16,0x9a,0x47,0xaf,0xe3,0x25,0x93,0x70,0x83,0x6c,0xf7,0xc6,0x26,0xc3,0x43,0x3b,0x1d,0xfe,0x68,0x4e,0x4a,0xed,0xf7,0x2d,0xcd};
                [AccountManager sharedAccountManager].zegoApi = [[ZegoLiveRoomApi alloc] initWithAppID:3969131734 appSignature:[NSData dataWithBytes:signkey length:32] completionBlock:^(int errorCode) {
                    
                    NSLog(@"初始化:%d",errorCode);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        if (errorCode == 0) {
                            
                            LivePlayerViewController *playerVC = [[LivePlayerViewController alloc] init];
                            playerVC.hidesBottomBarWhenPushed = YES;
                            playerVC.roomModel = chatModel;
                            [self.navigationController pushViewController:playerVC animated:YES];
                        }else {
                            [DataService toastWithMessage:@"Network connection error, please try again later"];
                        }
                    });
                }];
            }else {
                
                [AccountManager sharedAccountManager].zegoApi = nil;
                [ZegoLiveRoomApi setBusinessType:2];
                [ZegoLiveRoomApi setVerbose:YES];
                [ZegoLiveRoomApi setUserID:[DEFAULTS objectForKey:@"userid"] userName:[DEFAULTS objectForKey:@"name"]];
                Byte signkey[] = {0xb9,0xfa,0xc0,0xce,0x98,0x5c,0x36,0x16,0x9a,0x47,0xaf,0xe3,0x25,0x93,0x70,0x83,0x6c,0xf7,0xc6,0x26,0xc3,0x43,0x3b,0x1d,0xfe,0x68,0x4e,0x4a,0xed,0xf7,0x2d,0xcd};
                [AccountManager sharedAccountManager].zegoApi = [[ZegoLiveRoomApi alloc] initWithAppID:3969131734 appSignature:[NSData dataWithBytes:signkey length:32] completionBlock:^(int errorCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        if (errorCode == 0) {
                            
                            RoomViewController *roomVC = [[RoomViewController alloc] init];
                            roomVC.hidesBottomBarWhenPushed = YES;
                            roomVC.chatModel = chatModel;
                            roomVC.type = 3;
                            [self.navigationController pushViewController:roomVC animated:YES];
                        }else {
                            [DataService toastWithMessage:@"Network connection error, please try again later"];
                        }
                    });
                }];
            }
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Error"];
    }];
}

//ping api.italkly.com
- (void)pingTimeData {
    __weak HomeViewController *weakSelf = self;
    self.pingServices = [STDPingServices startPingAddress:@"api.italkly.com" callbackHandler:^(STDPingItem *pingItem, NSArray *pingItems) {
//        NSLog(@"%ld",(long)pingItem.status);
        if (pingItem.status != STDPingStatusFinished) {
            weakSelf.pingStr = [NSString stringWithFormat:@"%f",pingItem.timeMilliseconds];
        }
    }];
}

- (void)stopPing {
    
    NSLog(@"_pingStr:%@",_pingStr);
    UserModel *usermodel = [WYFileManager getCustomObjectWithKey:@"userModel"];
    NSString *uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
    NSDictionary *dic = @{@"type":@"ping.time",@"device_id":uuid,@"time":_pingStr,@"user_id":usermodel.user_id,@"longitude":usermodel.longitude,@"latitude":usermodel.latitude};
    [DataService postWithURL:@"rest3/v1/Logger/submit" type:1 params:dic fileData:nil success:^(id data) {
        [self.pingServices cancel];
        self.pingServices = nil;
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件
//进入活动
- (void)joinActivity {
    ActivityRoomViewController *activityRoomVC = [[ActivityRoomViewController alloc] init];
    activityRoomVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:activityRoomVC animated:YES];
}

//点击头像
- (void)userIconImageButtonAction {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)searchBtnClick {
    SearchViewController *search = [[SearchViewController alloc] init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

- (void)messageBtnAction {
    MessageViewController *message = [[MessageViewController alloc] init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

#pragma mark - collectionview's delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0) {
        [self joinActivity];
    }else {
        RoomModel *model = _allRoomListArr[indexPath.item-1];
        if ([model.type isEqualToString:@"radio"]) {
            [self enterLimitData:model.chatroom_id WithType:2];
        }else {
            [self enterLimitData:model.chatroom_id WithType:1];
        }
        
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
    BannerModel *model = _bannerArr[index];
    if ([model.type isEqualToString:@"page"]) {
        //跳转H5
        BannerWebViewController *bannerVC = [[BannerWebViewController alloc] init];
        bannerVC.pageurl = model.content_id;
        bannerVC.title = model.title;
        bannerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bannerVC animated:YES];
        
    }else if ([model.type isEqualToString:@"live"]) {
        
        [self enterLimitData:model.content_id WithType:1];
    }else if ([model.type isEqualToString:@"chat"]) {
        
        [self enterLimitData:model.content_id WithType:2];
    }else if ([model.type isEqualToString:@"activity"]){
        
        [self joinActivity];
    }else {
        
    }
}

- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != _bannerView) {
        return nil;
    }
    return [CustomBannerCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    CustomBannerCollectionViewCell *myCell = (CustomBannerCollectionViewCell *)cell;
    [myCell.imageView sd_setImageWithURL:_imageURLStrings[index]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
