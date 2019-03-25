//
//  MBMusicEditingView.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2018/12/27.
//  Copyright © 2018年 bovin. All rights reserved.
//

#import "MBMusicEditingView.h"
/** 音乐播放器*/
#import "MBAudioPlayer.h"

@interface MBMusicEditingView ()<UIScrollViewDelegate,MBAudioPlayerDelegate>{
    NSInteger  duration;
}
/** 关闭按钮*/
@property (nonatomic, strong) UIButton * closeBtn;
/** 完成*/
@property (nonatomic, strong) UIButton * finishBtn;
/** 音乐的s总长度*/
@property (nonatomic, strong) UILabel * totalLabel;
/** 开始剪辑的地方*/
@property (nonatomic, strong) UILabel * editingStartLabel;
/** scrollview*/
@property (nonatomic, strong) UIScrollView * scrollView;
/** 放置音频线的数组*/
@property (nonatomic, strong) NSMutableArray * linesArray;

/** 开启定时器*/
@property (nonatomic, strong) NSTimer * timer;
/** 重复播放定时器*/
@property (nonatomic, strong) NSTimer * repeatPlayTimer;


/** 总共音波线*/
@property (nonatomic, assign) NSInteger  totalLineCount;
/** 开始点*/
@property (nonatomic, assign) NSInteger  startIndex;
/** 记录开始点*/
@property (nonatomic, assign) NSInteger  loopBeginIndex;
/** 开始点*/
@property (nonatomic, assign) CMTime  startPlayTime;

/** 音频播放器*/
@property (nonatomic, strong) MBAudioPlayer * audioPlayer;

@end

@implementation MBMusicEditingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setCornerRadius:kAdapt(20) rectCornerType:UIRectCornerTopLeft|UIRectCornerTopRight];
        [self setupSubviewsAndConstraints];
    }
    return self;
}

- (void)setupSubviewsAndConstraints {
    [self addSubview:self.closeBtn];
    [self addSubview:self.finishBtn];
    [self addSubview:self.totalLabel];
    [self addSubview:self.editingStartLabel];
    [self addSubview:self.scrollView];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(kAdapt(15));
        make.top.equalTo(self.mas_top).offset(kAdapt(11));
        make.width.height.mas_equalTo(kAdapt(16));
    }];
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(12));
        make.right.equalTo(self.mas_right).offset(-kAdapt(13));
        make.width.mas_equalTo(kAdapt(19));
        make.height.mas_equalTo(kAdapt(15));
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.closeBtn.mas_centerY);
    }];
    [self.editingStartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-kAdapt(12)-SAFE_INDICATOR_BAR);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kAdapt(50));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kAdapt(88));
    }];
}

- (void)setAudioUrl:(NSURL *)audioUrl {
    _audioUrl = audioUrl;
    AVAsset *assset = [AVAsset assetWithURL:audioUrl];
    //音乐时长
    duration = CMTimeGetSeconds(assset.duration);
    if (duration>60) {
        self.totalLabel.text = [NSString stringWithFormat:@"左右滑动剪辑音乐(%ld:%ld)",duration/60,duration%60];
    }else {
        self.totalLabel.text = [NSString stringWithFormat:@"左右滑动剪辑音乐(0:%ld)",duration%60];
    }
    
    //处理contentsize
    CGFloat  contentW = duration/15.0*SCREEN_WIDTH;
    self.scrollView.contentSize = CGSizeMake(contentW, kAdapt(88));
    //处理音波个数
    self.totalLineCount = contentW/4.0;
    self.startIndex = 0;
    self.loopBeginIndex = self.startIndex;
    self.startPlayTime = kCMTimeZero;
    [self setupSoundLine];
    if (!self.audioPlayer) {
        self.audioPlayer = [[MBAudioPlayer alloc]init];
    }
    [self.audioPlayer playerAudioWithUrl:self.audioUrl];
    self.audioPlayer.delegate = self;
}

#pragma mark--MBAudioPlayerDelegate--
- (void)currentPlayerState:(MBAudioPlayerState)playState {
    if (playState == MBAudioPlayerStateReadyToPlay) {
        [self.repeatPlayTimer fire];
        [self.timer fire];
    }
}

- (void)setupSoundLine {
    CGFloat space = 2;
    CGFloat width = 2;
    for (NSInteger i= 0; i<self.totalLineCount; i++) {
        CGFloat lineHeight = [self getAudioLineHeightWithIndex:i];
        UIView *audioLine = [[UIView alloc]init];
        audioLine.frame = CGRectMake((space+width)*i, (kAdapt(88)-lineHeight)/2, width, lineHeight);
        audioLine.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        [self.scrollView addSubview:audioLine];
        [self.linesArray addObject:audioLine];
    }
}

- (NSInteger)getAudioLineHeightWithIndex:(NSInteger)index {
    if (index%5 == 0) {
        return  70;
    }else if (index%5 == 1) {
        return  40;
    }else if (index%5 == 2) {
        return  20;
    }else if (index%5 == 3) {
        return  50;
    }else if (index%5 == 4) {
        return  30;
    }
    return 0;
}

- (void)uploadSoungLineColor {
    self.startIndex++;
    if (self.startIndex>=self.totalLineCount) {
        return;
    }

    UIView *view = self.linesArray[self.startIndex];
    view.backgroundColor = [UIColor colorWithHexString:@"#FD4539"];
}

/** 清除所有的颜色*/
- (void)clearAllColorsAudioLine {
    for (UIView *line in self.linesArray) {
        line.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
}

- (void)repeatPlayAudio {
    
    [self clearAllColorsAudioLine];
    self.startIndex = self.loopBeginIndex;
    [self.audioPlayer seekToTime:self.startPlayTime];
    
}

/** 计时器每秒回调处理*/
- (void)beginPlayAudio {
    [self uploadSoungLineColor];
}

- (void)destoryTimer {
    [self.timer invalidate];
    self.timer = nil;
    [self.repeatPlayTimer invalidate];
    self.repeatPlayTimer = nil;
}

#pragma mark--UIScrollViewDelegate--
//开始减速时处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self destoryTimer];
    [self clearAllColorsAudioLine];
    [self.audioPlayer stop];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"结束拖动");
    [self restartPlayAudioWhenScrollviewStop];
}
//减速完成时处理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"减速完成");
    [self restartPlayAudioWhenScrollviewStop];
}
- (void)restartPlayAudioWhenScrollviewStop {
    [self destoryTimer];
    [self.audioPlayer reStart];
    CGFloat offsetX = self.scrollView.contentOffset.x;
    NSInteger currentTime = offsetX/(duration/15.0*SCREEN_WIDTH)*duration;
    self.editingStartLabel.text = [NSString stringWithFormat:@"从%ld:%ld开始",currentTime/60,currentTime%60];
    self.startIndex = self.scrollView.contentOffset.x/4;
    NSInteger perCount = SCREEN_WIDTH/4.0;
    if (self.startIndex+perCount>self.totalLineCount) {
        self.startIndex = self.totalLineCount-perCount-1;
    }
    self.loopBeginIndex = self.startIndex;
    AVAsset *asset = [AVAsset assetWithURL:self.audioUrl];
    self.startPlayTime = CMTimeMakeWithSeconds(currentTime, asset.duration.timescale);
    [self.repeatPlayTimer fire];
    [self.timer fire];
}

#pragma mark--lazy---
/** 关闭按钮*/
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_closeBtn addTapBlock:^(UIButton * _Nonnull btn) {
            [weakSelf destoryTimer];
            [weakSelf.audioPlayer stop];
            if (self.closeMusicEditingViewBlock) {
                self.closeMusicEditingViewBlock();
            }
            weakSelf.audioPlayer = nil;
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(closeMusicEditingView)]) {
                [weakSelf.delegate closeMusicEditingView];
            }
        }];
    }
    return _closeBtn;
}
/** 完成按钮*/
- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setImage:[UIImage imageNamed:@"finish"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [_finishBtn addTapBlock:^(UIButton * _Nonnull btn) {
            [weakSelf destoryTimer];
            [weakSelf.audioPlayer stop];
            weakSelf.audioPlayer = nil;
            if (weakSelf.FinishMusicEditingBlock) {
                weakSelf.FinishMusicEditingBlock(weakSelf.startPlayTime);
            }
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(finishChooseEditingMusicWithBeginTime:)]) {
                [weakSelf.delegate finishChooseEditingMusicWithBeginTime:weakSelf.startPlayTime];
            }
        }];
    }
    return _finishBtn;
}
/** 音乐总时间*/
- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc]init];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _totalLabel.font = [UIFont systemFontOfSize:11];
        _totalLabel.text = @"左右滑动剪辑音乐(3:50)";
        [_totalLabel sizeToFit];
    }
    return _totalLabel;
}
/** 开始剪辑的位置*/
- (UILabel *)editingStartLabel {
    if (!_editingStartLabel) {
        _editingStartLabel = [[UILabel alloc]init];
        _editingStartLabel.textAlignment = NSTextAlignmentCenter;
        _editingStartLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _editingStartLabel.font = [UIFont systemFontOfSize:11];
        _editingStartLabel.text = @"从00:00开始";
        [_editingStartLabel sizeToFit];
    }
    return _editingStartLabel;
}
/** 音频线*/
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
/** 数组*/
- (NSMutableArray *)linesArray {
    if (!_linesArray) {
        _linesArray = [NSMutableArray array];
    }
    return _linesArray;
}
/** 定时器*/
- (NSTimer *)timer {
    if (!_timer) {
        NSTimeInterval interval = 15.0/(SCREEN_WIDTH/4.0);
        _timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(beginPlayAudio) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
/** 定时器*/
- (NSTimer *)repeatPlayTimer {
    if (!_repeatPlayTimer) {
        NSTimeInterval interval = 15.0;
        _repeatPlayTimer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(repeatPlayAudio) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_repeatPlayTimer forMode:NSRunLoopCommonModes];
    }
    return _repeatPlayTimer;
}

- (void)dealloc {
    [self destoryTimer];
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    NSLog(@"%@==== 释放了",[self description]);
}
@end

