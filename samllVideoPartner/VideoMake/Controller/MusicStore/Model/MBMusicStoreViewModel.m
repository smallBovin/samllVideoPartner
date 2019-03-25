//
//  MBMusicStoreViewModel.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/28.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicStoreViewModel.h"
/** 音乐试听选择界面*/
#import "MBMusicAuditionView.h"
/** 音乐编辑界面*/
#import "MBMusicEditingView.h"
/** 音乐model*/
#import "MBMapsModel.h"

/** 自控制器的高度*/
#define  kChildVC_HEIGHT    SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-108

@interface MBMusicStoreViewModel ()<MBMusicAuditionViewDelegate,MBMusicEditingViewDelegate>

/** 注册绑定的控制器*/
@property (nonatomic, weak) UIViewController * controller;
/** 当前的tableview*/
@property (nonatomic, weak) UITableView * tableView;
/** 记录当前的试听音乐所在的tableView*/
@property (nonatomic, strong) UITableView * ownerTableView;
/** 是否已经试听*/
@property (nonatomic, assign) BOOL  isAuditioning;
/** 记录当前点击的音乐model*/
@property (nonatomic, strong) MBMapsModel * selectModel;

/** 音乐试听选择界面*/
@property (nonatomic, strong) MBMusicAuditionView * auditionView;

/** 开启定时器*/
@property (nonatomic, strong) NSTimer * timer;
/** 进度显示器*/
@property (nonatomic, strong) MBProgressHUD * progressHUD;

/** 当前播放的音频链接*/
@property (nonatomic, strong) NSURL * currentAudioURL;

@end

@implementation MBMusicStoreViewModel

SINGLETON_IMPLEMENT(Instance)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isAuditioning = NO;
    }
    return self;
}

- (void)registerViewModelToController:(UIViewController *)controller {
    self.controller = controller;
}
- (void)currentVisiableTableView:(UITableView *)tableView {
    self.tableView = tableView;
    if (self.isAuditioning) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kAdapt(62)+SAFE_INDICATOR_BAR, 0);
    }
}
- (void)downloadMusicTableView:(UITableView *)tableView withModel:(nonnull MBMapsModel *)model {
    self.selectModel = model;
    
    [self downloadSelectMusicWithModel:model];
    
    self.ownerTableView = tableView;
}

- (void)downloadSelectMusicWithModel:(MBMapsModel *)model {
    if (model.path.length) {
        NSString *extension = model.path.pathExtension;
        NSString *fileName = [NSString stringWithFormat:@"%@.%@",[model.path MD5String],extension];
        NSString *filePath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
        
        if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //1.取到当前试听音乐的model
                if (!self.isAuditioning) {  //没有试听过
                    [self showMusicAudtionView];
                }
                //切换试听音乐
                self.auditionView.audioModel = model;
                self.auditionView.localAudioUrl = [NSURL fileURLWithPath:filePath];
                self.currentAudioURL = self.auditionView.localAudioUrl;
            });
        }else {
            [RequestUtil downloadFileWithRequestUrl:model.path downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                CGFloat pro = 1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
                NSLog(@"音乐下载进度  %f",pro);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!self.progressHUD) {
                        self.progressHUD = [MBProgressHUD showUploadOrDownloadProgress:0];
                    }
                    self.progressHUD.progress = pro;
                    self.progressHUD.label.text = @"正在下载";
                    if (pro >= 1.0) {
                        self.progressHUD.label.text = @"下载完成";
                        [self.progressHUD hideAnimated:YES];
                        self.progressHUD = nil;
                    }
                });
            } success:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath) {
                NSLog(@"sdfhjsh %@",filePath);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //1.取到当前试听音乐的model
                    if (!self.isAuditioning) {  //没有试听过
                        [self showMusicAudtionView];
                    }
                    //切换试听音乐
                    self.auditionView.audioModel = model;
                    self.auditionView.localAudioUrl = filePath;
                    self.currentAudioURL = self.auditionView.localAudioUrl;
                });
                
            } failure:^(NSURLResponse * _Nonnull response, NSError * _Nullable error) {
                NSLog(@"sdfhjsh %@",error.description);
            }];
        }
        
    }else {
        [MBProgressHUD showOnlyTextMessage:@"当前的音乐地址不存在"];
    }
    
}

#pragma mark--音乐试听处理---
- (void)showMusicAudtionView {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.auditionView];
    [UIView animateWithDuration:0.3 animations:^{
        self.auditionView.frame = CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(62), SCREEN_WIDTH, SAFE_INDICATOR_BAR+kAdapt(62));
    } completion:^(BOOL finished) {
        self.isAuditioning = YES;
        self.ownerTableView.contentInset = UIEdgeInsetsMake(0, 0, kAdapt(62)+SAFE_INDICATOR_BAR, 0);
    }];
}

- (void)hideMusicAuditionView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.auditionView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SAFE_INDICATOR_BAR+kAdapt(62));
    } completion:^(BOOL finished) {
        [self.auditionView removeFromSuperview];
        self.auditionView = nil;
        self.isAuditioning = NO;
    }];
}

#pragma mark--editCurrentAuditionMusic--
/** 直接使用*/
- (void)directUseCurrentAuditionMusic {
    LOCK
    [self hideMusicAuditionView];
    self.ownerTableView.contentInset = UIEdgeInsetsZero;
    if (self.directBlock) {
        self.directBlock(self.auditionView.localAudioUrl,self.selectModel);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.controller.navigationController popViewControllerAnimated:YES];
        [self goBackEditingController];
    });
    
    UNLOCK
}
/** 剪辑当前试听的音乐*/
- (void)editCurrentAuditionMusic {
    LOCK
    [self hideMusicAuditionView];
    MBMusicEditingView *editingView = [[MBMusicEditingView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SAFE_INDICATOR_BAR+kAdapt(175))];
    editingView.audioUrl = self.currentAudioURL;
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:editingView preferredStyle:TYAlertControllerStyleActionSheet transitionAnimation:TYAlertTransitionAnimationFade];
    __weak typeof(self) weakSelf = self;
    __weak typeof(alert) weakAlert = alert; //防止循环引用
    editingView.closeMusicEditingViewBlock = ^{
        [weakAlert dismissViewControllerAnimated:YES];
    };
    editingView.FinishMusicEditingBlock = ^(CMTime startTime) {
        [weakAlert dismissViewControllerAnimated:YES];
        [weakSelf finishChooseEditingMusicWithBeginTime:startTime];
    };
    
    [self.controller presentViewController:alert animated:YES completion:nil];
    UNLOCK
}

#pragma mark--剪辑界面处理---
- (void)finishChooseEditingMusicWithBeginTime:(CMTime)startTime {

    self.ownerTableView.contentInset = UIEdgeInsetsZero;

    NSString *desPath = [LSOVideoEditor executeAudioCutOut:self.currentAudioURL.path startS:CMTimeGetSeconds(startTime) duration:15.0];
    if (desPath.length) {
        if (self.cropBlock) {
            self.cropBlock(desPath,self.selectModel);
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self goBackEditingController];
//        [self.controller.navigationController popViewControllerAnimated:YES];
    });
}

/** 返回编辑界面*/
- (void)goBackEditingController {
    Class videoEditVC = NSClassFromString(@"MBWordVideoHandlerController");
    for (UIViewController *vc in self.controller.navigationController.viewControllers) {
        if ([vc isKindOfClass:[videoEditVC class]]) {
            [self.controller.navigationController popToViewController:vc animated:YES];
        }
    }
}


#pragma mark--lazy----
/** 音乐预览选择界面*/
- (MBMusicAuditionView *)auditionView {
    if (!_auditionView) {
        _auditionView = [[MBMusicAuditionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SAFE_INDICATOR_BAR+kAdapt(62))];
        _auditionView.delegate = self;
    }
    return _auditionView;
}

@end
