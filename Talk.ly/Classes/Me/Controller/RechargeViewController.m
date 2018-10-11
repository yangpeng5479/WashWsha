//
//  RechargeViewController.m
//  Talk.ly
//
//  Created by 杨鹏 on 2018/4/9.
//  Copyright © 2018年 Talk.ly. All rights reserved.
//

#import "RechargeViewController.h"
#import "CommonPrex.h"
#import "DataService.h"
#import <Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AccountManager.h"
#import <MJExtension.h>
#import "RechargeCollectionViewCell.h"
#import "RechargeModel.h"
#import <StoreKit/StoreKit.h>

@interface RechargeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property(nonatomic,strong)UICollectionView *rechargeCollectionView;
@property(nonatomic,assign)NSInteger gold;
@property(nonatomic,strong)NSMutableArray *rechargeMarr;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,strong)NSMutableArray *productIDArr;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation RechargeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self loadWalletData];
    [self loadRechargeListData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Gold";
    
    [self.view addSubview:self.rechargeCollectionView];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self _verifyLocalReceipt];
}

#pragma mark - apple pay
//验证处理本地是否有未交易的receipt
- (void)_verifyLocalReceipt {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"latestiapreceipt.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path] || ![AccountManager sharedAccountManager].userID) {
        return;
    }
    
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    if (!arr || arr.count <= 1) {
        return;
    }
    
    [self verifyReceiptByServerWithReceipt:arr[0] transactionID:arr[1] productID:arr[2]];
}

//苹果支付响应
- (void)payAction:(UIButton *)sender {
    
    if (![AccountManager sharedAccountManager].userID) {
        return;
    }
    if ([self isJailBreak]) {

        [self _toastWithMsg:@"Jailbreak devices is prohibited recharge!"];
        return;
    }
    
    _index = sender.tag-800;
    if ([SKPaymentQueue canMakePayments]) {
        
        [self requestProductData];
        NSLog(@"允许程序内付费购买");
    }else {
        
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Tips"
                                                            message:@"Your phone does not open in-app purchase"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alerView show];
    }
}

//是否越狱
- (BOOL)isJailBreak {
    
    NSArray *jailbreak_tool_paths = @[
                                      @"/Applications/Cydia.app",
                                      @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                      @"/bin/bash",
                                      @"/usr/sbin/sshd",
                                      @"/etc/apt"
                                      ];
    for (int i=0; i<jailbreak_tool_paths.count; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreak_tool_paths[i]]) {
            return YES;
        }
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        NSLog(@"The device is jail broken!");
        return YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"]) {
        NSLog(@"The device is jail broken!");
        NSArray *appList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"User/Applications/" error:nil];
        NSLog(@"appList = %@", appList);
        return YES;
    }
    return NO;
}

//支付响应
-(void)requestProductData {
    
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = [[NSArray alloc] initWithObjects:_productIDArr[_index],nil];
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate = self;
    [request start];
    
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.label.text = @"Loading...";
}
//SKProductsRequestDelegate 收到产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }
    
    if (myProduct.count == 0) {
        
        [self _resumeButtonStatus];
        
        [self _toastWithMsg:@"Abnormality, temporarily unable to obtain product information"];
        return;
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:myProduct[0]];
    NSLog(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

// Called when the product request failed.
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"-------弹出错误信息----------%@",error);
    [self _toastWithMsg:error.localizedDescription];
    [self _resumeButtonStatus];
}
//交易结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
                //交易完成
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                //交易失败
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
                //已经购买过该商品
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                //商品添加进列表
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}

//完成交易
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"-----交易完成 --------");
    NSString *product = transaction.payment.productIdentifier;
    NSString *receipt = [[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]] base64EncodedStringWithOptions:0];
    [self recordTransactionReceipt:receipt transactionID:transaction.transactionIdentifier productID:product];
    
    if ([product length] > 0) {
        [self provideContentWithReceipt:receipt transactionID:transaction.transactionIdentifier];
    }
    
    [self _resumeButtonStatus];
    //Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

//处理下载内容
- (void)provideContentWithReceipt:(NSString *)receipt transactionID:(NSString *)transactionIdentifier {
    
    if (!receipt || !transactionIdentifier) {
        return;
    }
    
    NSString *str = _productIDArr[_index];
    NSString *proID = [str substringFromIndex:9];
    [self verifyReceiptByServerWithReceipt:receipt transactionID:transactionIdentifier productID:proID];
}

//请求验证receipt
- (void)verifyReceiptByServerWithReceipt:(NSString *)receipt transactionID:(NSString *)transactionIdentifier productID:(NSString *)productID{
    
    NSLog(@"-----验证并获取交易内容--------");
    if (!receipt || !productID || [receipt isEqualToString:@""] || [receipt isKindOfClass:[NSNull class]] || [productID isKindOfClass:[NSNull class]] || [productID isEqualToString:@""]) {
        return;
    }
    NSString *urlStr = @"rest3/v1/Recharge/recharge";
    NSDictionary *dic = @{
                          @"token":[AccountManager sharedAccountManager].token,
                          @"receipt":receipt,
                          @"official_recharge_item_id":productID,
                          @"type":@"ios"
                          };
    NSLog(@"交易信息:%@",dic);
    [DataService postWithURL:urlStr type:1 params:dic fileData:nil success:^(id data) {
        
            NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == 1) {
            [self removeLocalTransactionRecord];
            [self loadWalletData];
        }else {
            [self _toastWithMsg:@"Abnormal service, please contact customer service"];
        }
        
    } failure:^(NSError *error) {
        [self _toastWithMsg:@"The network is abnormal."];
    }];
}

//记录交易
- (void)recordTransactionReceipt:(NSString *)receipt transactionID:(NSString *)transactionIdentifier productID:(NSString *)pid{
    
    if (!receipt || !transactionIdentifier || !pid) {
        
        [self _toastWithMsg:@"Abnormal purchase, please contact Apple official customer service for processing"];
        return;
    }
    NSLog(@"-----记录交易--------");
    NSArray *arr = @[receipt,transactionIdentifier,pid];;
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [documentPath stringByAppendingPathComponent:@"latestiapreceipt.plist"];
    [arr writeToFile:path atomically:YES];
}
//删除本地交易记录
- (void)removeLocalTransactionRecord {
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"latestiapreceipt.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:path error:nil] == NO) {
            [@[] writeToFile:path atomically:YES];
        }
    }
}
//交易失败
- (void)failedTransaction: (SKPaymentTransaction *)transaction {
    
    NSLog(@"----交易失败----");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self _toastWithMsg:[NSString stringWithFormat:@"Failed purchase，Error:%@",transaction.error.localizedDescription]];
    }else {
        NSLog(@"用户取消交易");
    }
    
    [self _resumeButtonStatus];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
//恢复交易
- (void)restoreTransaction: (SKPaymentTransaction *)transaction {
    
    NSLog(@"交易恢复处理");
    [self _resumeButtonStatus];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

//支付队列恢复交易失败
- (void)paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"-------paymentQueue----%@",error);
}

//交易完成或失败后恢复按钮状态
- (void)_resumeButtonStatus {
    
    if (_hud) {
        [_hud hideAnimated:YES];
        _hud = nil;
    }
}

//提示框
- (void)_toastWithMsg:(NSString *)msg {
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Tips"
                                                        message:msg
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
    [alerView show];
}


- (void)dealloc {
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 更新UI
- (UICollectionView *)rechargeCollectionView {
    if (!_rechargeCollectionView) {
        
        CGFloat w = (kScreenWidth - 60)/3;
        CGFloat h = 130;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 200);
        layout.itemSize = CGSizeMake(w, h);
        layout.minimumInteritemSpacing = kSpace;
        layout.minimumLineSpacing = kSpace;
        layout.sectionInset = UIEdgeInsetsMake(0, kSpace, 0, kSpace);
        
        _rechargeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        _rechargeCollectionView.backgroundColor = [UIColor clearColor];
        _rechargeCollectionView.delegate = self;
        _rechargeCollectionView.dataSource = self;
        [_rechargeCollectionView registerClass:[RechargeCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [_rechargeCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    }
    return _rechargeCollectionView;
}

#pragma mark - 获取数据
//获取个人财产
- (void)loadWalletData {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Loading...";
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token};
    [DataService postWithURL:@"rest3/v1/Wallet/get_wallet" type:1 params:dic fileData:nil success:^(id data) {
        [hud hideAnimated:YES];
        
        if ([data[@"status"] integerValue] == 1) {
            NSDictionary *diction = data[@"data"];
            _gold = [diction[@"wallet"][@"diamond_total"] integerValue];
            [_rechargeCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
    }];
}

//获取充值列表
- (void)loadRechargeListData {
    NSDictionary *dic = @{@"token":[AccountManager sharedAccountManager].token,@"lang":@"en"};
    [DataService postWithURL:@"rest3/v1/Recharge/get_official_recharge_items" type:1 params:dic fileData:nil success:^(id data) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = data[@"data"][@"recharge_items"];
            _rechargeMarr = [RechargeModel mj_objectArrayWithKeyValuesArray:arr];
            [_rechargeMarr sortUsingComparator:^NSComparisonResult(RechargeModel *obj1, RechargeModel *obj2) {
                if ([obj2.official_recharge_list_id integerValue] < [obj1.official_recharge_list_id integerValue]) {
                    return NSOrderedDescending;
                }else {
                    return NSOrderedAscending;
                }
            }];
            [_rechargeCollectionView reloadData];
            
            _productIDArr = [NSMutableArray array];
            for (RechargeModel *model in _rechargeMarr) {
                NSString *str = [NSString stringWithFormat:@"com.vcoze%@",model.official_recharge_list_id];
                [_productIDArr addObject:str];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - uicollectionview's delegate and datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RechargeCollectionViewCell *cell = (RechargeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    RechargeModel *model = _rechargeMarr[indexPath.item];
    cell.model = model;
    
    cell.buyButton.tag = 800 +indexPath.item;
    [cell.buyButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    imageview.layer.cornerRadius = kCellSpace;
    imageview.layer.masksToBounds = YES;
    imageview.image = [UIImage imageNamed:@"goldcard"];
    [headerView addSubview:imageview];
    
    UILabel *goldLabel = [[UILabel alloc] init];
    goldLabel.font = [UIFont systemFontOfSize:24];
    goldLabel.textColor = [UIColor whiteColor];
    goldLabel.attributedText = [DataService createAttributedStringWithImageName:@"icon-bigUSdollar" bounds:CGRectMake(0, -3, 25, 25) str:[NSString stringWithFormat:@"%ld",(long)_gold]];
    [goldLabel sizeToFit];
    [imageview addSubview:goldLabel];
    
    UIImageView *aoImageView = [[UIImageView alloc] init];
    aoImageView.image = [UIImage imageNamed:@"exchangeforgoldbg"];
    [headerView addSubview:aoImageView];
    
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headerView.mas_left).offset(35);
        make.right.mas_equalTo(headerView.mas_right).offset(-35);
        make.top.mas_equalTo(headerView.mas_top).offset(20);
        make.bottom.mas_equalTo(headerView.mas_bottom);
    }];
    [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(imageview.mas_centerX);
        make.top.mas_equalTo(imageview.mas_top).offset(60);
    }];
    [aoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(headerView.mas_left);
        make.right.mas_equalTo(headerView.mas_right);
        make.bottom.mas_equalTo(imageview.mas_bottom).offset(-0.5);
        make.height.offset(50);
    }];
    return headerView;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
