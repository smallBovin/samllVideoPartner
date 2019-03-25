//
//  MBVideoMakeViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBVideoMakeViewController.h"
/** 录音动画进度*/
#import "MBRecordProgressView.h"
/** 底部功能条*/
#import "MBVideoMakeBottomBar.h"
/** 倒计时界面*/
#import "MBCountDownButton.h"
/** 提词器TextView*/
#import "MBPTextView.h"
/** 录音管理类*/
#import "MBRecorderManager.h"

/**跳转界面*/
#import "MBWordVideoHandlerController.h"    //文字视频处理界面
/** 发现界面*/
#import "MBTeachingVideoController.h"
/** 阿里云语音识别*/
#import "MBAliyunRecogniseManager.h"

/****==== 审核状态使用===*/
/** 微信授权登录界面*/
#import "MBWechatLoginView.h"
/** 微信授权登录管理类*/
#import "MBWechatApiManager.h"
/** 绑定手机界面*/
#import "MBBindingMobileViewController.h"
/** 网页加载界面*/
#import "MBProtocolWebViewController.h"


@interface MBVideoMakeViewController ()<MBVideoMakeBottomBarDelegate,MBTZImagePickerDelegate,MBRecorderManagerDelegate,MBAliyunRecogniseManagerDelegate>

/** 顶部的录音进度图*/
@property (nonatomic, strong) MBRecordProgressView * progressView;
/** 底部功能条*/
@property (nonatomic, strong) MBVideoMakeBottomBar * bottomBar;
/** 提词器*/
@property (nonatomic, strong) MBPTextView * textView;
/** 开始录音计时定时器*/
@property (nonatomic, strong) NSTimer * timer;
/** 记录定时器开启的时间*/
@property (nonatomic, assign) int  timeCounting;
/** 临时记录录音按钮*/
@property (nonatomic, strong) UIButton * recordBtn;
/** 记录提词器原始frame*/
@property (nonatomic, assign) CGRect  originFrame;

/** ===阿里云语音识别==*/
@property (nonatomic, strong) MBAliyunRecogniseManager *aliyunRecognise;
/** 第一次说话语音*/
@property (nonatomic, assign) BOOL  isFirstSpeeking;
/** 记录所有的语音识别文字*/
@property (nonatomic, copy) NSString * speekWords;
/** 时间节点与语音识别文字*/
@property (nonatomic, strong) NSMutableArray * dataArray;
/** 静默开始说话的时候记录时间*/
@property (nonatomic, assign) NSInteger  firstBeginTime;
/** 是否需要重新计算开始时间*/
@property (nonatomic, assign) BOOL  needResetBeginTime;
/** 是否是文件识别*/
@property (nonatomic, assign) BOOL  isFileRecognise;
/** 文件识别的音频地址*/
@property (nonatomic, copy) NSString * fileAudioPath;
/** 本地视频路径*/
@property (nonatomic, strong) NSURL * localVideoURL;
/** 临时记录录音按钮*/
@property (nonatomic, strong) MBProgressHUD * gifHud;
/** 是否开始倒计时*/
@property (nonatomic, assign) BOOL  isContingDown;
@end

@implementation MBVideoMakeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"sds,,  %@",[self description]);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"录音制作";
    [self setupSubviews];
    [self registerNotifications];
    self.speekWords = @"";
    self.isFirstSpeeking = NO;
    
}
- (void)setupSubviews {
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.bottomBar];
    [self.view addSubview:self.textView];
    self.originFrame = self.textView.frame;
    [MBRecorderManager shareManager].delegate = self;
    
}

- (void)back {
    if ([MBRecorderManager shareManager].isRecording || self.isContingDown) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isContingDown = NO;
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self refreshNewestVideoThum];
    });
}

- (void)refreshNewestVideoThum {
    if ([TZImageManager manager].authorizationStatusAuthorized) {

        [[TZImageManager manager]getAllAlbums:YES allowPickingImage:NO needFetchAssets:YES completion:^(NSArray<TZAlbumModel *> *models) {
            if (models.count>0) {
                TZAlbumModel *videoModel;
                for (TZAlbumModel *model in models) {
                    if ([model.name isEqualToString:@"Videos"] || [model.name isEqualToString:@"视频"]) {
                        videoModel = model;
                        break;
                    }
                }
                if (videoModel.models.count) {
                    TZAssetModel *assetModel = [videoModel.models lastObject];
                    [[TZImageManager manager]getPhotoWithAsset:assetModel.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.bottomBar.videoImage = photo;
                            NSData *imageData = UIImagePNGRepresentation(photo);
                            [[NSUserDefaults standardUserDefaults]setObject:imageData forKey:kNewestVideoThum];
                        });
                    }];
                }
            }
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MBRecorderManager shareManager]stopRecord];
    [self resetTimer];
    [self.aliyunRecognise stopRecognise];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gifHud hideAnimated:YES];
        self.gifHud = nil;
        //重置进度view
        [self.progressView resetProgressView];
        //改变底部按钮状态
        [self.bottomBar handlerShowWhenRecordState:NO];
        self.isFileRecognise = NO;
    });
}

#pragma mark--获取语音识别的token
- (void)getAliyunRecogniseToken {
    [self.dataArray removeAllObjects];
    
    NSNumber *aliToken = [[NSUserDefaults standardUserDefaults]valueForKey:aliyunTokenExpireTime];
    
    NSTimeInterval nowTime = [[NSDate date]timeIntervalSince1970];
    NSNumber *nowTimenumber = [NSNumber numberWithInteger:nowTime];
    if ([aliToken compare:nowTimenumber] == NSOrderedDescending) {
        if (self.isFileRecognise) {
//            [self.aliyunRecognise startFileRecogniseWithAudioPath:self.fileAudioPath];
            [self fileRecogniseWithFilePath:self.fileAudioPath];
        }else {
            [self handlerCountDownShow];
        }
    }else {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
        NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
        dict[@"token"] = userToken.length?userToken:@"";
        dict[@"openid"] = userOpenid.length?userOpenid:@"";
        [RequestUtil POST:RECOGINIZE_TOKEN_API parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
                NSString *token = responseObject[@"datalist"][@"Id"];
                NSNumber *expireTime = (NSNumber *)responseObject[@"datalist"][@"ExpireTime"];
                if (token.length>0) {
                    [[NSUserDefaults standardUserDefaults]setValue:token forKey:aliyunToken];
                }
                [[NSUserDefaults standardUserDefaults]setValue:expireTime forKey:aliyunTokenExpireTime];
                
                if (self.isFileRecognise) {
//                    [self.aliyunRecognise startFileRecogniseWithAudioPath:self.fileAudioPath];
                    [self fileRecogniseWithFilePath:self.fileAudioPath];
                }else {
                    [self handlerCountDownShow];
                }
            }else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"102"]) {
                [[MBUserManager manager]loginOut];
            }else {
                [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.gifHud hideAnimated:YES];
            [MBProgressHUD showOnlyTextMessage:@"阿里云token获取失败，请稍后再试"];
        }];
    }
    
}


#pragma mark--键盘展示与隐藏时提词器frame处理--
- (void)keyboardWillAppear:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [self.view.window convertRect:rect toView:self.view];
    CGFloat newOriginY = self.originFrame.origin.y+self.originFrame.size.height-keyboardFrame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.textView.frame = CGRectMake(self.originFrame.origin.x, newOriginY, self.originFrame.size.width, self.originFrame.size.height);
    }];
}
- (void)keyboardWillHide:(NSNotification *)noti {
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.frame = self.originFrame;
    }];
}

#pragma mark--MBVideoMakeBottomBarDelegate --
/** 底部功能条发现点击回调*/
- (void)findSomeFunnyVideo {
    LOCK
    MBTeachingVideoController *teachingVC = [MBTeachingVideoController new];
    [teachingVC loadUrl:[NSURL URLWithString:TEACHING_OR_FIND]];
    [self.navigationController pushViewController:teachingVC animated:YES];
    UNLOCK
}
/**开始与结束录音*/
- (void)beginOrEndRecordAudio:(UIButton *)recordBtn {
    if (![[MBUserManager manager]isLogin]) { //审核状态
        [self showWechatAuthoLoginAlert];
    }else {
        [self resetTimer];
        self.recordBtn = recordBtn;
        if (!recordBtn.selected) {  //开始录音
            [self getAliyunRecogniseToken]; //判断是否有效的token
        }else { //结束录音
            [self.aliyunRecognise stopRecognise];
            self.isContingDown = NO;
        }
    }
}
- (void)handlerCountDownShow {
    __weak typeof(self) weakSelf = self;
    self.isContingDown = YES;
    [MBCountDownButton playWithNumber:3 success:^(MBCountDownButton * _Nonnull button) {
        weakSelf.recordBtn.selected = YES;
        [[MBRecorderManager shareManager]startRecordWithFileName:@"MBRecordAudioFile"];
    }];
}
/**选择本地视频库*/
- (void)selectLocalVideoLibrary {
    LOCK
    if ([TZImageManager manager].authorizationStatusAuthorized) {
        [self presentVideoPickerController];
    }else {
        [[TZImageManager manager]requestAuthorizationWithCompletion:^{
            [self presentVideoPickerController];
        }];
    }
    UNLOCK
}
- (void)presentVideoPickerController {
    if (![[MBUserManager manager]isLogin]) { //审核状态
        [self showWechatAuthoLoginAlert];
    }else {
        self.aliyunRecognise = nil;
        [[MBTZImagePicker shareInstance]getLocalAlbumWithType:MBTZImagePickTypeVideo isAutoDismiss:YES isNeedCrop:YES parentController:self delegate:self];
    }
}
#pragma mark--MBTZImagePickerDelegate--
/** 选择视频结束*/
- (void)didFinishPickingVideo:(UIImage *)coverImage cropVideo:(NSURL *)cropUrl {
    if (!self.gifHud) {
        self.gifHud = [MBProgressHUD recogniseAnimationGif];
    }
    self.fileAudioPath = @"";
    self.localVideoURL = cropUrl;
    self.isFileRecognise = YES;
    NSString *audioPath = [LSOVideoEditor executeConvertWav:cropUrl.path dstSample:16000 dstChannel:1];
    if (audioPath.length>0) {
        self.fileAudioPath = audioPath;
        [self getAliyunRecogniseToken]; //判断是否有效的token
        NSLog(@"////??? cropUrl %@ ===audioPath  %@",cropUrl,audioPath);
    }
}


#pragma mark--MBRecorderManagerDelegate--
/** 录音器初始化成功*/
- (void)recorderIsBegin {
    [self.bottomBar handlerShowWhenRecordState:YES];
    [MBProgressHUD showOnlyTextMessage:@"开始录制"];
    self.aliyunRecognise = nil;
    [self.aliyunRecognise startRecognise];
    [self.timer fire];
}
/** 录音器初始化失败*/
- (void)recorderIsFailedWithMsg:(NSString *)msg {
    [MBProgressHUD showOnlyTextMessage:msg];
}

#pragma mark--录音计时器-----
- (void)resetTimer {
    [_timer invalidate];
    _timer = nil;
    self.timeCounting = 0;
}
/** 开始计时*/
- (void)beginCounting {
    self.timeCounting++;
    if ([MBUserManager manager].isVip) {
        if (self.timeCounting>=6000) {
            [self.aliyunRecognise stopRecognise];
        }
    }else {
        if (self.timeCounting>=1500) {
            [self.aliyunRecognise stopRecognise];
        }
    }
    if (self.timeCounting%5 == 0) { //每隔0.05秒处理一次
        //当期录音的振幅大小
        float currentLevel = [MBRecorderManager shareManager].levels;
        [self.progressView addRecorderLevels:[NSNumber numberWithFloat:currentLevel]];
    }
    
    NSString *minute = [NSString stringWithFormat:@"0%d",self.timeCounting/6000];
    NSString *second;
    if (self.timeCounting<1000) {
        second = [NSString stringWithFormat:@"0%d",self.timeCounting/100];
    }else {
        second = [NSString stringWithFormat:@"%d",self.timeCounting/100];
    }
    NSString *msec ;
    if (self.timeCounting%100<10) {
        msec = [NSString stringWithFormat:@"0%d",self.timeCounting%100];
    }else {
        msec = [NSString stringWithFormat:@"%d",self.timeCounting%100];
    }
    self.progressView.time = [NSString stringWithFormat:@"%@:%@:%@",minute,second,msec];
}

#pragma mark--阿里云语音识别------
- (void)recogniseDidBegin {
    [self.dataArray removeAllObjects];
    self.speekWords = @"";
    self.firstBeginTime = 0;
    self.needResetBeginTime = NO;
}
- (void)oneRecogniseBeginWithResult:(NSString *)result {
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSNumber *currentIndex = [[dic objectForKey:@"payload"]objectForKey:@"index"];
    if ([[currentIndex stringValue] isEqualToString:@"1"] ) {
        self.isFirstSpeeking = YES;
        self.firstBeginTime = self.timeCounting*10;
        if (self.isFileRecognise == YES) {
            NSNumber *begin = [[dic objectForKey:@"payload"]objectForKey:@"time"];
            self.firstBeginTime = [begin integerValue];
        }
    }else {
        self.isFirstSpeeking = NO;
    }
    
}
- (void)oneRecogniseEndWithResult:(NSString *)result {

    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@",dic);
    NSString *recogniseWorks = [[dic objectForKey:@"payload"]objectForKey:@"result"];
    if (self.speekWords.length<=0) {
        self.speekWords = recogniseWorks;
    }else {
        self.speekWords = [self.speekWords stringByAppendingString:recogniseWorks];
    }
    NSNumber *beginTime = [[dic objectForKey:@"payload"]objectForKey:@"begin_time"];
    if (self.isFirstSpeeking && [[beginTime stringValue] isEqualToString:@"0"]) {
        self.needResetBeginTime = YES;
        beginTime = [NSNumber numberWithInteger:self.firstBeginTime];
    }
    if (!self.isFirstSpeeking && self.needResetBeginTime) {
        NSInteger newBegin = [beginTime integerValue]+self.firstBeginTime;
        beginTime = [NSNumber numberWithInteger:newBegin];
    }
    
    NSNumber *endTime = [[dic objectForKey:@"payload"]objectForKey:@"time"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:recogniseWorks forKey:@"words"];
    [dict setValue:beginTime forKey:@"begin"];
    [dict setValue:endTime forKey:@"end"];
    [self.dataArray addObject:dict];

}
/** 识别结束*/
- (void)recogniseDidEnd {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isFileRecognise) {
            self.recordBtn.selected = NO;
            self.isContingDown = NO;
            [[MBRecorderManager shareManager]stopRecord];
            [self resetTimer];
            if (!self.gifHud) {
                self.gifHud = [MBProgressHUD recogniseAnimationGif];
            }
        }
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.gifHud hideAnimated:YES];
        self.gifHud = nil;
        if (self.isFileRecognise) {
            for (NSMutableDictionary *dic in self.dataArray) {
                if (self.speekWords.length<=0) {
                    self.speekWords = [dic valueForKey:@"words"];
                }else {
                    self.speekWords = [self.speekWords stringByAppendingString:[dic valueForKey:@"words"]];
                }
            }
        }
        if (self.speekWords.length<=0) {   //
            [MBProgressHUD showOnlyTextMessage:@"没有有效信息，请重录"];
            //删除本地录音文件
            [[MBRecorderManager shareManager]deleteCurrentRecord];
        }else { //识别完成，有内容跳转到文字视频处理界面
            LOCK
            MBWordVideoHandlerController *videoVC = [MBWordVideoHandlerController new];
            videoVC.isFileRecogise = self.isFileRecognise;
            videoVC.fileAudioPath = self.fileAudioPath;
            videoVC.localVideoURL = self.localVideoURL;
            videoVC.speekingWords = self.speekWords;
            videoVC.wordsArray = self.dataArray;
            [self.navigationController pushViewController:videoVC animated:YES];
            UNLOCK
        }
        //重置进度view
        [self.progressView resetProgressView];
        //改变底部按钮状态
        [self.bottomBar handlerShowWhenRecordState:NO];
        self.isFileRecognise = NO;
    });
}

- (void)recogniseFailed {
    [self.dataArray removeAllObjects];
    self.speekWords = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gifHud hideAnimated:YES];
        self.gifHud = nil;
        self.recordBtn.selected = NO;
        self.isContingDown = NO;
        //重置进度view
        [self.progressView resetProgressView];
        //改变底部按钮状态
        [self.bottomBar handlerShowWhenRecordState:NO];
        self.isFileRecognise = NO;
        self.aliyunRecognise = nil;
    });
}

- (void)fileRecogniseWithFilePath:(NSString *)audioFilePath {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *userToken = [[NSUserDefaults standardUserDefaults]objectForKey:kUserToken];
    NSString *userOpenid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserOpenid];
    dict[@"token"] = userToken.length?userToken:@"";
    dict[@"openid"] = userOpenid.length?userOpenid:@"";
    NSData *audioData = [NSData dataWithContentsOfFile:audioFilePath];
    [RequestUtil POST:AliCLOUD_FILE_RECOGNISE_API parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:audioData name:@"file" fileName:self.fileAudioPath mimeType:@"application/octet-stream"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"1"]) {
            [self.dataArray removeAllObjects];
            NSDictionary *tempDic = responseObject[@"datalist"][@"Result"];
            for (NSDictionary *dic in tempDic[@"Sentences"]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:[dic valueForKey:@"BeginTime"] forKey:@"begin"];
                [dict setValue:[dic valueForKey:@"EndTime"] forKey:@"end"];
                NSString *text = [dic valueForKey:@"Text"];
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\p{P}~^<>]" options:NSRegularExpressionCaseInsensitive error:nil];
                text = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
                [dict setValue:text forKey:@"words"];
                [self.dataArray addObject:dict];
            }
            [self recogniseDidEnd];
        }else if ([[NSString stringWithFormat:@"%@",responseObject[@"code"]] isEqualToString:@"102"]) {
            [self recogniseFailed];
            [[MBUserManager manager] loginOut];
        }else {
            [self recogniseFailed];
            [MBProgressHUD showOnlyTextMessage:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.description);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gifHud hideAnimated:YES];
            self.gifHud = nil;
            [MBProgressHUD showOnlyTextMessage:@"识别失败，请稍后再试"];
            //重置进度view
            [self.progressView resetProgressView];
            //改变底部按钮状态
            [self.bottomBar handlerShowWhenRecordState:NO];
            self.isFileRecognise = NO;
            self.aliyunRecognise = nil;
        });
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
/** 录音进度条*/
- (MBRecordProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[MBRecordProgressView alloc]initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, kAdapt(225))];
        _progressView.maxValue = 150;
    }
    return _progressView;
}
/** 底部功能条*/
- (MBVideoMakeBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[MBVideoMakeBottomBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kAdapt(100)-SAFE_INDICATOR_BAR, SCREEN_WIDTH, kAdapt(100)+SAFE_INDICATOR_BAR)];
        _bottomBar.delegate = self;
    }
    return _bottomBar;
}
/** 提词器*/
- (MBPTextView *)textView {
    if (!_textView) {
        _textView = [[MBPTextView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-kAdapt(320))/2, CGRectGetMaxY(self.progressView.frame)+kAdapt(25), kAdapt(320), kAdapt(160))];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.tintColor = [UIColor colorWithHexString:@"#FF0000"];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.textColor = [UIColor colorWithHexString:@"#A4A4A4"];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.placeHolder = @"在这里输入或粘贴想要的文字";
        _textView.placeHolderColor = [UIColor colorWithHexString:@"#A4A4A4"];
    }
    return _textView;
}
/** 懒加载定时器*/
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(beginCounting) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
/** 放置语音的分段与内容*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/** 阿里云*/
- (MBAliyunRecogniseManager *)aliyunRecognise {
    if (!_aliyunRecognise) {
        _aliyunRecognise = [[MBAliyunRecogniseManager alloc]init];
        _aliyunRecognise.delegate = self;
    }
    return _aliyunRecognise;
}

@end
