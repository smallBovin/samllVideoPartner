//
//  MBMainViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMainViewController.h"
#import "MBMainChooseButton.h"
/** 微信登录成功信息*/
#import "MBWechatInfoModel.h"

/** 跳转界面*/
#import "MBMineViewController.h"            //用户信息

#import "MBServiceCenterViewController.h"   //客服中心
#import "MBVideoMakeViewController.h"       //视频制作
#import "MBVideoCompositionController.h"    //视频合成
#import "MBVideoStictchController.h"        //视屏图片拼接
#import "MBTeachingVideoController.h"       //视频教学

/** 微信授权登录界面*/
#import "MBWechatLoginView.h"
/** 微信授权登录管理类*/
#import "MBWechatApiManager.h"
/** 绑定手机界面*/
#import "MBBindingMobileViewController.h"
/** 网页加载界面*/
#import "MBProtocolWebViewController.h"


@interface MBMainViewController ()<MBWechatApiManagerDelegate>
/** 背景图片*/
@property (nonatomic, strong) UIImageView * bgImageView;
/** 我的信息*/
@property (nonatomic, strong) UIButton * userInfoBtn;
/** 帮助中心*/
@property (nonatomic, strong) UIButton * helpCenterBtn;
/** logo图标*/
@property (nonatomic, strong) UIImageView * logoImageView;
/** 视频编辑*/
@property (nonatomic, strong) MBMainChooseButton * videoMakeBtn;
/** 视频合成*/
@property (nonatomic, strong) MBMainChooseButton * videoCompositionBtn;
/** 视频拼接*/
@property (nonatomic, strong) MBMainChooseButton * videoStichingBtn;
/** 视频教学*/
@property (nonatomic, strong) MBMainChooseButton * teachingVideoBtn;

/** 是否用户点击查看用户协议*/
@property (nonatomic, assign) BOOL  isClickUserProtocol;

@end

@implementation MBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isClickUserProtocol) {
        [self showWechatAuthoLoginAlert];
        self.isClickUserProtocol = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)setupViews {
    [self.view addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.userInfoBtn];
    [self.bgImageView addSubview:self.helpCenterBtn];
    [self.bgImageView addSubview:self.logoImageView];
    [self.bgImageView addSubview:self.videoMakeBtn];
    [self.bgImageView addSubview:self.videoCompositionBtn];
    [self.bgImageView addSubview:self.videoStichingBtn];
    [self.bgImageView addSubview:self.teachingVideoBtn];
    [self.userInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView.mas_left).offset(kAdapt(25));
        make.top.equalTo(self.bgImageView.mas_top).offset(STATUS_BAR_HEIGHT+kAdapt(24));
        make.width.height.mas_equalTo(kAdapt(37));
    }];
    [self.helpCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-kAdapt(25));
        make.top.equalTo(self.bgImageView.mas_top).offset(STATUS_BAR_HEIGHT+kAdapt(24));
        make.width.height.mas_equalTo(kAdapt(37));
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.top.equalTo(self.bgImageView.mas_top).offset(STATUS_BAR_HEIGHT+kAdapt(68));
        make.width.mas_equalTo(kAdapt(99));
        make.height.mas_equalTo(kAdapt(90));
    }];
    [self.videoMakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(kAdapt(30));
        make.width.mas_equalTo(kAdapt(250));
        make.height.mas_equalTo(kAdapt(84));
    }];
    [self.videoCompositionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.top.equalTo(self.videoMakeBtn.mas_bottom).offset(kAdapt(15));
        make.width.height.equalTo(self.videoMakeBtn);
    }];
    [self.videoStichingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.top.equalTo(self.videoCompositionBtn.mas_bottom).offset(kAdapt(15));
        make.width.height.equalTo(self.videoMakeBtn);
    }];
    [self.teachingVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.top.equalTo(self.videoStichingBtn.mas_bottom).offset(kAdapt(15));
        make.width.height.equalTo(self.videoMakeBtn);
    }];
}

#pragma mark--微信授权登录弹框---
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
            [weakSelf wechatAuthLoginHandler];
        };
        loginView.protocolAction = ^{   //用户协议
            [weakSelf skitToSeeUserProtocolWithUrl:USER_PROTOCOL alertController:weakAlert];
        };
        loginView.privacyAction = ^{    //隐私政策
            [weakSelf skitToSeeUserProtocolWithUrl:USER_PRIVACY_PROTOCOL alertController:weakAlert];
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
    MBProtocolWebViewController *webVC = [MBProtocolWebViewController new];
    [webVC loadUrl:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:webVC animated:YES];
    UNLOCK
}

#pragma mark--微信授权登录处理---
- (void)wechatAuthLoginHandler {
    LOCK
    [[MBWechatApiManager shareManager]sendAuthRequestWithController:self delegate:self];
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

#pragma mark--lazy---
/** 背景图片*/
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_bgImage"]];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _bgImageView;
}
/** 用户信息按钮*/
- (UIButton *)userInfoBtn {
    if (!_userInfoBtn) {
        _userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userInfoBtn setImage:[UIImage imageNamed:@"main_userCenter"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_userInfoBtn addTapBlock:^(UIButton * _Nonnull btn) {
            if ([[MBUserManager manager]isUnderReview]) {
                MBMineViewController *mineVC = [MBMineViewController new];
                [weakSelf.navigationController pushViewController:mineVC animated:YES];
            }else {
                if (![[MBUserManager manager]isLogin]) {
                    [weakSelf showWechatAuthoLoginAlert];
                }else {
                    MBMineViewController *mineVC = [MBMineViewController new];
                    [weakSelf.navigationController pushViewController:mineVC animated:YES];
                }
            }
        }];
    }
    return _userInfoBtn;
}
/** 帮助中心*/
- (UIButton *)helpCenterBtn {
    if (!_helpCenterBtn) {
        _helpCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpCenterBtn setImage:[UIImage imageNamed:@"main_helpCenter"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_helpCenterBtn addTapBlock:^(UIButton * _Nonnull btn) {
            MBServiceCenterViewController *helpVC = [MBServiceCenterViewController new];
            [helpVC loadUrl:[NSURL URLWithString:MEIQI_SERVICE_URL]];
            [weakSelf.navigationController pushViewController:helpVC animated:YES];
        }];
    }
    return _helpCenterBtn;
}
/** logo图标*/
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_app_logo"]];
    }
    return _logoImageView;
}
/** 视频制作*/
- (MBMainChooseButton *)videoMakeBtn {
    if (!_videoMakeBtn) {
        __weak typeof(self) weakSelf = self;
        _videoMakeBtn = [MBMainChooseButton chooseBtnWithFrame:CGRectZero logoName:@"main_videoMake" titleName:@"视频制作" action:^{
            if ([[MBUserManager manager]isUnderReview]) {
                MBVideoMakeViewController *makeVC = [MBVideoMakeViewController new];
                [weakSelf.navigationController pushViewController:makeVC animated:YES];
            }else {
                if (![[MBUserManager manager]isLogin]) {
                    [weakSelf showWechatAuthoLoginAlert];
                }else {
                    MBVideoMakeViewController *makeVC = [MBVideoMakeViewController new];
                    [weakSelf.navigationController pushViewController:makeVC animated:YES];
                }
            }
        }];
    }
    return _videoMakeBtn;
}
/** 视频拼接*/
- (MBMainChooseButton *)videoCompositionBtn {
    if (!_videoCompositionBtn) {
        __weak typeof(self) weakSelf = self;
        _videoCompositionBtn = [MBMainChooseButton chooseBtnWithFrame:CGRectZero logoName:@"main_videoComposition" titleName:@"视频拼接" action:^{
            if ([[MBUserManager manager]isUnderReview]) {
                MBVideoCompositionController *compositionVC = [MBVideoCompositionController new];
                [weakSelf.navigationController pushViewController:compositionVC animated:YES];
            }else {
                if (![[MBUserManager manager]isLogin]) {
                    [weakSelf showWechatAuthoLoginAlert];
                }else {
                    MBVideoCompositionController *compositionVC = [MBVideoCompositionController new];
                    [weakSelf.navigationController pushViewController:compositionVC animated:YES];
                }
            }
        }];
    }
    return _videoCompositionBtn;
}
/** 视频合成*/
- (MBMainChooseButton *)videoStichingBtn {
    if (!_videoStichingBtn) {
        __weak typeof(self) weakSelf = self;
        _videoStichingBtn = [MBMainChooseButton chooseBtnWithFrame:CGRectZero logoName:@"main_videostitch" titleName:@"视频合成" action:^{
            if ([[MBUserManager manager]isUnderReview]) {
                MBVideoStictchController *stitchVC = [MBVideoStictchController new];
                [weakSelf.navigationController pushViewController:stitchVC animated:YES];
            }else {
                if (![[MBUserManager manager]isLogin]) {
                    [weakSelf showWechatAuthoLoginAlert];
                }else {
                    MBVideoStictchController *stitchVC = [MBVideoStictchController new];
                    [weakSelf.navigationController pushViewController:stitchVC animated:YES];
                }
            }
        }];
    }
    return _videoStichingBtn;
}
/** 视频教学*/
- (MBMainChooseButton *)teachingVideoBtn {
    if (!_teachingVideoBtn) {
        __weak typeof(self) weakSelf = self;
        _teachingVideoBtn = [MBMainChooseButton chooseBtnWithFrame:CGRectZero logoName:@"main_teachingVideo" titleName:@"视频教学" action:^{
            MBTeachingVideoController *teachingVC = [MBTeachingVideoController new];
            [teachingVC loadUrl:[NSURL URLWithString:TEACHING_OR_FIND]];
            [weakSelf.navigationController pushViewController:teachingVC animated:YES];
        }];
    }
    return _teachingVideoBtn;
}
@end
