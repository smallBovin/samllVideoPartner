//
//  MBWordVideoHandlerController.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/25.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBWordVideoHandlerController.h"
/** 底部风格选择bar*/
#import "MBBottomStyleHandlerView.h"
/** 模板选择（风格，贴图）*/
#import "MBTemplateCollectionView.h"
/** 开通VIP的提示框*/
#import "MBOpenVipAlertView.h"
/** 音乐选择界面*/
#import "MBMusicChooseView.h"
/** 背景图选择界面*/
#import "MBBackgroundChooseView.h"
/** 文字编辑界面*/
#import "MBWordEditViewController.h"
/** 音乐库控制器*/
#import "MBMusicStoreViewController.h"
/** 音乐处理类*/
#import "MBMusicStoreViewModel.h"
/** 背景图选择库*/
#import "MBBackgroundThemeController.h"
/** 视频保存成功界面*/
#import "MBVideoSaveSuccessController.h"
/** 录音管理类*/
#import "MBRecorderManager.h"
/** 音频播放器*/
#import "MBAudioPlayer.h"
/** 播放速度选择*/
#import "MBRateSettingView.h"
/** 数据处理类*/
#import "MBVideoEdittingViewModel.h"
/** 贴图处理*/
#import "GYStickerView.h"
#import "MBMapEditingView.h"
/** 音乐model*/
#import "MBMapsModel.h"
/** 模板*/
#import "MBStyleTemplateModel.h"


@interface MBWordVideoHandlerController ()<MBBottomStyleHandlerViewDelegate,MBTemplateCollectionViewDelegate,MBMusicChooseViewDelegate,MBBackgroundChooseViewDelegate,MBTZImagePickerDelegate,MBAudioPlayerDelegate>

/** 底部风格选择控件*/
@property (nonatomic, strong) MBBottomStyleHandlerView * bottomHandlerView;
/** 风格模板选择器*/
@property (nonatomic, strong) MBTemplateCollectionView * styleTemplateView;
/** 贴图模板选择*/
@property (nonatomic, strong) MBTemplateCollectionView * mapsTemplateView;
/** 音乐选择*/
@property (nonatomic, strong) MBMusicChooseView * musicChooseView;
/** 背景图选择*/
@property (nonatomic, strong) MBBackgroundChooseView * bgChooseView;
/** 播放速度选择*/
@property (nonatomic, strong) MBRateSettingView * rateView;
/** 翻转字幕*/
@property (nonatomic, strong) UILabel * rotationLabel;
/** 普通字幕*/
@property (nonatomic, strong) UILabel * normalLabel;
/** 数据请求处理类*/
@property (nonatomic, strong) MBVideoEdittingViewModel * edittingViewModel;
/** 风格数组*/
@property (nonatomic, strong) NSMutableArray * stylesArray;
/** 贴图数组*/
@property (nonatomic, strong) NSMutableArray * mapsArray;
/** 音乐类型数组*/
@property (nonatomic, strong) NSMutableArray * musicTypesArray;
/** 倍速按钮*/
@property (nonatomic, strong) UIButton * rateBtn;
/** 存放贴纸的数组*/
@property (nonatomic, strong) NSMutableArray * stickersArray;

/** 临时存放贴图的bitmap*/
@property (nonatomic, strong) NSMutableArray * bitmapPens;
/** 记录修改后的文字状态*/
@property (nonatomic, strong) NSMutableArray <LSOOneLineText *> *originOneLineArray;
/** ======蓝松文字视频动画处理====*/
/** 文字动画预览类*/
@property (nonatomic, strong) DrawPadAeText * aeTextPriview;
/** 蓝松图像层*/
@property (nonatomic, strong) LanSongView2 * lansongView;
/** aeJSON模板*/
@property (nonatomic, copy) NSString * jsonPath;
/** 记录最初的aeJSON模板*/
@property (nonatomic, copy) NSString * originJsonPath;
/** 蓝松图像层*/
@property (nonatomic, strong) LSOBitmapPen * bgPen;
/** 蓝松视频层*/
@property (nonatomic, strong) LSOVideoPen *videoLayer;
/** 蓝松视频层*/
@property (nonatomic, strong) LSOViewPen *normalView;
/** 普通字幕层*/
@property (nonatomic, strong) UIView * rootView;
/** 普通字幕层*/
@property (nonatomic, strong) UIImageView * subtitleImageView;
/** 合成的进图提示*/
@property (nonatomic, strong) MBProgressHUD * comprissionHud;


/** 当期播放的速度*/
@property (nonatomic, assign) CGFloat currentSpeed;
/** 记录选中的背景图*/
@property (nonatomic, strong) UIImage *selectBgImage;
/** 记录背景图的透明度*/
@property (nonatomic, assign) CGFloat  bgImageAlpha;
/** 当前的背景音乐音量*/
@property (nonatomic, assign) CGFloat  bgMusicVolume;
/** 当前视频音乐音量*/
@property (nonatomic, assign) CGFloat  videoVolume;
/** 记录当前的背景音乐路径*/
@property (nonatomic, strong) NSURL * bgAudioURL;
/** 原音播放*/
@property (nonatomic, strong) MBAudioPlayer * originAudioPlayer;
/** 音频播放*/
@property (nonatomic, strong) MBAudioPlayer * bgMusicAudioPlayer;
/** 是否是普通字幕*/
@property (nonatomic, assign) BOOL isNorlmalWordsShow;
/** 是否需要更新AE模板*/
@property (nonatomic, assign) BOOL isNeedUpdateAEJson;
/** 选中的模板*/
@property (nonatomic, strong) MBStyleTemplateModel *selectTemplateModel;
/** 记录当前要执行的内容*/
@property (nonatomic, assign) int currentIndex;
/**   设置字体*/
@property (nonatomic , copy)NSString *fontName;
@property (nonatomic , copy)NSString *fontTitle;
/** 记录最初内容的数组*/
@property (nonatomic , strong)NSArray *titleArry;

/** 普通字幕拖动*/
@property (nonatomic, assign) CGRect  titleCurrentFrame;
/** 拖普通字幕最初点*/
@property (nonatomic, assign) CGPoint  originalPoint;
/** 记录最后变速*/
@property (nonatomic, assign) CGFloat  lastSpeed;
/** 是否正在导出*/
@property (nonatomic, assign) BOOL  isExporting;

@end

@implementation MBWordVideoHandlerController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar mb_setNavigationBarStyle:MBNavigationBarStyleDark];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startAEPreview];
    /** 请求各项模板的数据*/
    [self loadAllTemplateData];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopAePreview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频预览";
    self.fd_interactivePopDisabled = YES;
    
    self.edittingViewModel = [[MBVideoEdittingViewModel alloc]init];
    
    self.jsonPath = [[NSBundle mainBundle] pathForResource:@"newTest" ofType:@"json"];
    self.originJsonPath = self.jsonPath;
    
    self.bgMusicVolume = 1.0;
    self.videoVolume = 1.0;
    self.currentSpeed = 1.0;
    self.bgImageAlpha = 1.0;
    self.lastSpeed = 0.0;
    self.fontName = @"MicrosoftYaHei";
    self.isNorlmalWordsShow = NO;
    self.isNeedUpdateAEJson = NO;
    /**初始化蓝松*/
    [self configLanSongAETextVideo];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#232323"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveVideoToLocal)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FD4539"],NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [self.view addSubview:self.bottomHandlerView];
    [self.view addSubview:self.rotationLabel];
    [self.view addSubview:self.normalLabel];
    //添加速度选择按钮
    [self.view addSubview:self.rateBtn];
    //风格模板的templateView
    [self.view addSubview:self.styleTemplateView];
    /** 贴图*/
    [self.view addSubview:self.mapsTemplateView];
    //添加音乐选择器
    [self.view addSubview:self.musicChooseView];
    //添加背景图选择器
    [self.view addSubview:self.bgChooseView];
    //速度选择器
    [self.view addSubview:self.rateView];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lansongView.mas_right).offset(-kAdapt(16));
        make.top.equalTo(self.lansongView.mas_top).offset(kAdapt(10));
        make.width.mas_equalTo(kAdapt(65));
        make.height.mas_equalTo(kAdapt(28));
    }];
    [self.rotationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.normalLabel.mas_centerY);
        make.right.equalTo(self.normalLabel.mas_left);
        make.width.mas_equalTo(kAdapt(65));
        make.height.mas_equalTo(kAdapt(28));
    }];
    [self.rateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lansongView.mas_right).offset(-kAdapt(18));
        make.bottom.equalTo(self.lansongView.mas_bottom).offset(-kAdapt(21));
        make.width.mas_equalTo(kAdapt(57));
        make.height.mas_equalTo(kAdapt(32));
    }];
    [self.rateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.rateBtn);
        make.bottom.equalTo(self.rateBtn.mas_top);
        make.height.mas_equalTo(0);
    }];
}

#pragma mark--编辑模板数据处理---
- (void)loadAllTemplateData {
    [self.edittingViewModel getStyleTemplateDataComplement:^(NSMutableArray * _Nullable array) {
        if (array.count>0) {
            [self.stylesArray removeAllObjects];
            [self.stylesArray addObjectsFromArray:array];
            self.styleTemplateView.dataArray = self.stylesArray;
        }
    }];
    [self.edittingViewModel getMapsTemplateDataComplement:^(NSMutableArray * _Nullable array) {
        if (array.count>0) {
            [self.mapsArray removeAllObjects];
            [self.mapsArray addObjectsFromArray:array];
            self.mapsTemplateView.dataArray = self.mapsArray;
        }
    }];
    [self.edittingViewModel getMusicTypeDataComplement:^(NSMutableArray * _Nullable array) {
        if (array.count>0) {
            [self.musicTypesArray removeAllObjects];
            [self.musicTypesArray addObjectsFromArray:array];
        }
    }];
}

#pragma mark--蓝松文字视频处理-----
/** 蓝松文字视频*/
- (void)configLanSongAETextVideo {
    [self.originAudioPlayer stop];
    self.originAudioPlayer = nil;
    [self.bgMusicAudioPlayer stop];
    self.bgMusicAudioPlayer = nil;
    self.aeTextPriview = [[DrawPadAeText alloc]initWithJsonPath:self.jsonPath];
    [self.view insertSubview:self.lansongView atIndex:0];
    UIImage *bgImage;
    if (self.bgPen) {
        [self.aeTextPriview removePen:self.bgPen];
        self.bgPen = nil;
    }
    if (!self.bgPen) {
        if (self.isFileRecogise) {
            bgImage = [UIImage imageWithColor:[UIColor clearColor]];
            self.bgPen = [self.aeTextPriview addBackgroundImage:[bgImage imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
        }else {
            bgImage = [UIImage imageWithColor:[UIColor blackColor]];
            self.bgPen = [self.aeTextPriview addBackgroundImage:[bgImage imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
        }
    }
    if (self.selectBgImage != nil && self.bgPen) {
        [self.bgPen switchBitmap:[self.selectBgImage imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
        [self.bgPen setRGBAPercent:self.bgImageAlpha];
    }
    
    [self.aeTextPriview addLanSongView2:self.lansongView];
    [self loadAETextAudio];
    
    self.aeTextPriview.aeView.hidden = NO;
    if (self.isNorlmalWordsShow) {
        self.aeTextPriview.aeView.hidden = YES;
        if (!self.rootView) {
            self.rootView = [[UIView alloc]init];
        }
        self.rootView.frame = self.lansongView.bounds;
        self.rootView.backgroundColor = [UIColor clearColor];

        if (!self.subtitleImageView) {
            self.subtitleImageView = [[UIImageView alloc]init];
        }
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeTitlePosition:)];
        self.subtitleImageView.userInteractionEnabled = YES;
        [self.subtitleImageView addGestureRecognizer:pan];
        self.subtitleImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.subtitleImageView.image = nil;
        if (CGRectEqualToRect(self.titleCurrentFrame, CGRectZero)) {
            self.subtitleImageView.center = CGPointMake(self.rootView.center.x, self.rootView.center.y+50);
            self.subtitleImageView.bounds = CGRectMake(0, 0, self.lansongView.frame.size.width*3/4, 30);
            self.titleCurrentFrame = self.subtitleImageView.frame;
        }else {
            self.subtitleImageView.frame = self.titleCurrentFrame;
        }
        [self.rootView addSubview:self.subtitleImageView];
        
        [self.view insertSubview:self.rootView aboveSubview:self.lansongView];
        self.rootView.center = self.lansongView.center;
        [self.aeTextPriview addViewPen:self.rootView];
    }else {
        [self.rootView removeFromSuperview];
    }
    __weak typeof(self) weakSelf = self;
    [self.aeTextPriview setFrameProgressBlock:^(BOOL isExport, CGFloat progress, float percent) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf aeProgress:isExport percent:percent progress:progress];
        });
    }];

    [self.aeTextPriview setCompletionBlock:^(BOOL isExport,NSString *path) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isExport){
                [weakSelf drawpadCompleted:path];
            }else {
                if (weakSelf.aeTextPriview != nil) {
                    [weakSelf.aeTextPriview cancel];
                    weakSelf.aeTextPriview = nil;
                }
                [weakSelf startAEPreview];
            }
        });
    }];
}

- (void)loadAETextAudio {
    NSURL *sampleURL;
    if (self.isFileRecogise) {
        sampleURL = [NSURL fileURLWithPath:self.fileAudioPath];
        [self.aeTextPriview setBgVideoPath:self.localVideoURL volume:self.videoVolume];
    }else {
        sampleURL = [NSURL fileURLWithPath:[MBRecorderManager shareManager].tmpAudioSaveName];
        [self addoriginalRecordAudioWithUrl:sampleURL];
    }
    
    AVAsset *assset = [AVAsset assetWithURL:sampleURL];
//    [self.aeTextPriview addAudioPath:sampleURL volume:0.0];
    
    /*
     这两行文字和对应的开始时间, 结束时间都是从 语音后的结果, 你可以是一段文字, 或多段文字.
     如果是一长段文字, 我们内部会分割, 如果是很短的, 则独自一行.
     */
    if (self.wordsArray.count) {
        int index = 0;
        for (NSMutableDictionary *dic in self.wordsArray) {
            NSString *str = [dic objectForKey:@"words"];
            NSNumber *begin = (NSNumber *)[dic valueForKey:@"begin"];
            NSNumber *end = (NSNumber *)[dic valueForKey:@"end"];
            [self.aeTextPriview pushText:str startTime:[begin floatValue]/1000.0/self.currentSpeed endTime:[end floatValue]/1000.0/self.currentSpeed];

            index++;
        }
    }else {
        NSString *allText= self.speekingWords;
        [self.aeTextPriview pushText:allText startTime:0.0 endTime:CMTimeGetSeconds(assset.duration)];
    }
    
    if (self.isNeedUpdateAEJson && self.selectTemplateModel) {
        NSInteger index = 0;
        int useColorNumber = [self.selectTemplateModel.number intValue];
        NSURL *filePath = [[NSBundle mainBundle]URLForResource:[self.selectTemplateModel.font_size lastPathComponent] withExtension:@""];
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)filePath);
        CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        CTFontManagerRegisterGraphicsFont(fontRef, NULL);
        NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
        self.fontName = fontName;
        for (LSOOneLineText *oneLine in self.aeTextPriview.oneLineTextArray) {
            if (index%useColorNumber == 0) {
                oneLine.textColor = [UIColor colorWithHexString:self.selectTemplateModel.color1];
            }else if (index%useColorNumber == 1) {
                oneLine.textColor = [UIColor colorWithHexString:self.selectTemplateModel.color2];
            }else if (index%useColorNumber == 2) {
                oneLine.textColor = [UIColor colorWithHexString:self.selectTemplateModel.color3];
            }else {
                oneLine.textColor = [UIColor colorWithHexString:self.selectTemplateModel.color4];
            }
            index++;
        }
    }
    if (self.originOneLineArray.count && !self.isNeedUpdateAEJson) {
        int lineIndex = 0;
        for (LSOOneLineText *oneLine in self.originOneLineArray) {
            if (self.lastSpeed == 0.0) {
                self.lastSpeed = 1.0;
            }
            float newStartTime = oneLine.startTimeS*self.lastSpeed/self.currentSpeed;
            if (lineIndex == self.originOneLineArray.count-1) {
                oneLine.startTimeS = newStartTime;
                oneLine.endTimeS = oneLine.endTimeS*self.lastSpeed/self.currentSpeed;
            }else {
                oneLine.startTimeS = newStartTime;
            }
            lineIndex++;
        }
        self.lastSpeed = self.currentSpeed;
        self.aeTextPriview.oneLineTextArray = self.originOneLineArray;
    }else {
        for (NSInteger i=0; i<self.aeTextPriview.oneLineTextArray.count; i++) {
            LSOOneLineText *lineText = self.aeTextPriview.oneLineTextArray[i];
            lineText.textImage = [self createImageWithText:lineText.text fontName:self.fontName imageSize:CGSizeMake(lineText.jsonImageWidth, lineText.jsonImageHeight) txtColor:lineText.textColor fontSize:lineText.fontSize];
            [self.aeTextPriview.oneLineTextArray replaceObjectAtIndex:i withObject:lineText];
        }
    }
    if (self.bgAudioURL) {
        [self addBgMusicAudioWithUrl:self.bgAudioURL];
    }
    [self.aeTextPriview updateTextArrayWithConvert:YES];
}
/** 重新设置字体*/
-(UIImage *)createImageWithText:(NSString *)text fontName:(NSString *)fontName imageSize:(CGSize)size txtColor:(UIColor *)textColor fontSize:(CGFloat)fontSize {
    //文字转图片;
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    if (self.isNorlmalWordsShow) {
        style.alignment = NSTextAlignmentCenter;
    }else {
        style.alignment = NSTextAlignmentLeft;
    }
    style.lineBreakMode=NSLineBreakByTruncatingTail;
    //获取高度.
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:fontName size:fontSize],NSFontAttributeName, textColor,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,style,NSParagraphStyleAttributeName, nil];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    [text drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/** 改变字幕的位置*/
- (void)changeTitlePosition:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self.rootView];
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.originalPoint = point;
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        self.titleCurrentFrame = CGRectMake(self.subtitleImageView.frame.origin.x+point.x-self.originalPoint.x, self.subtitleImageView.frame.origin.y+point.y-self.originalPoint.y, self.subtitleImageView.frame.size.width, self.subtitleImageView.frame.size.height);
        self.originalPoint = point;
        self.subtitleImageView.frame = self.titleCurrentFrame;
    }else {
        self.originalPoint = CGPointZero;
    }
}


#pragma mark--处理音频的音量与进度----
- (void)addoriginalRecordAudioWithUrl:(NSURL *)url {
    if (!self.originAudioPlayer) {
        self.originAudioPlayer = [[MBAudioPlayer alloc]init];
    }
    self.originAudioPlayer.delegate = self;
    [self.originAudioPlayer playerAudioWithUrl:url];
    [self.originAudioPlayer setVolume:self.videoVolume];
    
}
- (void)addBgMusicAudioWithUrl:(NSURL *)url {
    if (!self.bgMusicAudioPlayer) {
        self.bgMusicAudioPlayer = [[MBAudioPlayer alloc]init];
    }
    self.bgMusicAudioPlayer.delegate = self;
    [self.bgMusicAudioPlayer playerAudioWithUrl:url];
    [self.bgMusicAudioPlayer setVolume:self.bgMusicVolume];
    
}
- (void)currentPlayerState:(MBAudioPlayerState)playState {
    if (playState == MBAudioPlayerStatePlaying) {
        [self.originAudioPlayer setVideoSpeed:self.currentSpeed];
        [self.bgMusicAudioPlayer setVideoSpeed:self.currentSpeed];
    }
}


//#pragma mark--蓝松AE视频处理----
-(void)startAEPreview
{
    if (self.aeTextPriview == nil) {
        [self configLanSongAETextVideo];
    }
    self.currentIndex = 0;
    [self.originAudioPlayer seekToTime:kCMTimeZero];
    [self.bgMusicAudioPlayer seekToTime:kCMTimeZero];
    [self.aeTextPriview startPreview];
    if (self.isFileRecogise) {
        self.videoLayer = [self.aeTextPriview getPreviewVideoPen];
        self.videoLayer.rate = self.currentSpeed;
        self.videoLayer.avplayer.volume = self.videoVolume;
    }
    [self.aeTextPriview exchangePenPosition:self.bgPen second:self.videoLayer];
    if (self.isNorlmalWordsShow) {
        [self.stickersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[GYStickerView class]]) {
                GYStickerView *sticker = (GYStickerView *)obj;
                [self.view bringSubviewToFront:sticker];
            }
        }];
    }
}

-(void)stopAePreview
{
    if (self.aeTextPriview!=nil) {
        [self.aeTextPriview cancel];
        self.aeTextPriview = nil;
    }
    [self.originAudioPlayer stop];
    [self.bgMusicAudioPlayer stop];
}

-(void)aeProgress:(BOOL)isExport percent:(float) percent progress:(CGFloat)progress {
    if(isExport){  //LSTODO这里应该是百分比
        NSLog(@"percent 正在导出视频dfd   :%f",percent);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.comprissionHud) {
                self.comprissionHud = [MBProgressHUD showUploadOrDownloadProgress:0];
            }
            self.comprissionHud.progress = percent;
            self.comprissionHud.label.text = @"正在导出视频";
            if (percent >= 1.0) {
                self.comprissionHud.label.text = @"导出视频完成";
                [self.comprissionHud hideAnimated:YES];
            }
        });
    }
    if (self.isNorlmalWordsShow) {
        LSOOneLineText *current = self.aeTextPriview.oneLineTextArray[self.currentIndex];
        if (self.currentIndex+1 >= self.aeTextPriview.oneLineTextArray.count) {
            return;
        }
        LSOOneLineText *next = self.aeTextPriview.oneLineTextArray[self.currentIndex+1];
        if (progress >= current.startTimeS) {
            UIImage *tmpImage;
            if (current.text.length<5) {
                tmpImage = [self createImageWithText:current.text fontName:self.fontName imageSize:CGSizeMake(current.jsonImageWidth, current.jsonImageHeight) txtColor:current.textColor fontSize:current.fontSize];
                self.subtitleImageView.image = tmpImage;
            }else {
                self.subtitleImageView.image = current.textImage;
            }
            self.subtitleImageView.frame = self.titleCurrentFrame;
        }
        if (progress >= next.startTimeS) {
            self.currentIndex +=1;
            UIImage *tmpImage;
            if (next.text.length<5) {
                tmpImage = [self createImageWithText:next.text fontName:self.fontName imageSize:CGSizeMake(next.jsonImageWidth, next.jsonImageHeight) txtColor:next.textColor fontSize:next.fontSize];
                self.subtitleImageView.image = tmpImage;
            }else {
                self.subtitleImageView.image = next.textImage;
            }
            self.subtitleImageView.frame = self.titleCurrentFrame;
        }
    }
}


-(void)drawpadCompleted:(NSString *)path
{
    if (self.currentSpeed != 1.0) {
        LSOVideoEditor *ffmpeg=[[LSOVideoEditor alloc] init];
        [ffmpeg setProgressBlock:^(int percent) {
            
        }];
        [ffmpeg setCompletionBlock:^(NSString *dstPath) {
            [LSOMediaInfo checkFile:dstPath];
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:dstPath] completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    LOCK
                    if (self.comprissionHud) {
                        [self.comprissionHud hideAnimated:YES];
                        self.comprissionHud = nil;
                    }
                    MBVideoSaveSuccessController *successVC = [MBVideoSaveSuccessController new];
                    successVC.videoPath = dstPath;
                    [self.navigationController pushViewController:successVC animated:YES];
                    UNLOCK;
                });
            }];
        }];
        NSString *src=[LSOFileUtil urlToFileString:[NSURL fileURLWithPath:path]];
        [ffmpeg startAdjustVideoSpeed:src speed:self.currentSpeed];
    }else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
        [library writeVideoAtPathToSavedPhotosAlbum:[NSURL URLWithString:path] completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LOCK
                if (self.comprissionHud) {
                    [self.comprissionHud hideAnimated:YES];
                    self.comprissionHud = nil;
                }
                MBVideoSaveSuccessController *successVC = [MBVideoSaveSuccessController new];
                successVC.videoPath = path;
                [self.navigationController pushViewController:successVC animated:YES];
                UNLOCK;
            });
        }];
    }
    
    
}


#pragma mark--导航栏右侧保存按钮事件--
- (void)saveVideoToLocal {
    
    if (self.isNorlmalWordsShow) {
        [self.rootView removeFromSuperview];
    }
    if (self.aeTextPriview != nil) {
        [self.aeTextPriview cancel];
    }
    self.currentIndex = 0;
    int index = 1;
    for (GYStickerView *sticker in self.stickersArray) {
        UIView *view = [[UIView alloc]initWithFrame:self.lansongView.bounds];
        view.backgroundColor = [UIColor clearColor];
        CGRect rect = [sticker convertRect:sticker.contentView.frame toView:self.lansongView];
        sticker.frame = rect;
        sticker.selected = NO;
        [view addSubview:sticker];
        UIImage *snapImage = [view snapshotImage];
        LSOBitmapPen *pen = [self.aeTextPriview addLogoBitmap:snapImage];
        [self.aeTextPriview setPenPosition:pen index:index];
        index++;
    }
    
    [self.originAudioPlayer stop];
    [self.bgMusicAudioPlayer stop];
    NSURL *sampleURL;
    if (self.isFileRecogise) {
        sampleURL = [NSURL fileURLWithPath:self.fileAudioPath];
        [self.aeTextPriview setBgVideoPath:self.localVideoURL volume:self.videoVolume];
    }else {
        sampleURL = [NSURL fileURLWithPath:[MBRecorderManager shareManager].tmpAudioSaveName];
        [self.aeTextPriview setAudioPath:sampleURL volume:self.videoVolume];
    }
    
    if (self.bgAudioURL) {
        [self.aeTextPriview removeAllBackGroundAudio];
        [self.aeTextPriview addBackgroundAudio:self.bgAudioURL volume:self.bgMusicVolume loop:YES];
    }
    [self.aeTextPriview startExport];
}

#pragma mark--重写返回事件-----
- (void)back {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"返回将失去未保存的作品，确定要返回吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    [alert addAction:action];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark--MBBottomStyleHandlerViewDelegate---
- (void)bottomStyleHandlerViewButtonType:(MBSelectButtonType)buttonType {
    NSLog(@"ddsf  %lu",(unsigned long)buttonType);
    switch (buttonType) {
        case MBSelectButtonTypeStyle:
            [self showTemplateViewAnimation:MBTemplateTypeStyle];
            break;
        case MBSelectButtonTypeFont:
            [self editVideoWords];
            break;
        case MBSelectButtonTypeMaps:
            [self showTemplateViewAnimation:MBTemplateTypeMaps];
            break;
        case MBSelectButtonTypeMusic:
            [self showMusicChooseView];
            break;
        case MBSelectButtonTypeBackground:
            [self showBackgroundChooseView];
            break;
        default:
            break;
    }
    
}

#pragma mark--模板选择器的处理 MBTemplateCollectionViewDelegate---
- (void)chooseTemplateWithType:(MBTemplateType)type isVipTemplate:(BOOL)isVip stickerImage:(nullable UIImage *)stickerImage templateModel:(nullable MBStyleTemplateModel *)templateModel {
    if ([[MBUserManager manager]isUnderReview]) {
        [self isVipHandlerWithType:type stickerImage:stickerImage templateModel:templateModel];
    }else {
        if (isVip && ![[MBUserManager manager]isVip]) {    //提示开通VIP
            [self showOpenVipAlertView];
        }else { //不是VIP资产或者已开通VIP
            [self isVipHandlerWithType:type stickerImage:stickerImage templateModel:templateModel];
        }
    }
}
- (void)isVipHandlerWithType:(MBTemplateType)type stickerImage:(nullable UIImage *)stickerImage templateModel:(nullable MBStyleTemplateModel *)templateModel {
    if (type == MBTemplateTypeStyle) {  //风格切换
        
        self.selectTemplateModel = templateModel;
        self.isNeedUpdateAEJson = YES;
        if (self.aeTextPriview != nil) {
            [self.aeTextPriview cancel];
            self.aeTextPriview = nil;
        }
        [self startAEPreview];
    
    }else {     //添加贴图
        MBMapEditingView *map = [[MBMapEditingView alloc]initWithFrame:CGRectMake(self.lansongView.center.x-kAdapt(60), self.lansongView.center.y-kAdapt(60), kAdapt(120), kAdapt(120))];
        map.mapImage = stickerImage;
        GYStickerView *sticker = [[GYStickerView alloc]initWithContentView:map];
        sticker.showStickerImage = stickerImage;
        sticker.scaleMode = GYStickerViewScaleModeBounds;
        sticker.ctrlType = GYStickerViewCtrlTypeOne;
        __weak typeof(self) weakSelf = self;
        sticker.DeleteStickerComplete = ^(GYStickerView *sticker) {
            [weakSelf.stickersArray removeObject:sticker];
        };
        [self.view addSubview:sticker];
        [self.stickersArray addObject:sticker];
    }
}
- (void)closeChooseTemplateViewWithType:(MBTemplateType)type {
    if (type == MBTemplateTypeStyle) {
        self.selectTemplateModel = nil;
        self.fontName = @"MicrosoftYaHei";
        self.isNeedUpdateAEJson = NO;
        if (self.aeTextPriview != nil) {
            [self.aeTextPriview cancel];
            self.aeTextPriview = nil;
        }
        [self startAEPreview];
    }else {
        for (GYStickerView *sticker in self.stickersArray) {
            [sticker removeFromSuperview];
        }
        [self.stickersArray removeAllObjects];
    }
    [self hideTemplateView];
}

- (void)finishChooseTemplateWithType:(MBTemplateType)type {
    [self hideTemplateView];
}

- (void)showTemplateViewAnimation:(MBTemplateType)type {
    [UIView animateWithDuration:0.3 animations:^{
        if (type == MBTemplateTypeStyle) {
            self.styleTemplateView.frame = CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(148), SCREEN_WIDTH, kAdapt(148)+SAFE_INDICATOR_BAR);
        }
        if (type == MBTemplateTypeMaps) {
            self.mapsTemplateView.frame = CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(148), SCREEN_WIDTH, kAdapt(148)+SAFE_INDICATOR_BAR);
        }
    }];
}

- (void)hideTemplateView {
    [UIView animateWithDuration:0.3 animations:^{
        self.styleTemplateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(148)+SAFE_INDICATOR_BAR);
        self.mapsTemplateView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(148)+SAFE_INDICATOR_BAR);
    }];
}

#pragma mark--音乐选择器处理-MBMusicChooseViewDelegate--
- (void)closeMusicChooseView {
    [self hideMusicChooseView];
    [self.aeTextPriview removeAllBackGroundAudio];
    [self.aeTextPriview startPreview];
    [self.bgMusicAudioPlayer stop];
    self.bgMusicAudioPlayer = nil;
}

- (void)finishChooseMusic {
    [self hideMusicChooseView];
}

- (void)addOrChangeBackgroundMusic {
    LOCK
    MBMusicStoreViewController *musicVC = [MBMusicStoreViewController new];
    musicVC.musicTypeArray = self.musicTypesArray;
    __weak typeof(self) weakSelf = self;
    [MBMusicStoreViewModel shareInstance].directBlock = ^(NSURL * _Nonnull totalAudioPath, MBMapsModel * _Nonnull model) {
        weakSelf.bgAudioURL = totalAudioPath;
        weakSelf.musicChooseView.musicName = model.title;
        [weakSelf.aeTextPriview removeAllBackGroundAudio];
        [weakSelf.aeTextPriview addBackgroundAudio:totalAudioPath volume:0.0 loop:YES];
        weakSelf.bgAudioURL = totalAudioPath;
        [weakSelf addBgMusicAudioWithUrl:totalAudioPath];
    };
    [MBMusicStoreViewModel shareInstance].cropBlock = ^(NSString * _Nonnull cropPath, MBMapsModel * _Nonnull model) {
        weakSelf.bgAudioURL = [NSURL fileURLWithPath:cropPath];
        weakSelf.musicChooseView.musicName = model.title;
        [weakSelf.aeTextPriview removeAllBackGroundAudio];
        [weakSelf.aeTextPriview addBackgroundAudio:[NSURL fileURLWithPath:cropPath] volume:0.0 loop:YES];
        weakSelf.bgAudioURL = [NSURL fileURLWithPath:cropPath];
        [weakSelf addBgMusicAudioWithUrl:[NSURL fileURLWithPath:cropPath]];
    };
    [self.navigationController pushViewController:musicVC animated:YES];
    UNLOCK
}

- (void)dragSliderToChangeOriginalVideoVolume:(CGFloat)volume {
    self.videoVolume = volume;
    [self.originAudioPlayer setVolume:volume];
    if (self.isFileRecogise) {
        self.videoLayer = [self.aeTextPriview getPreviewVideoPen];
        self.videoLayer.avplayer.volume = self.videoVolume;
    }
}
- (void)dragSliderToChangeBgMusicVolume:(CGFloat)volume {
    self.bgMusicVolume = volume;
    [self.bgMusicAudioPlayer setVolume:volume];
}
- (void)showMusicChooseView {
    [UIView animateWithDuration:0.3 animations:^{
        self.musicChooseView.frame = CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(135), SCREEN_WIDTH, kAdapt(135)+SAFE_INDICATOR_BAR);
    }];
}
- (void)hideMusicChooseView {
    [UIView animateWithDuration:0.3 animations:^{
        self.musicChooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(135)+SAFE_INDICATOR_BAR);
    }];
}
#pragma mark--背景图选择--MBBackgroundChooseViewDelegate--
- (void)closeBackgroundChooseView {
    self.selectBgImage = nil;
    [self hideBackgroundChooseView];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isFileRecogise) {
            UIImage *bgImage = [UIImage imageWithColor:[UIColor clearColor]];
            [self.bgPen switchBitmap:[bgImage imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
        }else {
            UIImage *bgImage = [UIImage imageWithColor:[UIColor blackColor]];
            [self.bgPen switchBitmap:[bgImage imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
        }
    });
}
- (void)finishChooseBackground {
    [self hideBackgroundChooseView];
}
- (void)chooseBackgroundOnStore {
    if ([[MBUserManager manager]isUnderReview]) {
        [self chooseBgImageView];
    }else {
        if ([[MBUserManager manager]isVip]) {
            [self chooseBgImageView];
        }else {
            [self showOpenVipAlertView];
        }
    }
}

- (void)chooseBgImageView {
    LOCK
    MBBackgroundThemeController *themeVC = [MBBackgroundThemeController new];
    __weak typeof(self) weakSelf = self;
    themeVC.bgCompleteAction = ^(UIImage * _Nonnull image) {
        weakSelf.selectBgImage = image;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.bgPen switchBitmap:[image imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
        });
    };
    [self.navigationController pushViewController:themeVC animated:YES];
    UNLOCK
}
- (void)uploadBackgroundFromLocal {
    if ([[MBUserManager manager]isUnderReview]) {
        [[MBTZImagePicker shareInstance]getLocalAlbumWithType:MBTZImagePickTypeImage isAutoDismiss:NO isNeedCrop:YES parentController:self delegate:self];
    }else {
        if ([[MBUserManager manager]isVip]) {
            [[MBTZImagePicker shareInstance]getLocalAlbumWithType:MBTZImagePickTypeImage isAutoDismiss:NO isNeedCrop:YES parentController:self delegate:self];
        }else {
            [self showOpenVipAlertView];
        }
    }
}

- (void)bgImageAlphaWithProgress:(CGFloat)progress {
    self.bgImageAlpha = progress;
    [self.bgPen setRGBAPercent:progress];
}

- (void)showBackgroundChooseView {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgChooseView.frame = CGRectMake(0, SCREEN_HEIGHT-SAFE_INDICATOR_BAR-kAdapt(135), SCREEN_WIDTH, kAdapt(135)+SAFE_INDICATOR_BAR);
    }];
}
- (void)hideBackgroundChooseView {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgChooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(135)+SAFE_INDICATOR_BAR);
    }];
}

#pragma mark--MBTZImagePickerDelegate---
- (void)didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    UIImage *image = [photos firstObject];
    self.selectBgImage = image;
    BOOL ret = [self.bgPen switchBitmap:[image imageScaleToSize:CGSizeMake(kAdapt(282), kAdapt(500))]];
    NSLog(@"切换 背景图  %d",ret);
}

#pragma mark--文字编辑处理界面--
- (void)editVideoWords {
    LOCK
    NSArray *textArry = self.aeTextPriview.oneLineTextArray;
    if (!self.titleArry || self.titleArry.count == 0) {
        NSMutableArray *tempArry = [NSMutableArray array];
        for (NSInteger i=0; i<textArry.count; i++) {
            LSOOneLineText *model = textArry[i];
            NSDictionary *dic = @{@"title":model.text,@"fontSize":@(model.fontSize)};
            [tempArry addObject:dic];
        }
        self.titleArry = tempArry;
    }
    
    MBWordEditViewController *editVC = [MBWordEditViewController new];
    editVC.dataArry = self.aeTextPriview.oneLineTextArray;
    editVC.fontName = self.fontName;
    editVC.fontTitle = self.fontTitle;
    editVC.aeView = self.aeTextPriview.aeView;
    editVC.titleArry = [NSMutableArray arrayWithArray:self.titleArry];
    __weak typeof(self) weakSelf = self;
    editVC.MBWordEditingCompletion = ^(NSMutableArray * _Nonnull textArray, NSString * _Nonnull fongName , NSString * _Nonnull fontTitle , NSMutableArray * _Nonnull titleArry) {
        weakSelf.isNeedUpdateAEJson = NO;
        weakSelf.fontName = fongName;
        weakSelf.fontTitle = fontTitle;
        weakSelf.originOneLineArray = textArray;
        weakSelf.titleArry = titleArry;
    };
    [self.navigationController pushViewController:editVC animated:YES];
    UNLOCK
}

#pragma mark--播放速度处理-----
- (void)selectVideoPlayRate:(UIButton *)sender {
    if (!sender.selected) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.rateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kAdapt(224)+1);
            }];
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            [self.rateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
        }];
    }
    sender.selected =! sender.selected;
}

- (void)videoPlayRateChangeWithRate:(NSString *)rate {
    [UIView animateWithDuration:0.25 animations:^{
        [self.rateView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }completion:^(BOOL finished) {
        [self.rateBtn setTitle:[NSString stringWithFormat:@"%@x",rate] forState:UIControlStateNormal];
        //改变当前的预览速度
        self.rateBtn.selected = NO;
        [self changeVideoAndAudioSpeed:[rate floatValue]];
    }];
}

/** 改变预览速度*/
- (void)changeVideoAndAudioSpeed:(CGFloat)speed {
    self.currentSpeed = speed;
    if (self.aeTextPriview != nil) {
        [self.aeTextPriview cancel];
        self.aeTextPriview = nil;
    }
    [self startAEPreview];
}

#pragma mark--vip弹框----
- (void)showOpenVipAlertView {
    MBOpenVipAlertView *openVipAlert = [[MBOpenVipAlertView alloc]initWithFrame:CGRectMake(0, 0, kAdapt(130), kAdapt(130))];
    TYAlertController *alert = [TYAlertController alertControllerWithAlertView:openVipAlert preferredStyle:TYAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    __weak typeof(alert) weakAlert = alert; //防止循环引用
    openVipAlert.openVip = ^{
        [weakAlert dismissViewControllerAnimated:YES];
        Class class = NSClassFromString(@"MBOpenVipViewController");
        [weakSelf.navigationController pushViewController:[class new] animated:YES];
    };
    alert.backgroundColor = [UIColor clearColor];
    alert.backgoundTapDismissEnable = YES;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark--touch begin---
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.view];
    [self.stickersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[GYStickerView class]]) {
            GYStickerView *sticker = (GYStickerView *)obj;
            if (CGRectContainsPoint(sticker.frame, point)) {
                sticker.selected = YES;
            }else {
                sticker.selected = NO;
            }
        }
    }];
}
#pragma mark--选择字幕类型----
- (void)chooseWordShowType:(UITapGestureRecognizer *)tap {
    if (tap.view == self.rotationLabel) { //旋转字幕
        self.rotationLabel.textColor = [UIColor colorWithHexString:@"#FD4539"];
        self.rotationLabel.backgroundColor = [UIColor whiteColor];
        self.normalLabel.backgroundColor = [UIColor blackColor];
        self.normalLabel.textColor = [UIColor whiteColor];
        self.isNorlmalWordsShow = NO;
    }else { //普通字幕
        self.normalLabel.textColor = [UIColor colorWithHexString:@"#FD4539"];
        self.normalLabel.backgroundColor = [UIColor whiteColor];
        self.rotationLabel.backgroundColor = [UIColor blackColor];
        self.rotationLabel.textColor = [UIColor whiteColor];
        self.isNorlmalWordsShow = YES;
    }
    if (self.aeTextPriview != nil) {
        [self.aeTextPriview cancel];
        self.aeTextPriview = nil;
    }
    [self startAEPreview];
}


#pragma mark--lazy----
/** 风格选择view*/
- (MBBottomStyleHandlerView *)bottomHandlerView {
    if (!_bottomHandlerView) {
        _bottomHandlerView = [[MBBottomStyleHandlerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kAdapt(70)-SAFE_INDICATOR_BAR, SCREEN_WIDTH, kAdapt(70)+SAFE_INDICATOR_BAR)];
        _bottomHandlerView.delegate = self;
    }
    return _bottomHandlerView;
}
/** 风格模板选择器*/
- (MBTemplateCollectionView *)styleTemplateView {
    if (!_styleTemplateView) {
        _styleTemplateView = [[MBTemplateCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(kAdapt(148))+SAFE_INDICATOR_BAR)];
        _styleTemplateView.delegate = self;
        _styleTemplateView.itemSize = CGSizeMake(kAdapt(70), kAdapt(80));
        _styleTemplateView.edgeInset = UIEdgeInsetsMake(0, kAdapt(15), 0, kAdapt(15));
        _styleTemplateView.spaceMargin = kAdapt(10);
        _styleTemplateView.cellCornerRadius = kAdapt(8);
        _styleTemplateView.cellShadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        _styleTemplateView.type = MBTemplateTypeStyle;
    }
    return _styleTemplateView;
}
/** 贴图模板选择器*/
- (MBTemplateCollectionView *)mapsTemplateView {
    if (!_mapsTemplateView) {
        _mapsTemplateView = [[MBTemplateCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(kAdapt(148))+SAFE_INDICATOR_BAR)];
        _mapsTemplateView.delegate = self;
        _mapsTemplateView.itemSize = CGSizeMake(kAdapt(70), kAdapt(80));
        _mapsTemplateView.edgeInset = UIEdgeInsetsMake(0, kAdapt(15), 0, kAdapt(15));
        _mapsTemplateView.spaceMargin = kAdapt(10);
        _mapsTemplateView.cellCornerRadius = kAdapt(8);
        _mapsTemplateView.cellShadowColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        _mapsTemplateView.type = MBTemplateTypeMaps;
    }
    return _mapsTemplateView;
}
/** 音乐选择器*/
- (MBMusicChooseView *)musicChooseView {
    if (!_musicChooseView) {
        _musicChooseView = [[MBMusicChooseView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(kAdapt(135))+SAFE_INDICATOR_BAR)];
        _musicChooseView.delegate = self;
    }
    return _musicChooseView;
}
/** 背景图选择器*/
- (MBBackgroundChooseView *)bgChooseView {
    if (!_bgChooseView) {
        _bgChooseView = [[MBBackgroundChooseView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kAdapt(kAdapt(135))+SAFE_INDICATOR_BAR)];
        _bgChooseView.delegate = self;
    }
    return _bgChooseView;
}
/** 蓝松文字视频层*/
- (LanSongView2 *)lansongView {
    if (!_lansongView) {
        _lansongView = [[LanSongView2 alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-kAdapt(282))/2, NAVIGATION_BAR_HEIGHT+kAdapt(20), kAdapt(282), kAdapt(500))];
        _lansongView.backgroundColor = [UIColor blackColor];
    }
    return _lansongView;
}
/** 播放速度选择器*/
- (MBRateSettingView *)rateView {
    if (!_rateView) {
        _rateView = [[MBRateSettingView alloc]init];
        __weak typeof(self) weakSelf = self;
        _rateView.complement = ^(NSString * _Nonnull rate) {
            [weakSelf videoPlayRateChangeWithRate:rate];
        };
    }
    return _rateView;
}
/** 倍速*/
- (UIButton *)rateBtn {
    if (!_rateBtn) {
        _rateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rateBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];
        [_rateBtn setTitle:@"倍速" forState:UIControlStateNormal];
        [_rateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rateBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rateBtn addTarget:self action:@selector(selectVideoPlayRate:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rateBtn;
}
/** 翻转字幕*/
- (UILabel *)rotationLabel {
    if (!_rotationLabel) {
        _rotationLabel = [[UILabel alloc]init];
        _rotationLabel.backgroundColor = [UIColor whiteColor];
        _rotationLabel.text = @"翻转字幕";
        _rotationLabel.textColor = [UIColor colorWithHexString:@"#FD4539"];
        _rotationLabel.textAlignment = NSTextAlignmentCenter;
        _rotationLabel.font = [UIFont systemFontOfSize:13];
        [_rotationLabel addSingleTapGestureTarget:self action:@selector(chooseWordShowType:)];
        _rotationLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _rotationLabel.layer.borderWidth = 1;
//        [_rotationLabel setCornerRadius:kAdapt(14) rectCornerType:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    }
    return _rotationLabel;
}
/** 倍速*/
- (UILabel *)normalLabel {
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc]init];
        _normalLabel.backgroundColor = [UIColor blackColor];
        _normalLabel.text = @"普通字幕";
        _normalLabel.textColor = [UIColor whiteColor];
        _normalLabel.textAlignment = NSTextAlignmentCenter;
        _normalLabel.font = [UIFont systemFontOfSize:13];
        [_normalLabel addSingleTapGestureTarget:self action:@selector(chooseWordShowType:)];
        _normalLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _normalLabel.layer.borderWidth = 1;
//        [_normalLabel setCornerRadius:kAdapt(14) rectCornerType:UIRectCornerTopLeft|UIRectCornerBottomLeft];
    }
    return _normalLabel;
}


/** 风格数组*/
- (NSMutableArray *)stylesArray {
    if (!_stylesArray) {
        _stylesArray = [NSMutableArray array];
    }
    return _stylesArray;
}
/** 贴图数组*/
- (NSMutableArray *)mapsArray {
    if (!_mapsArray) {
        _mapsArray = [NSMutableArray array];
    }
    return _mapsArray;
}
/** 音乐类型数组*/
- (NSMutableArray *)musicTypesArray {
    if (!_musicTypesArray) {
        _musicTypesArray = [NSMutableArray array];
    }
    return _musicTypesArray;
}
/** 贴纸数组*/
- (NSMutableArray *)stickersArray {
    if (!_stickersArray) {
        _stickersArray = [NSMutableArray array];
    }
    return _stickersArray;
}
/** 贴纸*/
- (NSMutableArray *)bitmapPens {
    if (!_bitmapPens) {
        _bitmapPens = [NSMutableArray array];
    }
    return _bitmapPens;
}

/** 原来的文字处理数组*/
- (NSMutableArray *)originOneLineArray {
    if (!_originOneLineArray) {
        _originOneLineArray = [NSMutableArray array];
    }
    return _originOneLineArray;
}

- (void)dealloc {
    [self.aeTextPriview cancel];
    self.aeTextPriview = nil;
    NSLog(@"释放掉了  %@",[self description]);
}

@end
