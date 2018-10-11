//
//  SearchViewController.m
//  GameTogether_iOS
//
//  Created by Mac on 16/4/21.
//  Copyright © 2016年 oyell. All rights reserved.
//

#import "SearchViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import "AccountManager.h"
#import <Masonry.h>
#import <TYTabPagerView.h>
#import "SearchTableView.h"
#import <MJExtension.h>
#import "RoomModel.h"
#import "UserModel.h"
#import "ProfileViewController.h"
#import <MBProgressHUD.h>
#import "ChatRoomModel.h"
#import "RoomViewController.h"
#import "DefaultView.h"
#import "CountryChoiseCollectionView.h"
#import <MJExtension.h>
#import "CountryModel.h"
#import "CountryViewController.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDelegate,TYTabPagerViewDataSource,TYTabPagerViewDelegate,UICollectionViewDelegate>
{
    UISearchBar *_searchBar;
    UITapGestureRecognizer *_tap;
    NSMutableArray *_roomMarr;
    NSMutableArray *_userMarr;
    NSArray *_titleArr;
    NSInteger _pageIndex;
}
@property(nonatomic,strong)SearchTableView *roomTableView;
@property(nonatomic,strong)SearchTableView *UserTableview;
@property (nonatomic, weak) TYTabPagerView *pagerView;
@property(nonatomic,strong)DefaultView *noRoomDefaultView;
@property(nonatomic,strong)DefaultView *noUserDefaultView;
@property(nonatomic,strong)CountryChoiseCollectionView *countryCV;
@property(nonatomic,strong)NSArray *countryArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [DataService changeReturnButton:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建视图
    [self _createViews];
    [self loadCountryData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _pagerView.frame = CGRectMake(0, 80.5, kScreenWidth,kScreenHeight-80.5);
}

- (DefaultView *)noRoomDefaultView {
    if (!_noRoomDefaultView) {
        _noRoomDefaultView = [[DefaultView alloc] initWithFrame:_roomTableView.bounds];
        _noRoomDefaultView.imageview.image = [UIImage imageNamed:@"search"];
        _noRoomDefaultView.tipsLabel.text = @"Can't search for the result you want";
    }
    return _noRoomDefaultView;
}
- (DefaultView *)noUserDefaultView {
    if (!_noUserDefaultView) {
        _noUserDefaultView = [[DefaultView alloc] initWithFrame:_UserTableview.bounds];
        _noUserDefaultView.imageview.image = [UIImage imageNamed:@"search"];
        _noUserDefaultView.tipsLabel.text = @"Can't search for the result you want";
    }
    return _noUserDefaultView;
}

#pragma mark - 加载及解析搜索数据
//获取国家
- (void)loadCountryData {
    [DataService postWithURL:@"rest3/v1/Country/getCountryList" type:1 params:nil fileData:nil success:^(id data) {
        if ([data[@"status"] isEqual:@1]) {
            NSArray *dataArr = data[@"data"];
            _countryArr = [CountryModel mj_objectArrayWithKeyValuesArray:dataArr];
            _countryCV.dataArr = _countryArr;
            [_countryCV reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)_loadSearchDataWithIndex:(NSInteger)index {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic = [NSDictionary dictionary];
    
    if (index == 0) {
        dic = @{@"page":@1,@"limit":@100,@"keyword":_searchBar.text};
        [DataService postWithURL:@"rest3/v1/Search/search_chatrooms" type:1 params:dic fileData:nil success:^(id data) {
            [hud hideAnimated:YES];
            if ([data[@"status"] integerValue] == 1) {
                NSArray *arr = data[@"data"][@"list"];
                _roomMarr = [RoomModel mj_objectArrayWithKeyValuesArray:arr];
                if (_roomMarr.count == 0) {
                    [_roomTableView addSubview:self.noRoomDefaultView];
                }else {
                    if (_noRoomDefaultView) {
                        [_noRoomDefaultView removeFromSuperview];
                        _noRoomDefaultView = nil;
                    }
                }
                _roomTableView.dataArr = _roomMarr;
                _roomTableView.pageIndex = index;
                [_roomTableView reloadData];
            }else {
                [_roomTableView addSubview:self.noRoomDefaultView];
            }
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [DataService toastWithMessage:@"Error"];
            [_roomTableView addSubview:self.noRoomDefaultView];
        }];
    }else {
        
        dic = @{@"page":@1,@"limit":@100,@"keyword":_searchBar.text,@"lang":@"en"};
        [DataService postWithURL:@"rest3/v1/Search/search_user" type:1 params:dic fileData:nil success:^(id data) {
            [hud hideAnimated:YES];
            if ([data[@"status"] integerValue] == 1) {
                NSArray *arr = data[@"data"][@"user_list"];
                _userMarr = [UserModel mj_objectArrayWithKeyValuesArray:arr];
                if (_userMarr.count == 0) {
                    [_UserTableview addSubview:self.noUserDefaultView];
                }else {
                    if (_noUserDefaultView) {
                        [_noUserDefaultView removeFromSuperview];
                        _noUserDefaultView = nil;
                    }
                }
                _UserTableview.dataArr = _userMarr;
                _UserTableview.pageIndex = index;
                [_UserTableview reloadData];
            }else {
                [_UserTableview addSubview:self.noUserDefaultView];
            }
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
            [DataService toastWithMessage:@"Error"];
            [_UserTableview addSubview:self.noUserDefaultView];
        }];
    }
}

- (void)loadEnterRoomData:(RoomModel *)roomModel {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    
    NSDictionary *dic = @{@"token":[DEFAULTS objectForKey:@"token"],@"chatroom_id":roomModel.chatroom_id};
    [DataService postWithURL:@"rest3/v1/Livechatroom/enterChatroom" type:1 params:dic fileData:nil success:^(id data) {
        NSLog(@"%@",data);
        [hud hideAnimated:YES];
        if ([data[@"status"] isEqual:@40001]) {
            //房间已关闭
            [DataService toastWithMessage:@"Room Closed"];
        }else if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            ChatRoomModel *chatModel = [ChatRoomModel mj_objectWithKeyValues:diction];
            
            if ([chatModel.chatroom.enter_limit isEqualToString:@"password"]) {
                //密码进入
                UIAlertController *passAlert = [UIAlertController alertControllerWithTitle:@"Enter password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [passAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Please enter password";
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    UITextField *passTF = passAlert.textFields.firstObject;
                    if ([chatModel.chatroom.enter_pass isEqualToString:passTF.text]) {
                        RoomViewController *roomVC = [[RoomViewController alloc] init];
                        roomVC.hidesBottomBarWhenPushed = YES;
                        roomVC.chatModel = chatModel;
                        roomVC.type = 3;
                        [self.navigationController pushViewController:roomVC animated:YES];
                    }
                }];
                [passAlert addAction:cancel];
                [passAlert addAction:ok];
                [self presentViewController:passAlert animated:YES completion:nil];
            }else {
                RoomViewController *roomVC = [[RoomViewController alloc] init];
                roomVC.hidesBottomBarWhenPushed = YES;
                roomVC.chatModel = chatModel;
                roomVC.type = 3;
                [self.navigationController pushViewController:roomVC animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        [DataService toastWithMessage:@"Error"];
    }];
}

#pragma mark - 创建视图控件
- (void)_createViews {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    bgView.backgroundColor = kLightBgColor;
    [self.view addSubview:bgView];
    if (IS_IPHONE_X) {
        bgView.frame = CGRectMake(0, 0, kScreenWidth, 128);
    }
    
    UIButton *rBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rBtn setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [rBtn addTarget:self action:@selector(popViewAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rBtn];
    
    _searchBar = [[UISearchBar alloc] init];
    _searchBar.barStyle = UIBarStyleDefault;
    _searchBar.backgroundImage = [self imageWithColor:[UIColor whiteColor]];
    _searchBar.layer.cornerRadius = 20;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = kLineColor.CGColor;
    _searchBar.placeholder = @"Please enter room name";
    _searchBar.delegate = self;
    _searchBar.returnKeyType = UIReturnKeySearch;
    [bgView addSubview:_searchBar];
    
    if (IS_IPHONE_X) {
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.mas_equalTo(bgView.mas_top).offset(4*kSpace);
            make.width.offset(kScreenWidth - 100);
            make.height.offset(40);
        }];
        [rBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(bgView.mas_left);
            make.centerY.mas_equalTo(_searchBar.mas_centerY);
            make.width.offset(40);
            make.height.offset(40);
        }];
        
    }else {
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.top.mas_equalTo(bgView.mas_top).offset(3*kSpace);
            make.width.offset(kScreenWidth - 100);
            make.height.offset(40);
        }];
        [rBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(bgView.mas_left);
            make.centerY.mas_equalTo(_searchBar.mas_centerY);
            make.width.offset(40);
            make.height.offset(40);
        }];
    }
    
    if (_searchBar.subviews.count > 0) {
        
        for (UIView *vie in _searchBar.subviews[0].subviews) {
            
            if ([vie isKindOfClass:[UITextField class]]) {
                
                UITextField *textF = (UITextField *)vie;
                textF.font = [UIFont systemFontOfSize:14];
                if (UI_IS_IPHONE5) {
                    textF.font = [UIFont systemFontOfSize:12];
                }
            }
        }
    }
    
    _titleArr = [NSArray arrayWithObjects:@"Room",@"User", nil];
    TYTabPagerView *pagerView = [[TYTabPagerView alloc]init];
    pagerView.tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    pagerView.tabBar.backgroundColor = kLightBgColor;
    pagerView.tabBar.layout.adjustContentCellsCenter = YES;
    pagerView.tabBar.layout.selectedTextColor = [UIColor blackColor];
    pagerView.tabBar.layout.normalTextColor = [UIColor lightGrayColor];
    pagerView.tabBar.layout.progressColor = kNavColor;
    pagerView.tabBar.layout.progressWidth = pagerView.tabBar.layout.cellWidth;
    pagerView.pageView.scrollView.bounces = NO;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [self.view addSubview:pagerView];
    _pagerView = pagerView;
    _pagerView.hidden = YES;
    [_pagerView reloadData];
    
    _countryCV = [[CountryChoiseCollectionView alloc] initWithFrame:CGRectMake(0, 80.5, kScreenWidth, kScreenHeight-80.5)];
    if (IS_IPHONE_X) {
        _countryCV.top = 127.5;
        _countryCV.height = kScreenHeight-128;
    }
    _countryCV.backgroundColor = [UIColor clearColor];
    _countryCV.hidden = NO;
    _countryCV.delegate = self;
    [self.view addSubview:_countryCV];
}

//为了设置搜索框的背景
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 搜索框代理方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    if (!_tap) {
        
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboardAction)];
        [self.view addGestureRecognizer:_tap];
    }
    _countryCV.hidden = YES;
    _pagerView.hidden = NO;
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self _loadSearchDataWithIndex:_pageIndex];
    
    [_searchBar resignFirstResponder];
    
    if (_tap) {
        
        [self.view removeGestureRecognizer:_tap];
        _tap = nil;
    }
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (range.location == 0 && [text isEqualToString:@" "]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _UserTableview) {
        return 70;
    }else {
        return 90;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_pageIndex == 0) {
        return _roomMarr.count;
    }else {
        return _userMarr.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (tableView == _UserTableview) {
        UserModel *model = _userMarr[indexPath.row];
        ProfileViewController *personVC = [[ProfileViewController alloc] init];
        personVC.uid = model.user_id;
        personVC.type = 2;
        [self.navigationController pushViewController:personVC animated:YES];
        
    }else {
        RoomModel *model = _roomMarr[indexPath.row];
        [self loadEnterRoomData:model];
    }
}

#pragma mark - tytabgerview
- (NSInteger)numberOfViewsInTabPagerView {
    return _titleArr.count;
}

- (NSString *)tabPagerView:(TYTabPagerView *)tabPagerView titleForIndex:(NSInteger)index {
    NSString *title = _titleArr[index];
    return title;
}

- (UIView *)tabPagerView:(TYTabPagerView *)tabPagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    
    if (index == 0) {
        
        _roomTableView = [[SearchTableView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index] style:UITableViewStylePlain];
        _roomTableView.delegate = self;
        
        return _roomTableView;
        
    }else{
        
        _UserTableview = [[SearchTableView alloc] initWithFrame:[tabPagerView.layout frameForItemAtIndex:index] style:UITableViewStylePlain];
        _UserTableview.delegate = self;
        return _UserTableview;
        
    }
    return nil;
}

- (void)tabPagerView:(TYTabPagerView *)tabPagerView willAppearView:(UIView *)view forIndex:(NSInteger)index {
    
    _pageIndex = index;

    if (index == 0) {
        _searchBar.placeholder = @"Please enter room name";
    }else if (index == 1) {
        _searchBar.placeholder = @"Please enter user name";
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CountryViewController *countryVC = [[CountryViewController alloc] init];
    if (_countryCV == collectionView) {
        CountryModel *model = _countryArr[indexPath.item];
        countryVC.countryID = model.country_id;
        countryVC.countryName = model.country_name;
    }
    [self.navigationController pushViewController:countryVC animated:YES];
}

#pragma mark - 响应方法
- (void)popViewAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapHideKeyboardAction {
    
    [_searchBar resignFirstResponder];
    
    [self.view removeGestureRecognizer:_tap];
    _tap = nil;
}

@end
