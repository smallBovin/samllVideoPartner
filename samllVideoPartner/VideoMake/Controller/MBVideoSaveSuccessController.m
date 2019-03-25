//
//  MBVideoSaveSuccessController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/26.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBVideoSaveSuccessController.h"
/** 分享弹框*/
#import "MBShareView.h"

#import <Social/Social.h>

@interface MBVideoSaveSuccessController ()

/** 保存成功标志*/
@property (nonatomic, strong) UIImageView * successLogo;
/** 保存成功*/
@property (nonatomic, strong) UILabel * msgLabel;
/** 分享按钮*/
@property (nonatomic, strong) UIButton * shareBtn;

@end

@implementation MBVideoSaveSuccessController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频保存";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    self.fd_interactivePopDisabled = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
#pragma mark--重写返回事件--
//- (void)back {
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)setupSubviews {
    [self.view addSubview:self.successLogo];
    [self.view addSubview:self.msgLabel];
    [self.view addSubview:self.shareBtn];
    [self.successLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NAVIGATION_BAR_HEIGHT+47);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(64);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.successLogo.mas_bottom).offset(20);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.msgLabel.mas_bottom).offset(60);
        make.width.mas_equalTo(kAdapt(290));
        make.height.mas_equalTo(44);
    }];
}

#pragma mark--action---
- (void)shareVideoToThirdPlatform {
    NSURL *url = [NSURL fileURLWithPath:self.videoPath];
    NSArray *items = @[url];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypeAirDrop];
    activityController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    };
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
    
    
    
//    NSLog(@"分享");
//    MBShareView *shareView = [MBShareView shareViewFrame:CGRectMake(0, 0, SCREEN_WIDTH, SAFE_INDICATOR_BAR+kAdapt(187)) platformArrays:@[@{MBSharePlatformIcon:@"me_wechat_Logo",MBSharePlatformName:@"微信"},@{MBSharePlatformIcon:@"me_timeline",MBSharePlatformName:@"朋友圈"}]];
//    [shareView setCornerRadius:kAdapt(20) rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
//    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleActionSheet];
//    __weak typeof(alert) weakAlert = alert;
//
//    NSData *videoData = [NSData dataWithContentsOfFile:self.videoPath];
//    shareView.shareBlock = ^(MBSharePlatformType platformType) {
//        [weakAlert dismissViewControllerAnimated:YES];
//        switch (platformType) {
//            case MBSharePlatformTypeWechat:
//                [[MBWechatApiManager shareManager]shareFileData:videoData fileExtension:@"mp4" title:@"" description:@"" thumbImage:[UIImage imageNamed:@""] atScence:WXSceneSession];
//                break;
//            case MBSharePlatformTypeWechatTimeline:
//                [[MBWechatApiManager shareManager]shareFileData:videoData fileExtension:@"mp4" title:@"" description:@"" thumbImage:[UIImage imageNamed:@""] atScence:WXSceneTimeline];
//                break;
//            default:
//                break;
//        }
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        });
//    };
//    shareView.cancelBlock = ^{
//        [weakAlert dismissViewControllerAnimated:YES];
//    };
//    alert.backgoundTapDismissEnable = YES;
//    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark--lazy---
/** 成功标志*/
- (UIImageView *)successLogo {
    if (!_successLogo) {
        _successLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"me_feedback_success"]];
    }
    return _successLogo;
}
/** 成功提示*/
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.font = [UIFont systemFontOfSize:16];
        _msgLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _msgLabel.text = @"保存成功";
        [_msgLabel sizeToFit];
    }
    return _msgLabel;
}
/** 分享按钮*/
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _shareBtn.layer.cornerRadius = 22;
        _shareBtn.layer.masksToBounds = YES;
        [_shareBtn addTarget:self action:@selector(shareVideoToThirdPlatform) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
@end
