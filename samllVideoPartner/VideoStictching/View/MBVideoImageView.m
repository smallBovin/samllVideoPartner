//
//  MBVideoImageView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/8.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBVideoImageView.h"
/** 剪裁*/
#import "PECropRectView.h"
/** 设置图片的显示时长*/
#import "MBImageDurationAlert.h"
#import "MBVideoPlayer.h"

@interface MBVideoImageView()<MBTZImagePickerDelegate>

/** 背景图片*/
@property (nonatomic, strong)UIImageView * baseImageView;
/** 本地上传*/
@property (nonatomic, strong)UIButton * uploadBtn;
/** 播放视频*/
@property (nonatomic, strong)UIButton * playVideoBtn;

/** 视频播放器*/
@property (nonatomic, strong) AVPlayerItem      *playItem;
@property (nonatomic, strong) AVPlayerLayer     *playerLayer;
@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, strong) NSURL *videoUrl;

/** 记录封面图片*/
@property (nonatomic, strong) UIImage * videoCoverImage;


@end

@implementation MBVideoImageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
        self.uploadType = MBUploadDataTypeNone;
    }
    return self;
}

-(void)creatSubView{
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor colorWithHexString:@"E74744"].CGColor;
    self.layer.borderWidth = 1.0;
    [self addSubview:self.baseImageView];
    [self addSubview:self.uploadBtn];
    [self.baseImageView addSubview:self.playVideoBtn];
    [self.baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [self.playVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.baseImageView);
        make.width.height.mas_equalTo(kAdapt(40));
    }];
}

#pragma mark--getter---
- (NSURL *)uploadVideoURL {
    return self.videoUrl;
}
- (UIImage *)uploadImage {
    if (self.uploadType == MBUploadDataTypeImage) {
        return self.baseImageView.image;
    }
    return nil;
}

#pragma mark--图片视频选择---
-(void)uploadLocalVideoImage{
    if (self.uploadType != MBUploadDataTypeNone) {
        return;
    }
    [[MBTZImagePicker shareInstance]getLocalAlbumWithType:MBTZImagePickTypeAll isAutoDismiss:YES isNeedCrop:YES parentController:self.superVC delegate:self];
}

#pragma mark--MBTZImagePickerDelegate---
- (void)didFinishPickingVideo:(UIImage *)coverImage cropVideo:(NSURL *)cropUrl {
    self.baseImageView.hidden = NO;
    self.playVideoBtn.hidden = NO;
    self.uploadBtn.hidden = YES;
    self.uploadType = MBUploadDataTypeVideo;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.baseImageView.image = coverImage;
        self.videoCoverImage = coverImage;
        self.videoUrl = cropUrl;
    });
}
- (void)didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    NSLog(@"选择完成");
    self.baseImageView.hidden = NO;
    self.uploadBtn.hidden = YES;
    self.playVideoBtn.hidden = YES;
    self.uploadType = MBUploadDataTypeImage;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.baseImageView.image = [photos firstObject];
        [self chooseImageShowDuration];
    });
}
/** 有图片的拼接是弹框是指图片的显示时间*/
- (void)chooseImageShowDuration {
    MBImageDurationAlert *loginView = [[MBImageDurationAlert alloc]initWithFrame:CGRectMake(0, 0, kAdapt(290), kAdapt(180))];
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:loginView preferredStyle:TYAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    __weak typeof(alert) weakAlert = alert; //防止循环引用
    loginView.cancelBlock = ^{
        [weakAlert dismissViewControllerAnimated:YES];
    };
    loginView.successBlock = ^(float duration) {
        [weakAlert dismissViewControllerAnimated:YES];
        weakSelf.duration = duration;
    };
    alert.view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.superVC presentViewController:alert animated:YES completion:nil];
}

#pragma mark--action---
-(void)playVideoAction{
    if ([[MBVideoPlayer shareInstance]isPlaying]) {
        return;
    }
    AVPlayerLayer *layer = [[MBVideoPlayer shareInstance]createVideoPlayerWithUrl:self.videoUrl bounds:self.baseImageView.bounds];
    [self.baseImageView.layer addSublayer:layer];
    self.baseImageView.image = nil;
    __weak typeof(self) weakSelf = self;
    [MBVideoPlayer shareInstance].playFinishedblock = ^(BOOL isFinish) {
        if (isFinish) {
            weakSelf.baseImageView.image = weakSelf.videoCoverImage;
        }
    };
}

#pragma mark--lazy----
/** */
- (UIImageView *)baseImageView {
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc]init];
        _baseImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_baseImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadLocalVideoImage)]];
        _baseImageView.userInteractionEnabled = YES;
        _baseImageView.layer.cornerRadius = 5.0;
        _baseImageView.clipsToBounds = YES;
        _baseImageView.hidden = YES;
    }
    return _baseImageView;
}

/** 上传视频按钮*/
- (UIButton *)uploadBtn {
    if (!_uploadBtn) {
        _uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _uploadBtn.backgroundColor = [UIColor clearColor];
        [_uploadBtn setImage:[UIImage imageNamed:@"upload_video"] forState:UIControlStateNormal];
        [_uploadBtn setImage:[UIImage imageNamed:@"upload_video"] forState:UIControlStateHighlighted];
        [_uploadBtn setTitle:@"本地上传" forState:UIControlStateNormal];
        [_uploadBtn setTitleColor:[UIColor colorWithHexString:@"#E74744"] forState:UIControlStateNormal];
        _uploadBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _uploadBtn.type = MBButtonTypeTopImageBottomTitle;
        _uploadBtn.spaceMargin = kAdapt(20);
        [_uploadBtn addTarget:self action:@selector(uploadLocalVideoImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadBtn;
}

/** 播放按钮*/
- (UIButton *)playVideoBtn {
    if (!_playVideoBtn) {
        _playVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playVideoBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateNormal];
        [_playVideoBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateHighlighted];
        [_playVideoBtn addTarget:self action:@selector(playVideoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playVideoBtn;
}

@end
