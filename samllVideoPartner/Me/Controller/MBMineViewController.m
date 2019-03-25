//
//  MBMineViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMineViewController.h"
#import "MBContactServiceView.h"
#import "MBMeTableViewCell.h"
/** 表头*/
#import "MBMeTableHeaderView.h"
/** 开通VIP界面*/
#import "MBOpenVipViewController.h"
/** 推荐好友弹框*/
#import "MBShareView.h"
/** 推荐人*/
#import "MBRecommendView.h"
/** 网页加载界面*/
#import "MBProtocolWebViewController.h"
/** 反馈界面*/
#import "MBFeedbackViewController.h"
/** 分销/代理中心*/
#import "MBPerformanceViewController.h"
/** 绑定手机界面*/
#import "MBBindingMobileViewController.h"
/** 微信授权登录界面*/
#import "MBWechatLoginView.h"



@interface MBMineViewController ()<UITableViewDataSource,UITableViewDelegate,MBMeTableHeaderViewDelegate,MBWechatApiManagerDelegate>

/** 列表*/
@property (nonatomic, strong) UITableView * tableView;
/** 分类数组*/
@property (nonatomic, strong) NSArray * dataArray;
/** 表头*/
@property (nonatomic, strong) MBMeTableHeaderView * headerView;
/** 表尾的推出登录按钮*/
@property (nonatomic, strong) UIView * footerView;
/** 是否用户点击查看用户协议*/
@property (nonatomic, assign) BOOL  isClickUserProtocol;

@end

@implementation MBMineViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人中心";
    if ([[MBUserManager manager]isUnderReview]) {
        self.dataArray = @[@{@"icon":@"me_recommend",@"title":@"推荐好友"},@{@"icon":@"me_presenter",@"title":@"推荐人"},@{@"icon":@"me_feedback",@"title":@"问题反馈"},@{@"icon":@"me_user_protocol",@"title":@"用户协议"},@{@"icon":@"me_protocol",@"title":@"平台协议"},@{@"icon":@"me_prefer_center",@"title":@"隐私政策"},@{@"icon":@"me_contact_service",@"title":@"联系客服"},@{@"icon":@"me_clean_disk",@"title":@"清除缓存"}];
    }else {
        self.dataArray = @[@{@"icon":@"me_recommend",@"title":@"推荐好友"},@{@"icon":@"me_presenter",@"title":@"推荐人"},@{@"icon":@"me_feedback",@"title":@"问题反馈"},@{@"icon":@"me_user_protocol",@"title":@"用户协议"},@{@"icon":@"me_protocol",@"title":@"平台协议"},@{@"icon":@"me_prefer_center",@"title":@"分销中心"},@{@"icon":@"me_agency_center",@"title":@"代理中心"},@{@"icon":@"me_contact_service",@"title":@"联系客服"},@{@"icon":@"me_clean_disk",@"title":@"清除缓存"}];
    }
    
    [self.view addSubview:self.tableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:kUserInfoUpdateCompleteNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isClickUserProtocol) {
        [self showWechatAuthoLoginAlert];
        self.isClickUserProtocol = NO;
    }
}

- (void)refreshUI {
    self.headerView.userInfo = [MBUserManager manager].userInfo;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView reloadData];
}

#pragma mark--UITableViewDataSource--
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MBMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MBMeTableViewCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.dict = dic;
    if (indexPath.row == 1 && [MBUserManager manager].isLogin) {
        NSString *recommend = [MBUserManager manager].userInfo.fid.length>0?[MBUserManager manager].userInfo.fid:@"";
        cell.descString = [recommend isEqualToString:@"无推荐人"] == YES?@"":recommend;
    }else if (indexPath.row == 8) {
        cell.descString = [NSString stringWithFormat:@"%0.1fM",[self getAllCacheData]];
    }
    return cell;
}

#pragma mark--UITableViewDelegate---
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
    [self handlerActionWithCellIndexPath:indexPath];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, SAFE_INDICATOR_BAR, 0);
}

/** 获取所有的缓存数据*/
- (CGFloat)getAllCacheData {

    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    long long cacheSize = [MBTools getFileSizeWithPath:cachePath];
    
    return cacheSize/1024.0/1024.0;
}

#pragma mark--MBMeTableHeaderViewDelegate--
/** 微信授权登录*/
- (void)wecahtAuthlogin {
    LOCK
    [[MBWechatApiManager shareManager]sendAuthRequestWithController:self delegate:self];
    UNLOCK
}
/** 开通VIP*/
- (void)goToOpenVip {
    MBOpenVipViewController *VIPvc = [MBOpenVipViewController new];
    [self.navigationController pushViewController:VIPvc animated:YES];
}
#pragma mark--微信授权登录弹框- (目前退出时返回首页，以后看需求变更)--
- (void)showWechatAuthoLoginAlert {
    @autoreleasepool {
        MBWechatLoginView *loginView = [[MBWechatLoginView alloc]initWithFrame:CGRectMake(0, 0, kAdapt(290), kAdapt(180))];
        TYAlertController *alert = [TYAlertController alertControllerWithAlertView:loginView preferredStyle:TYAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        __weak typeof(alert) weakAlert = alert; //防止循环引用
        loginView.closeAction = ^{
            [weakAlert dismissViewControllerAnimated:YES];
        };
        loginView.loginAction = ^{
            [weakAlert dismissViewControllerAnimated:YES];
            [weakSelf wecahtAuthlogin];
        };
        loginView.protocolAction = ^{   //用户协议
            [weakSelf skitToSeeUserProtocolWithUrl:[MBUserManager manager].configInfo.protocol alertController:weakAlert];
        };
        loginView.privacyAction = ^{    //隐私政策
            [weakSelf skitToSeeUserProtocolWithUrl:[MBUserManager manager].configInfo.protocol alertController:weakAlert];
        };
        alert.view.backgroundColor = [UIColor colorWithHexString:@"#343434" alpha:0.6];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//跳转到用户协议
- (void)skitToSeeUserProtocolWithUrl:(NSString *)url alertController:(TYAlertController *)alert {
    LOCK
    self.isClickUserProtocol = YES;
    [alert dismissViewControllerAnimated:YES];
    MBBaseWebviewController *webVC = [MBBaseWebviewController new];
    [webVC loadUrl:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webVC animated:YES];
    UNLOCK
}

#pragma mark--MBWechatApiManagerDelegate---
/** 微信授权登录接口*/
- (void)weChatAuthSuccessWithCode:(NSString *)code {
    //根据code到后台请求用户信息接口
    NSLog(@"success code %@ ",code);
    [[MBUserManager manager]WechatAuthLoginWithCode:code complement:^(BOOL isNeedBind) {
        if (isNeedBind) {
            dispatch_async(dispatch_get_main_queue(), ^{
                LOCK
                MBBindingMobileViewController *bindVC = [MBBindingMobileViewController new];
                [self.navigationController pushViewController:bindVC animated:YES];
                UNLOCK
            });
        }
    }];
}
- (void)cancelWechatAuth {
    [MBProgressHUD showOnlyTextMessage:@"取消授权"];
}
- (void)weChatAuthDeny {
    [MBProgressHUD showOnlyTextMessage:@"授权失败"];
}
#pragma mark--cell点击事件处理---
- (void)handlerActionWithCellIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:         //推荐好友，分享
            [self recommendYourFriendsJoinUS];
            break;
        case 1:         //填写推荐人，弹框
            if ([MBUserManager manager].userInfo.fid.length<=0 ||[[MBUserManager manager].userInfo.fid isEqualToString:@"无推荐人"]) {
                [self writeYourRecommond];
            }
            break;
        case 2:         //问题反馈
            [self feedbackSomeProblemsInUsing];
            break;
        case 3:         //用户协议
            [self watchPlatformOrUserProrocol:2000];
            break;
        case 4:         //平台协议
            [self watchPlatformOrUserProrocol:2100];
            break;
        case 5:         //分销中心
            if ([[MBUserManager manager]isUnderReview]) {
                [self watchPlatformOrUserProrocol:2200]; //审核状态为隐私政策
            }else {
                if ([[MBUserManager manager].userInfo.is_distribution isEqualToString:@"1"]) {
                    [self myPerformanceType:MBPerformanceTypeDistribution];
                }else {
                    [MBProgressHUD showOnlyTextMessage:@"联系平台开通该权限"];
                }
            }
            break;
        case 6:         //代理中心
            if ([[MBUserManager manager]isUnderReview]) {
                [self contactOurCustomerServices];
            }else {
                if ([[MBUserManager manager].userInfo.is_agent isEqualToString:@"1"]) {
                    [self myPerformanceType:MBPerformanceTypeAgency];
                }else {
                    [MBProgressHUD showOnlyTextMessage:@"联系平台开通该权限"];
                }
            }
            break;
        case 7:         //联系客服，弹框
            if ([[MBUserManager manager]isUnderReview]) {
                [self clearAppDiskMemory];
            }else {
                [self contactOurCustomerServices];
            }
            break;
        case 8:         //清除缓存
            [self clearAppDiskMemory];
            break;
            
        default:
            break;
    }
}
/** 推荐好友*/
- (void)recommendYourFriendsJoinUS {
    MBShareView *shareView = [MBShareView shareViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SAFE_INDICATOR_BAR+kAdapt(187)) platformArrays:@[@{MBSharePlatformIcon:@"me_wechat_Logo",MBSharePlatformName:@"微信"},@{MBSharePlatformIcon:@"me_timeline",MBSharePlatformName:@"朋友圈"}]];
    [shareView setCornerRadius:kAdapt(20) rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleActionSheet];
    __weak typeof(alert) weakAlert = alert;
    shareView.shareBlock = ^(MBSharePlatformType platformType) {
        [weakAlert dismissViewControllerAnimated:YES];
        NSString *shareUrl = [NSString stringWithFormat:@"%@?code=%@",SHARE_REGISTER_URL,[MBUserManager manager].userInfo.code];
        switch (platformType) {
            case MBSharePlatformTypeWechat:
                
                [[MBWechatApiManager shareManager]shareLinkContent:shareUrl title:[MBUserManager manager].configInfo.share_title description:[MBUserManager manager].configInfo.share_content thumbImage:[MBUserManager manager].shareImage atScence:WXSceneSession];
                break;
            case MBSharePlatformTypeWechatTimeline:
                [[MBWechatApiManager shareManager]shareLinkContent:shareUrl title:[MBUserManager manager].configInfo.share_title description:[MBUserManager manager].configInfo.share_content thumbImage:[MBUserManager manager].shareImage atScence:WXSceneTimeline];
                break;
            default:
                break;
        }
    };
    shareView.cancelBlock = ^{
        [weakAlert dismissViewControllerAnimated:YES];
    };
    alert.backgoundTapDismissEnable = YES;
    [self presentViewController:alert animated:YES completion:nil];
}
/** 推荐人*/
- (void)writeYourRecommond {
    MBRecommendView *recommendView = [[MBRecommendView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-kAdapt(40), kAdapt(250))];
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:recommendView preferredStyle:TYAlertControllerStyleAlert];
    __weak typeof(alert) weakAlert = alert;
    recommendView.CommitRecommendIDBlock = ^(NSString * _Nonnull recommengId) {
        [weakAlert dismissViewControllerAnimated:YES];
        /** 添加推荐人接口*/
        [[MBUserManager manager]addRecommendPersonWithID:recommengId complement:^(NSString * _Nonnull recommendName) {
            NSLog(@"%@",recommendName);
            if ([recommendName isEqualToString:@"success"]) {
                [[MBUserManager manager]loadOrUpdateUserInfo];
            }else if ([recommendName isEqualToString:@"102"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    };
    alert.backgoundTapDismissEnable = YES;
    [self presentViewController:alert animated:YES completion:nil];
}
/** 问题反馈*/
- (void)feedbackSomeProblemsInUsing {
    MBFeedbackViewController *feedbackVC = [MBFeedbackViewController new];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
/** 平台协议或者用户协议*/
- (void)watchPlatformOrUserProrocol:(int)type {
    MBProtocolWebViewController *protocolVC = [MBProtocolWebViewController new];
    if (2000 == type) {
        protocolVC.title = @"用户协议";
        [protocolVC loadUrl:[NSURL URLWithString:USER_PROTOCOL]];
    }else if (2100 == type) {
        protocolVC.title = @"平台协议";
        [protocolVC loadUrl:[NSURL URLWithString:PLATFORM_PROTOCOL]];
    }else {
        protocolVC.title = @"隐私政策";
        [protocolVC loadUrl:[NSURL URLWithString:USER_PRIVACY_PROTOCOL]];
    }
    [self.navigationController pushViewController:protocolVC animated:YES];
}
/** 分销/代理中心*/
- (void)myPerformanceType:(MBPerformanceType)type {
    
    MBPerformanceViewController *performanceVC = [MBPerformanceViewController new];
    performanceVC.type = type;
    [self.navigationController pushViewController:performanceVC animated:YES];
}
/** 联系客服*/
- (void)contactOurCustomerServices {
    MBContactServiceView *service = [[MBContactServiceView alloc]initWithFrame:CGRectMake(20, NAVIGATION_BAR_HEIGHT+20, kAdapt(335), kAdapt(319))];
     TYAlertController *alert = [TYAlertController alertControllerWithAlertView:service preferredStyle:TYAlertControllerStyleAlert];
    alert.backgoundTapDismissEnable = YES;
    [self presentViewController:alert animated:YES completion:nil];
}
/** 清除缓存*/
- (void)clearAppDiskMemory {
    __weak typeof(self) weakSelf = self;
    [MBTools clearAllChcheDataCompletion:^{
        [MBProgressHUD showSuccessAlertWithIcon:@"clean_memory" message:@"清理完成"];
        [weakSelf.tableView reloadData];
    }];
}
#pragma mark--退出登录--action--
- (void)loginOut {
    [[MBUserManager manager]loginOut];
    self.tableView.tableFooterView = nil;
    self.headerView.userInfo = [MBUserManager manager].userInfo;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    [self.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark--lazy--
/** 列表*/
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = kAdapt(55);
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MBMeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MBMeTableViewCell class])];
    }
    return _tableView;
}
/** 表头*/
- (MBMeTableHeaderView *)headerView {
    if (!_headerView) {
        if ([[MBUserManager manager]isUnderReview]) {
            _headerView = [[MBMeTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kAdapt(112))];  //上架隐藏vip  112
        }else {
            _headerView = [[MBMeTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kAdapt(252))];
        }
        _headerView.layer.masksToBounds = YES;
        _headerView.delegate = self;
        _headerView.userInfo = [MBUserManager manager].userInfo;
    }
    return _headerView;
}
/** 表尾*/
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kAdapt(88))];
        UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginOutBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        loginOutBtn.layer.cornerRadius = kAdapt(25);
        loginOutBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        loginOutBtn.layer.borderWidth = 1;
        loginOutBtn.layer.masksToBounds = YES;
        [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:loginOutBtn];
        [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_footerView.mas_top).offset(kAdapt(18));
            make.centerX.equalTo(self->_footerView.mas_centerX);
            make.width.mas_equalTo(kAdapt(290));
            make.height.mas_equalTo(kAdapt(49));
        }];
    }
    return _footerView;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kUserInfoUpdateCompleteNotification object:nil];
    NSLog(@"%@",[self description]);
}
@end
