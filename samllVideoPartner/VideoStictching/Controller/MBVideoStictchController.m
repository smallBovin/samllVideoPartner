//
//  MBVideoStictchController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/18.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBVideoStictchController.h"
#import "MBVideoImageView.h"
/** 设置图片的显示时长*/
#import "MBImageDurationAlert.h"
/** 合成后的预览界面*/
#import "MBPreviewViewController.h"
#import "MBVideoPlayer.h"

typedef NS_ENUM(NSUInteger, MBStictchType) {
    MBStictchTypeOnlyVideo,
    MBStictchTypeOnlyImage,
    MBStictchTypeVideoBeginImage,
    MBStictchTypeVideoEndImage,
};

@interface MBVideoStictchController ()

/** 第一个上传的视频或图片*/
@property (nonatomic, strong)MBVideoImageView *topView;
/** 第二个上传的视频或图片*/
@property (nonatomic, strong)MBVideoImageView *bottomView;
/** 合成按钮*/
@property (nonatomic, strong)UIButton * saveBtn;
/** 合成说明*/
@property (nonatomic, strong) UILabel * tapsLabel;
/** 合成注意事项*/
@property (nonatomic, strong) UILabel * compositionDescLabel;

/** 合成方式*/
@property (nonatomic, assign) MBStictchType  stictchType;

/** 合成类*/
@property (nonatomic, strong) DrawPadConcatVideoExecute *execute;
/** 蓝松转码*/
@property (nonatomic, strong) LSOEditMode *editor;

/** 合成的进图提示*/
@property (nonatomic, strong) MBProgressHUD * comprissionHud;

@end

@implementation MBVideoStictchController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频合成";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.tapsLabel];
    [self.view addSubview:self.compositionDescLabel];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleWhite];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[MBVideoPlayer shareInstance]stop];
}

#pragma mark--action---
/** 合成*/
- (void)compoundStictchingVideo {
    if (self.topView.uploadType == MBUploadDataTypeNone || self.bottomView.uploadType == MBUploadDataTypeNone) {
        [MBProgressHUD showOnlyTextMessage:@"请添加要合成的图片或视频文件"];
        return;
    }
    if (self.topView.uploadType == MBUploadDataTypeImage && self.bottomView.uploadType == MBUploadDataTypeImage) { //图片拼接
        self.stictchType = MBStictchTypeOnlyImage;
        [self chooseImageShowDuration];
    }else if (self.topView.uploadType == MBUploadDataTypeVideo && self.bottomView.uploadType == MBUploadDataTypeVideo) { //视频拼接
        __weak typeof(self) weakSelf = self;
        if ([self makeSureIsNeedTransformWithFirstUrl:self.topView.uploadVideoURL secondUrl:self.bottomView.uploadVideoURL]) {
            [self convertVideoFrameRateWithUrl:self.topView.uploadVideoURL complete:^(NSURL * _Nonnull newPath) {
                NSURL *firstUrl = newPath;
                [weakSelf convertVideoFrameRateWithUrl:self.bottomView.uploadVideoURL complete:^(NSURL * _Nonnull newPath) {
                    [weakSelf videoStictchConcat:firstUrl dstVideo:newPath];
                }];
            }];
        }else {
            [self videoStictchConcat:self.topView.uploadVideoURL dstVideo:self.bottomView.uploadVideoURL];
        }
    }else if (self.topView.uploadType == MBUploadDataTypeImage && self.bottomView.uploadType == MBUploadDataTypeVideo) {
        self.stictchType = MBStictchTypeVideoBeginImage;
        [self insertImage:self.topView.uploadImage atBeginOrEnd:YES imageDuration:self.topView.duration stitchVideoPath:self.bottomView.uploadVideoURL];
    }else { //视频图片拼接
        self.stictchType = MBStictchTypeVideoEndImage;
        [self insertImage:self.bottomView.uploadImage atBeginOrEnd:NO imageDuration:self.bottomView.duration stitchVideoPath:self.topView.uploadVideoURL];
    }
}

/** 两张图片合成视频*/
- (void)chooseImageShowDuration {
    NSString *fileName = [NSString stringWithFormat:@"MBStictchImage_%@.mov",[NSString timestamp]];
    NSString *outPath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
    [self imageStictchVideoToFilePath:outPath duration:self.topView.duration complement:^(NSString *outUrl) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            MBPreviewViewController *previewVC = [MBPreviewViewController new];
            previewVC.videoPath = outUrl;
            [self.navigationController pushViewController:previewVC animated:YES];
        }];
    }];
}


/** 图片拼接视频*/
- (void)imageStictchVideoToFilePath:(NSString *)filePath duration:(float)duration complement:(void(^)(NSString *outUrl))complement {
     NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    CGSize size = CGSizeMake(320, 480);
    if (self.topView.uploadImage) {
        [imageArray addObject:[UIImage scaleImage:self.topView.uploadImage toSize:size]];
    }
    if (self.bottomView.uploadImage) {
        [imageArray addObject:[UIImage scaleImage:self.bottomView.uploadImage toSize:size]];
    }
    
    AVAssetWriter *writer = [[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:filePath] fileType:AVFileTypeQuickTimeMovie error:nil];
    NSParameterAssert(writer);
    //mov的格式设置 编码格式 宽度 高度
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width],AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height],AVVideoHeightKey,nil];
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    
    //    AVAssetWriterInputPixelBufferAdaptor提供CVPixelBufferPool实例,
    //    可以使用分配像素缓冲区写入输出文件。使用提供的像素为缓冲池分配通常
    //    是更有效的比添加像素缓冲区分配使用一个单独的池
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    
    NSParameterAssert([writer canAddInput:writerInput]);
   
    [writer addInput:writerInput];
    [writer startWriting];
    
    [writer startSessionAtSourceTime:kCMTimeZero];
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue",NULL);
    
    int __block frame = 0;
    float totalDuration = 0;
    float firstDuration = 0;
    float secondDuration = 0;
    if (self.stictchType == MBStictchTypeOnlyImage) {
        firstDuration = self.topView.duration;
        secondDuration = self.bottomView.duration;
        totalDuration = firstDuration+secondDuration;
    }else {
        totalDuration = duration;
    }
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData]) {
            if(++frame >= totalDuration*10) {
                [writerInput markAsFinished];
                [writer finishWritingWithCompletionHandler:^{
                    NSLog(@"完成");
                    if (complement) {
                        complement(filePath);
                    }
                }];
                break;
            }
            CVPixelBufferRef buffer = NULL;
            int idx;
            if (self.stictchType == MBStictchTypeOnlyImage) {
                idx = frame / (10*firstDuration);
            }else {
                idx = frame / (10*totalDuration);
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                
            }];
            if (self.stictchType == MBStictchTypeOnlyImage) {
                if (idx == 0) {
                    buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[imageArray objectAtIndex:0]CGImage]size:size];
                }else {
                    buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[imageArray objectAtIndex:1]CGImage]size:size];
                }
            }else {
               buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[[imageArray objectAtIndex:0]CGImage]size:size];
            }
            
            if(buffer){
                //设置每秒钟播放图片的个数
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,10)]) {
                    NSLog(@"FAIL");
                    
                } else {
                    
                    NSLog(@"OK");
                }
                CFRelease(buffer);
            }
        }
    }];

}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
    //    当你调用这个函数的时候，Quartz创建一个位图绘制环境，也就是位图上下文。当你向上下文中绘制信息时，Quartz把你要绘制的信息作为位图数据绘制到指定的内存块。一个新的位图上下文的像素格式由三个参数决定：每个组件的位数，颜色空间，alpha选项
    
    CGContextRef context = CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    //使用CGContextDrawImage绘制图片  这里设置不正确的话 会导致视频颠倒
    
    //    当通过CGContextDrawImage绘制图片到一个context中时，如果传入的是UIImage的CGImageRef，因为UIKit和CG坐标系y轴相反，所以图片绘制将会上下颠倒
 CGContextDrawImage(context,CGRectMake(0,0,CGImageGetWidth(image),CGImageGetHeight(image)), image);
    
    // 释放色彩空间
    CGColorSpaceRelease(rgbColorSpace);
    // 释放context
    CGContextRelease(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}
- (BOOL)makeSureIsNeedTransformWithFirstUrl:(NSURL *)firstUrl secondUrl:(NSURL *)secUrl {
    LSOMediaInfo *info = [[LSOMediaInfo alloc]initWithURL:firstUrl];
    LSOMediaInfo *info1 = [[LSOMediaInfo alloc]initWithURL:secUrl];
    if ([info prepare] && [info1 prepare]) {    //全部可以直接编码
        return NO;
    }else { //需要转码
        return YES;
    }
    return NO;
}
- (void)convertVideoFrameRateWithUrl:(NSURL *)url complete:(void(^)(NSURL* _Nonnull newPath))complement {

     LSOMediaInfo *info = [[LSOMediaInfo alloc]initWithURL:url];
    if ([info prepare]) {
        if (complement) {
            complement(url);
        }
    }else {
        LSOEditMode *editor=[[LSOEditMode alloc] initWithURL:url];
        [editor setProgressBlock:^(CGFloat progess) {
            
        }];
        [editor setCompletionBlock:^(NSString * _Nonnull dstPath) {
            if (complement) {
                complement([NSURL fileURLWithPath:dstPath]);
            }
        }];
        [editor startImport];
    }
}
/** 两个视频合成*/
- (void)videoStictchConcat:(NSURL *)srcVideo dstVideo:(NSURL *)dstVideo {
    
    NSMutableArray *videoArray = [NSMutableArray arrayWithObjects:srcVideo,dstVideo, nil];
    
    self.execute = [[DrawPadConcatVideoExecute alloc]initWithURLArray:videoArray drawPadSize:CGSizeMake(540, 960)];
    __weak typeof(self) weakSelf = self;
    [self.execute setProgressBlock:^(CGFloat progess, CGFloat percent) {
        NSLog(@"视频的合成进度--- %f=== percent=%f",progess,percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.comprissionHud) {
                weakSelf.comprissionHud = [MBProgressHUD showUploadOrDownloadProgress:0];
            }
            weakSelf.comprissionHud.progress = percent;
            weakSelf.comprissionHud.label.text = @"正在导出视频";
            if (percent >= 1.0) {
                weakSelf.comprissionHud.label.text = @"导出视频完成";
                [weakSelf.comprissionHud hideAnimated:YES];
                weakSelf.comprissionHud = nil;
            }
        });
    }];
    [self.execute setCompletionBlock:^(NSString * _Nonnull dstPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideLoadingHUD];
            MBPreviewViewController *previewVC = [MBPreviewViewController new];
            previewVC.videoPath = dstPath;
            [weakSelf.navigationController pushViewController:previewVC animated:YES];
        });
    }];
    [self.execute start];
}

- (void)insertImage:(UIImage *)image atBeginOrEnd:(BOOL)isBegin imageDuration:(float)duration stitchVideoPath:(NSURL *)videoUrl {

    if (isBegin) {  //开始时候是图片
        __weak typeof(self) weakSelf = self;
        NSString *fileName = [NSString stringWithFormat:@"MBStictchImage_%@.mov",[NSString timestamp]];
        NSString *outPath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
        [self imageStictchVideoToFilePath:outPath duration:duration complement:^(NSString *outUrl) {
            LSOMediaInfo *info = [[LSOMediaInfo alloc]initWithURL:videoUrl];
            if ([info prepare]) {
                [weakSelf videoStictchConcat:[NSURL fileURLWithPath:outUrl] dstVideo:videoUrl];
            }else {
                LSOEditMode *editor=[[LSOEditMode alloc] initWithURL:videoUrl];
                [editor setProgressBlock:^(CGFloat progess) {
                    
                }];
                [editor setCompletionBlock:^(NSString * _Nonnull dstPath) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf videoStictchConcat:[NSURL fileURLWithPath:outUrl] dstVideo:[NSURL fileURLWithPath:dstPath]];
                    });
                }];
                
                [editor startImport];
            }
            
        }];
    }else { //结束时是图片
        __weak typeof(self) weakSelf = self;
        NSString *fileName = [NSString stringWithFormat:@"MBStictchImage_%@.mov",[NSString timestamp]];
        NSString *outPath = [[NSString getDocumentPath]stringByAppendingPathComponent:fileName];
        [self imageStictchVideoToFilePath:outPath duration:duration complement:^(NSString *outUrl) {
            LSOMediaInfo *info = [[LSOMediaInfo alloc]initWithURL:videoUrl];
            if ([info prepare]) {
                [weakSelf videoStictchConcat:videoUrl dstVideo:[NSURL fileURLWithPath:outUrl]];
            }else {
                LSOEditMode *editor=[[LSOEditMode alloc] initWithURL:videoUrl];
                [editor setProgressBlock:^(CGFloat progess) {
                    
                }];
                [editor setCompletionBlock:^(NSString * _Nonnull dstPath) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf videoStictchConcat:[NSURL fileURLWithPath:outUrl] dstVideo:[NSURL fileURLWithPath:dstPath]];
                    });
                }];
                [editor startImport];
            }
        }];
    }
}


#pragma mark--lazy--
/** 第一个上传的视频或图片*/
- (MBVideoImageView *)topView {
    if (!_topView) {
        _topView = [[MBVideoImageView alloc]initWithFrame:CGRectMake(kAdapt(38),NAVIGATION_BAR_HEIGHT+kAdapt(32), SCREEN_WIDTH-kAdapt(76), kAdapt(145))];
        _topView.superVC = self;
    }
    return _topView;
}

/** 第一个上传的视频或图片*/
- (MBVideoImageView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MBVideoImageView alloc]initWithFrame:CGRectMake(kAdapt(38), CGRectGetMaxY(self.topView.frame)+kAdapt(25), SCREEN_WIDTH-kAdapt(76), kAdapt(145))];
        _bottomView.superVC = self;
    }
    return _bottomView;
}

/** 保存按钮*/
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(kAdapt(124), CGRectGetMaxY(self.bottomView.frame)+kAdapt(45), kAdapt(126), kAdapt(36));
        [_saveBtn setBackgroundColor:[UIColor colorWithHexString:@"#FD4539"] state:UIControlStateNormal];
        [_saveBtn setTitle:@"合成" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _saveBtn.layer.cornerRadius = kAdapt(18);
        _saveBtn.layer.masksToBounds = YES;
        [_saveBtn addTarget:self action:@selector(compoundStictchingVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}
/** 合成说明*/
- (UILabel *)tapsLabel {
    if (!_tapsLabel) {
        _tapsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAdapt(37), CGRectGetMaxY(self.saveBtn.frame)+kAdapt(49), CGRectGetWidth(self.topView.frame), 20)];
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
        _compositionDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAdapt(37), CGRectGetMaxY(self.tapsLabel.frame)+kAdapt(15), CGRectGetWidth(self.topView.frame), 40)];
        _compositionDescLabel.text = @"1.可以是图片+图片，视频+视频，图片+视频\n2.按时间顺序拼接，生成视频";
        _compositionDescLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _compositionDescLabel.numberOfLines = 0;
        _compositionDescLabel.font = [UIFont systemFontOfSize:13];
        [_compositionDescLabel sizeToFit];
    }
    return _compositionDescLabel;
}
@end
