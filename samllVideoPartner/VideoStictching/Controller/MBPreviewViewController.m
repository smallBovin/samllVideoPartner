//
//  MBPreviewViewController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/17.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBPreviewViewController.h"
#import "MBVideoPlayer.h"

@interface MBPreviewViewController ()

/** 封面图片*/
@property (nonatomic, strong)UIImageView * baseImageView;
/** 播放视频*/
@property (nonatomic, strong)UIButton * playVideoBtn;
/** 视频时长*/
@property (nonatomic, strong) UILabel * videoDurationLabel;
/** 预览按钮*/
@property (nonatomic, strong) UIButton * previewBtn;
/** 保存按钮*/
@property (nonatomic, strong) UIButton * saveBtn;
/** 合成说明*/
@property (nonatomic, strong) UILabel * tapsLabel;
/** 合成注意事项*/
@property (nonatomic, strong) UILabel * compositionDescLabel;

/** 视频的封面图片*/
@property (nonatomic, strong) UIImage * videoCover;


@end

@implementation MBPreviewViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[MBVideoPlayer shareInstance]stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_interactivePopDisabled = YES;
    self.title = @"视频预览";
    self.videoCover = [LSOVideoEditor getVideoImageimageWithURL:[NSURL fileURLWithPath:self.videoPath]];
    self.baseImageView.image = self.videoCover;
    [self setupSubviews];
}

- (void)setupSubviews {
    [self.view addSubview:self.baseImageView];
    
    [self.baseImageView addSubview:self.playVideoBtn];
    [self.baseImageView addSubview:self.videoDurationLabel];
    [self.view addSubview:self.previewBtn];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.tapsLabel];
    [self.view addSubview:self.compositionDescLabel];
    [self.playVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.baseImageView);
        make.width.height.mas_equalTo(kAdapt(37));
    }];
    [self.videoDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseImageView.mas_right).offset(-kAdapt(10));
        make.bottom.equalTo(self.baseImageView.mas_bottom).offset(-kAdapt(10));
    }];
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseImageView.mas_left);
        make.top.equalTo(self.baseImageView.mas_bottom).offset(kAdapt(100));
        make.width.mas_equalTo(kAdapt(126));
        make.height.mas_equalTo(kAdapt(36));
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.baseImageView.mas_right);
        make.top.equalTo(self.baseImageView.mas_bottom).offset(kAdapt(100));
        make.width.mas_equalTo(kAdapt(126));
        make.height.mas_equalTo(kAdapt(36));
    }];
    [self.tapsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseImageView.mas_left);
        make.top.equalTo(self.previewBtn.mas_bottom).offset(kAdapt(45));
    }];
    [self.compositionDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseImageView.mas_left);
        make.top.equalTo(self.tapsLabel.mas_bottom).offset(kAdapt(15));
    }];
}
#pragma mark--overwrite---
- (void)back {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"返回将失去未保存的作品，确定要返回吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[MBVideoPlayer shareInstance]stop];
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    [alert addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark--action---
-(void)playVideoAction{
    if ([[MBVideoPlayer shareInstance]isPlaying]) {
        return;
    }
    self.baseImageView.image = nil;
    AVPlayerLayer *layer = [[MBVideoPlayer shareInstance]createVideoPlayerWithUrl:[NSURL fileURLWithPath:self.videoPath] bounds:self.baseImageView.bounds];
    [self.baseImageView.layer addSublayer:layer];
    __weak typeof(self) weakSelf = self;
    [MBVideoPlayer shareInstance].playFinishedblock = ^(BOOL isFinish) {
        if (isFinish) {
            weakSelf.baseImageView.image = weakSelf.videoCover;
        }
    };
}
/** 预览*/
- (void)previewStictchingVideo {
    [self playVideoAction];
}
/** 保存*/
- (void)saveStictchingVideoToLocal {
    [[MBVideoPlayer shareInstance]stop];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
    [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:self.videoPath] completionBlock:^(NSURL *assetURL, NSError *error) {
        [MBProgressHUD showOnlyTextMessage:@"视频以保存到相册"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

#pragma mark--lazy----
/** 预览封面*/
- (UIImageView *)baseImageView {
    if (!_baseImageView) {
        _baseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-kAdapt(300)/2, NAVIGATION_BAR_HEIGHT+kAdapt(105), kAdapt(300), kAdapt(180))];
        _baseImageView.contentMode = UIViewContentModeScaleAspectFit;
        _baseImageView.layer.masksToBounds = YES;
        _baseImageView.layer.cornerRadius = 5.0;
        _baseImageView.layer.borderColor = [UIColor colorWithHexString:@"E74744"].CGColor;
        _baseImageView.layer.borderWidth = 1.0;
        _baseImageView.userInteractionEnabled = YES;
    }
    return _baseImageView;
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
/** 视频时长*/
- (UILabel *)videoDurationLabel {
    if (!_videoDurationLabel) {
        _videoDurationLabel = [[UILabel alloc]init];
        _videoDurationLabel.textColor = [UIColor whiteColor];
        _videoDurationLabel.textAlignment = NSTextAlignmentRight;
        _videoDurationLabel.font = [UIFont systemFontOfSize:13];
    }
    return _videoDurationLabel;
}
/** 预览按钮*/
- (UIButton *)previewBtn {
    if (!_previewBtn) {
        _previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _previewBtn.layer.cornerRadius = kAdapt(18);
        _previewBtn.layer.masksToBounds = YES;
        [_previewBtn addTarget:self action:@selector(previewStictchingVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previewBtn;
}
/** 保存按钮*/
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _saveBtn.layer.cornerRadius = kAdapt(18);
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn addTarget:self action:@selector(saveStictchingVideoToLocal) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
/** 合成说明*/
- (UILabel *)tapsLabel {
    if (!_tapsLabel) {
        _tapsLabel = [[UILabel alloc]init];
        _tapsLabel.text = @"合成说明:";
        _tapsLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _tapsLabel.font = [UIFont systemFontOfSize:13];
        [_tapsLabel sizeToFit];
    }
    return _tapsLabel;
}
/** 注意事项*/
- (UILabel *)compositionDescLabel {
    if (!_compositionDescLabel) {
        _compositionDescLabel = [[UILabel alloc]init];
        _compositionDescLabel.text = @"1.可以是图片+图片，视频+视频，图片+视频\n2.按时间顺序拼接，生成视频";
        _compositionDescLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _compositionDescLabel.numberOfLines = 0;
        _compositionDescLabel.font = [UIFont systemFontOfSize:13];
        [_compositionDescLabel sizeToFit];
    }
    return _compositionDescLabel;
}
@end
