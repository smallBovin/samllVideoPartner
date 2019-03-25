//
//  MBAudioPlayer.m
//  samllVideoPartner
//
//  Created by 李保洋 on 2019/1/2.
//  Copyright © 2019年 bovin. All rights reserved.
//

#import "MBAudioPlayer.h"

@interface MBAudioPlayer ()<AVAudioPlayerDelegate>

/** 音频播放器*/
@property (nonatomic, strong) AVPlayerItem      *playItem;
@property (nonatomic, strong) AVPlayer          *player;
@property (nonatomic, assign) CGFloat          duration;

/** 记录当前的URL*/
@property (nonatomic, strong) NSURL * audioURL;

@end

@implementation MBAudioPlayer


- (void)playerAudioWithUrl:(NSURL *)URL {
    self.audioURL = URL;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    self.playItem = [AVPlayerItem playerItemWithURL:URL];
    self.playItem.audioTimePitchAlgorithm = AVAudioTimePitchAlgorithmTimeDomain;
    self.player = [AVPlayer playerWithPlayerItem:self.playItem];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playItem];
    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
}
- (void)setIsObserverProgress:(BOOL)isObserverProgress {
    _isObserverProgress = isObserverProgress;
    //处理播放进度回调
    if (isObserverProgress) {
        _duration = CMTimeGetSeconds(self.playItem.asset.duration);
        CMTime interval = _duration>60?CMTimeMake(1, 1):CMTimeMake(1, 30);
        __weak typeof(self) weakSelf = self;
        [self.player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            CGFloat current = CMTimeGetSeconds(time);
            CGFloat audioPos = current/weakSelf.duration;
            if (weakSelf.progress) {
                weakSelf.progress(audioPos);
            }
        }];
    }
}

- (void)setVideoSpeed:(CGFloat)speed {
    self.player.rate = speed;
}

- (void)setVolume:(float)volume {
    self.player.volume = volume;
}

- (void)play {
    [self.player play];
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerState:)]) {
        [self.delegate currentPlayerState:MBAudioPlayerStatePlaying];
    }
}

- (void)pause {
    [self.player pause];
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerState:)]) {
        [self.delegate currentPlayerState:MBAudioPlayerStatePaused];
    }
}
- (void)stop {
    [self.player pause];
    [self.playItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.playItem = nil;
    self.player = nil;
}

- (void)reStart {
    [self stop];
    [self playerAudioWithUrl:self.audioURL];
}

- (void)seekToTime:(CMTime)startTime {
    [self.player seekToTime:startTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished) {
            [self.player play];
        }
    }];
}

#pragma mark - KVO属性播放属性监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.playItem.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerState:)]) {
                    [self.delegate currentPlayerState:MBAudioPlayerStateReadyToPlay];
                }
                [self.player play];
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerState:)]) {
                    [self.delegate currentPlayerState:MBAudioPlayerStatePlaying];
                }
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerState:)]) {
                    [self.delegate currentPlayerState:MBAudioPlayerStateFailed];
                }
                
                break;
            default:
                break;
        }
    }
}

#pragma mark-- method--
/** 音频播放完成*/
- (void)playFinished {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayerState:)]) {
        [self.delegate currentPlayerState:MBAudioPlayerStatePlayEnd];
    }
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

@end
