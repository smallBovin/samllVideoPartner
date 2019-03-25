//
//  MBVideoEditingViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBVideoEditingViewController.h"
/** 底部编辑view*/
#import "MBVideoEditingView.h"

@interface MBVideoEditingViewController ()<MBVideoEditingViewDelegate>

/** 视频播放器*/
@property (nonatomic, strong) AVPlayerItem      *playItem;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;
@property (nonatomic, strong) AVPlayer          *player;
/**视频帧数组*/
@property (nonatomic, strong) NSMutableArray    *framesArray;
/** 视频的封面图片*/
@property (nonatomic, strong) UIImage * cover;
/** 剪辑后的视频存放路径*/
@property (nonatomic, copy) NSString * cropVideoPath;
/**编辑框内视频开始时间秒*/
@property (nonatomic, assign) CGFloat   startTime;
/**编辑框内视频结束时间秒*/
@property (nonatomic, assign) CGFloat   endTime;
/** 是否编辑过*/
@property (nonatomic, assign) BOOL  isEdited;

/** 循环播放计时器*/
@property (nonatomic, strong) NSTimer * repeatTimer;
/**播放条移动计时器*/
@property (nonatomic, strong) NSTimer * lineMoveTimer;
/** 底部的编辑条*/
@property (nonatomic, strong) MBVideoEditingView * editingView;
/** 处理视频生成*/
@property (nonatomic, strong) MBProgressHUD * loadHUD;

@end

@implementation MBVideoEditingViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self destoryTimer];
    [self.playItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.player = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频剪辑";
    self.fd_interactivePopDisabled = YES;
    [self.view addSubview:self.editingView];
    self.isEdited = NO;
}

/** 重写返回方法*/
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setModel:(TZAssetModel *)model {
    _model = model;
    [[TZImageManager manager] getPhotoWithAsset:_model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (!isDegraded && photo) {
            self->_cover = photo;
        }
    }];
    [[TZImageManager manager] getVideoWithAsset:_model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AVAsset *asset = playerItem.asset;
            [self analysisVideoFramesWithAsset:asset];
            
            [self initPlayerWithVideoWithPlayItem:playerItem];
        });
    }];
}

#pragma mark  - 读取解析视频帧
- (void)analysisVideoFramesWithAsset:(AVAsset *)asset {
    // 获取总视频的长度 = 总帧数 / 每秒的帧数
    long videoSumTime = asset.duration.value / asset.duration.timescale;
    self.editingView.asset = asset;
    // 创建AVAssetImageGenerator对象
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    // 添加需要帧数的时间集合
    self.framesArray = [NSMutableArray array];
    for (int i = 0; i < videoSumTime; i++) {
        CMTime time = CMTimeMake(i *asset.duration.timescale , asset.duration.timescale);
        NSValue *value = [NSValue valueWithCMTime:time];
        [self.framesArray addObject:value];
    }
    __block long count = 0;
    __weak typeof(self) weakSelf = self;
    NSMutableArray *images = [NSMutableArray array];
    [generator generateCGImagesAsynchronouslyForTimes:self.framesArray completionHandler:^(CMTime requestedTime, CGImageRef img, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        
        if (result == AVAssetImageGeneratorSucceeded) {
            NSLog(@"%ld",count);
            long scale = weakSelf.framesArray.count/9;
            if (weakSelf.framesArray.count>9) {
                if (count%scale == 0) {
                    UIImage *image = [UIImage imageWithCGImage:img];
                    [images addObject:image];
                }
            }else {
                UIImage *image = [UIImage imageWithCGImage:img];
                [images addObject:image];
            }
            if (self.framesArray.count-1 == count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.editingView.imageArray = images;
                });
            }
            count++;
        }
        if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
        }
        if (result == AVAssetImageGeneratorCancelled) {
            NSLog(@"AVAssetImageGeneratorCancelled");
        }
    }];
}

#pragma mark - 初始化player
- (void)initPlayerWithVideoWithPlayItem:(AVPlayerItem *)playItem {
    // 手机静音时可播放声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.playItem = playItem;
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    self.playerLayer.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(200));
    [self.view.layer addSublayer:self.playerLayer];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
}

#pragma mark - KVO属性播放属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                [self.player play];
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }
}
- (void)playFinished {
    if (self.isEdited) {
        [self startTimer];
    }else {
        [self destoryTimer];
        [self.player seekToTime:CMTimeMake(0, 1)];
        [self.player play];
    }
}

- (void)startTimer {
    if (self.isEdited) {
        NSTimeInterval duration = self.endTime - self.startTime;
        self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(repeatPlayer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.repeatTimer forMode:NSRunLoopCommonModes];
        [self.repeatTimer fire];
    }
//    self.lineMoveTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(lineMove) userInfo:nil repeats:YES];
    
}
- (void)destoryTimer {
    [self.repeatTimer invalidate];
    self.repeatTimer = nil;
//    [self.lineMoveTimer invalidate];
//    self.lineMoveTimer = nil;
}
#pragma mark--开始循环预览---
- (void)repeatPlayer {
    [self.player seekToTime:CMTimeMakeWithSeconds(self.startTime, self.playItem.asset.duration.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

- (void)lineMove {
    
}


#pragma mark--MBVideoEditingViewDelegate--
/** 拖拽开始*/
- (void)beginDragToCropVideo {
    [self destoryTimer];
}
/** 拖拽中*/
- (void)dragingToChangeCurrentPlayerVideoFrameWithStartTime:(CMTime)startTime flag:(BOOL)flag {

    if (flag) {
        [self.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}
/**拖拽结束*/
- (void)dragedWithCropVideoStartTime:(CMTime)startTime endTime:(CMTime)endTime {
    self.isEdited = YES;
    self.startTime = CMTimeGetSeconds(startTime);
    self.endTime = CMTimeGetSeconds(endTime);
    [self startTimer];
}

/** 下一步，上传剪辑好的视频*/
- (void)saveAndUploadfinishEditedVideo {
    [self saveEditedVideoToLocal];
}
- (void)saveEditedVideoToLocal {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.cropVideoPath = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"MBCropVideo_%@.mp4",[NSString timestamp]]];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                           initWithAsset:self.playItem.asset presetName:AVAssetExportPresetMediumQuality];
    
    NSURL *furl = [NSURL fileURLWithPath:self.cropVideoPath];
    exportSession.outputURL = furl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    CMTime start = CMTimeMakeWithSeconds(self.startTime, self.player.currentTime.timescale);
    CMTime duration = CMTimeMakeWithSeconds(self.endTime - self.startTime, self.player.currentTime.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.loadHUD) {
            self.loadHUD = [MBProgressHUD showLoadingWithMessage:@"正在上传视频..."];
        }
    });
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
                
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                break;
                
            case AVAssetExportSessionStatusCompleted:{
                NSLog(@"Export completed");
                __weak typeof(self) weakSelf = self;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.loadHUD hideAnimated:YES];
                    [weakSelf handleUploadEditedVideo];
                });
            }
                break;
                
            default:
                NSLog(@"Export other");
                
                break;
        }
    }];
}

- (void)deleteTempFile{
    NSURL *url = [NSURL fileURLWithPath:self.cropVideoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL exist = [fm fileExistsAtPath:url.path];
    NSError *err;
    if (exist) {
        [fm removeItemAtURL:url error:&err];
        NSLog(@"file deleted");
        if (err) {
            NSLog(@"file remove error, %@", err.localizedDescription );
        }
    }else {
        [fm createDirectoryAtPath:self.cropVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"no file by that name");
    }
}
- (void)handleUploadEditedVideo {
    if (self.navigationController) {
        TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
        if (imagePickerVc.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self callDelegateMethod];
            }];
        } else {
            [self callDelegateMethod];
        }
    }
}
- (void)callDelegateMethod {
    TZImagePickerController *imagePickerVc = (TZImagePickerController *)self.navigationController;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideo:cropVideo:)]) {
        [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingVideo:self.cover cropVideo:[NSURL fileURLWithPath:self.cropVideoPath]];
    }
}

#pragma mark ---lazy---
/** 底部的编辑view*/
- (MBVideoEditingView *)editingView {
    if (!_editingView) {
        _editingView = [[MBVideoEditingView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(200), SCREEN_WIDTH, kAdapt(200)+SAFE_INDICATOR_BAR)];
        _editingView.delegate = self;
    }
    return _editingView;
}
- (NSMutableArray *)framesArray{
    if (!_framesArray) {
        _framesArray = [NSMutableArray array];
    }
    return _framesArray;
}

@end
